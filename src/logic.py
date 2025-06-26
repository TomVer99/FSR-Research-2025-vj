import numpy as np
import pandas as pd
import datetime
import pytz
from src.algos import detect_presence

NANO_SECONDS_PER_SECOND = 1e9

def combine(a, b):
    """
    Combines two NumPy arrays along the first axis.
    Args:
        a (np.ndarray): First array to combine.
        b (np.ndarray): Second array to combine.
    Returns:
        np.ndarray: Combined array with elements from both input arrays.
    """
    return np.concatenate((a, b), axis=0)

def trim_to_minimum(a, b):
    """
    Trims two NumPy arrays to the minimum length of the two.
    Args:
        a (np.ndarray): First array to trim.
        b (np.ndarray): Second array to trim.
    Returns:
        tuple: Two trimmed NumPy arrays with the same length.
    """
    min_len = min(len(a), len(b))
    a = a[:min_len]
    b = b[:min_len]
    return a, b

def write_bland_altman_to_file(file_path, data, md, sd):
    with open(file_path, 'w') as f:
        f.write("#let data = (\n")
        for value in data:
            f.write(f"({value[0]}, {value[1]}),\n")
        f.write(")\n")
        
        f.write(f"#let data_md = {md}\n")
        f.write(f"#let data_sd = {sd}\n")

def take_time_chunk_from_signal(signal, start_time, duration_sec):
    """
    Takes a chunk of the signal starting from start_time for duration_sec seconds.
    
    Args:
        signal (np.ndarray): The input signal with timestamps in nanoseconds.
        start_time (int): Start time in nanoseconds.
        duration_sec (int): Duration in seconds to take from the signal.
        
    Returns:
        tuple: A tuple containing:
            - np.ndarray: The chunk of the signal with timestamps in nanoseconds.
            - bool: True if the signal is clipped at the end, False otherwise.
    """
    end_time = start_time + duration_sec * NANO_SECONDS_PER_SECOND

    # Check if the signal has timestamps that overlap with the requested time range
    if signal[0, 0] > end_time or signal[-1, 0] < start_time:
        return None
    
    # Indicate if the signal is clipped at the end
    if signal[-1, 0] < end_time:
        clipped = True
    else:
        clipped = False

    mask = (signal[:, 0] >= start_time) & (signal[:, 0] <= end_time)
    return signal[mask], clipped

def read_polar_file(file_path):
    """
    Reads a Polar file and returns the data as a NumPy array.
    
    Args:
        file_path (str): Path to the Polar file.
        
    Returns:
        tuple: Three NumPy arrays containing ECG, HR, and RR data.
            Each array contains two columns: timestamp and value.
            The timestamp is in epoch format (int64).
            The value is in float64 format.
        If required columns are missing, returns (None, None, None).
    """
    UNIX_TIMESTAMP_COL = 'UNIX Timestamp'
    ECG_COL = 'ECG'
    HR_COL = 'HR'
    RR_COL = 'RR'

    df = pd.read_csv(file_path)

    if UNIX_TIMESTAMP_COL not in df.columns or ECG_COL not in df.columns or HR_COL not in df.columns or RR_COL not in df.columns:
        return None, None, None

    ecg = np.column_stack((df[UNIX_TIMESTAMP_COL].astype(np.int64), df[ECG_COL].astype(np.float64)))

    hr_valid = df[[UNIX_TIMESTAMP_COL, HR_COL]].dropna(subset=[HR_COL])
    hr = np.column_stack((hr_valid[UNIX_TIMESTAMP_COL].astype(np.int64), hr_valid[HR_COL].astype(np.float64)))

    rr_valid = df[[UNIX_TIMESTAMP_COL, RR_COL]].dropna(subset=[RR_COL])
    rr = np.column_stack((rr_valid[UNIX_TIMESTAMP_COL].astype(np.int64), rr_valid[RR_COL].astype(np.float64)))

    return ecg, hr, rr

def read_teensy_file(file_path, extrapolate=False, fs=None, offset=0):
    """
    Reads a Teensy file and returns the data as a NumPy array.
    
    Args:
        file_path (str): Path to the Teensy file.   
        extrapolate (bool): If True, extrapolates the initial epoch timestamp.
        fs (int, optional): Sampling frequency in Hz. Required if extrapolate is True.
        offset (int, optional): Offset in seconds to apply to the start time.
        
    Returns:
        if extrapolate is False:
        np.ndarray: Data read from the Teensy file.
        int: Epoch number extracted from the file.
        if extrapolate is True:
        np.ndarray: Data with timestamps extrapolated based on the sampling frequency.
        None: If extrapolation is requested but fs is None.
    """

    if extrapolate and fs is None:
        return None, None

    with open(file_path, 'r') as file:
        lines = file.readlines()
        epoch = int(lines[4].split(' ')[-1])
        epoch += offset * NANO_SECONDS_PER_SECOND  # Apply offset in seconds

    data_lines = lines[6:]
    data = [float(line.strip()) for line in data_lines if line.strip()]

    if extrapolate:
        # Calculate the time step in nanoseconds
        time_step_ns = int(NANO_SECONDS_PER_SECOND / fs)
        timestamps = np.array([epoch + i * time_step_ns for i in range(len(data))], dtype=np.int64)
        data = np.column_stack((timestamps, np.array(data, dtype=np.float64)))
        return data
    else:
        return np.array(data), epoch


def sync_data_sources_to_timestamp(bcg, ecg, hr, rr, offset=0, duration=None):
    """
    Synchronizes BCG, ECG, HR, and RR data to the same timestamp.
    Identifies the first and last common timestamp across all data sources.
    Culls data points outside this range.

    Args:
        bcg (np.ndarray): BCG data with timestamps.
        ecg (np.ndarray): ECG data with timestamps.
        hr (np.ndarray): HR data with timestamps.
        rr (np.ndarray): RR data with timestamps.
        offset (int, optional): Offset in seconds to apply to the start time.
        duration (int, optional): Duration in seconds to limit the data range.
    
    Returns:
        tuple: Four NumPy arrays containing synchronized BCG, ECG, HR, and RR data.
            Each array contains two columns: timestamp and value.
            The timestamp is in epoch format (int64).
            The value is in float64 format.
    """
    if not (bcg.size and ecg.size and hr.size and rr.size):
        return None, None, None, None
    
    # Find the first and last common timestamp across all data sources
    start_time = max(bcg[0, 0], ecg[0, 0], hr[0, 0], rr[0, 0])
    end_time = min(bcg[-1, 0], ecg[-1, 0], hr[-1, 0], rr[-1, 0])

    # Apply offset if specified
    if offset:
        start_time += offset * NANO_SECONDS_PER_SECOND

    if duration is not None:
        end_time = start_time + duration * NANO_SECONDS_PER_SECOND

    # Filter data to keep only the timestamps within the common range
    def filter_data(data, start, end):
        mask = (data[:, 0] >= start) & (data[:, 0] <= end)
        return data[mask]
    
    bcg = filter_data(bcg, start_time, end_time)
    ecg = filter_data(ecg, start_time, end_time)
    hr = filter_data(hr, start_time, end_time)
    rr = filter_data(rr, start_time, end_time)

    return bcg, ecg, hr, rr

def ns_to_datetime(ns_array):
    """
    Converts an array or scalar of timestamps in nanoseconds to datetime objects.
    Args:
        ns_array (np.ndarray or scalar): Array or scalar of timestamps in nanoseconds.
    Returns:
        list or datetime: List of datetime objects or a single datetime object.
    """
    amsterdam_tz = pytz.timezone('Europe/Amsterdam')
    if np.isscalar(ns_array):
        return datetime.datetime.fromtimestamp(ns_array / NANO_SECONDS_PER_SECOND, tz=amsterdam_tz)
    return [datetime.datetime.fromtimestamp(ts / NANO_SECONDS_PER_SECOND, tz=amsterdam_tz) for ts in ns_array]

def load_data(ecg_file, bcg_file, extrapolate=False, fs=None, offset=0, duration=None, detect_presence_en=True, trim_sec=5, trim_mode='threshold'):
    """
    Loads and synchronizes data from Polar and Teensy files.
    
    Args:
        ecg_file (str): Path to the Polar file.
        bcg_file (str): Path to the Teensy BCG file.
        extrapolate (bool, optional): If True, extrapolates timestamps in BCG data.
        fs (int, optional): Sampling frequency in Hz for extrapolation.
        offset (int, optional): Offset in seconds to apply to the start time.
        duration (int, optional): Duration in seconds to limit the data range.
        
    Returns:
        tuple: Four NumPy arrays containing synchronized BCG, ECG, HR, and RR data.
            Each array contains two columns: timestamp and value.
            The timestamp is in epoch format (int64).
            The value is in float64 format.
    """
    ecg, hr, rr = read_polar_file(ecg_file)
    bcg = read_teensy_file(bcg_file, extrapolate=extrapolate, fs=fs, offset=offset)

    if ecg is None or hr is None or rr is None or bcg is None:
        return None, None, None, None
    
    if detect_presence_en:
        bcg = detect_presence(bcg, trim_sec=trim_sec, force_trim=True, mode=trim_mode)

    return sync_data_sources_to_timestamp(bcg, ecg, hr, rr, offset=0, duration=duration)

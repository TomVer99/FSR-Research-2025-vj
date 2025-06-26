from scipy.signal import find_peaks, butter, sosfilt, cheby1, filtfilt, sosfiltfilt
import numpy as np

from src.algos import bandpass_butter, bandpass_chebyshev, wavelet_decompose
from src.logic import take_time_chunk_from_signal

NANO_SECONDS_PER_SECOND = 1e9
NANO_SECONDS_PER_MILLISECOND = 1e6

def estimate_hr_complex_chunk_based(signal, fs):
    """
    Estimate heart rate from a complex signal using bandpass filtering and wavelet decomposition.
    Args:
        signal (np.ndarray): The input signal with timestamps in nanoseconds.
        fs (int): Sampling frequency of the signal in Hz.
    Returns:
        np.ndarray: 2D array with columns [time, value] where value is the number of detected peaks in each chunk.
    """

    start_time = signal[0, 0]

    clipped = False
    chunk_nr = 0
    chunk_size_sec = 20  # seconds
    results = []

    while not clipped:
        chunk_start = start_time + (chunk_nr * NANO_SECONDS_PER_SECOND)
        chunk, clipped = take_time_chunk_from_signal(signal, chunk_start, chunk_size_sec)
        if clipped:
            # If the chunk is clipped, we can stop processing further chunks
            break
        bcg_hr_bandpass = bandpass_butter(chunk, fs=fs, lowcut=2.5, highcut=6)
        bcg_hr_wavelet = wavelet_decompose(bcg_hr_bandpass)
        bcg_hr_peaks, _ = estimate_hr(bcg_hr_wavelet, fs=fs, test=True)
        # Store [time, value] where value is number of peaks in this chunk
        results.append([chunk[:, 0][0], len(bcg_hr_peaks)])
        chunk_nr += 1

    return np.array(results)

def estimate_hr_complex(signal, fs):
    """
    Estimate heart rate from a complex signal using bandpass filtering and wavelet decomposition.
    Args:
        signal (np.ndarray): The input signal with timestamps in nanoseconds.
        fs (int): Sampling frequency of the signal in Hz.
    Returns:
        tuple: A tuple containing:
            - bcg_hr_peaks (np.ndarray): Detected peaks in the BCG signal.
            - bcg_hr_intervals (np.ndarray): Intervals between detected peaks in milliseconds.
    """
    # bcg_hr_bandpass = bandpass_chebyshev(signal, fs=fs, lowcut=2.5, highcut=5)
    bcg_hr_bandpass = bandpass_butter(signal, fs=fs, lowcut=2.5, highcut=6)
    bcg_hr_wavelet = wavelet_decompose(bcg_hr_bandpass)
    bcg_hr_peaks, bcg_hr_intervals = estimate_hr(bcg_hr_wavelet, fs=fs, test=True)
    return bcg_hr_peaks, bcg_hr_intervals

def estimate_rr_complex(signal, fs):
    """
    Estimate respiratory rate from a complex signal using bandpass filtering and wavelet decomposition.
    Args:
        signal (np.ndarray): The input signal with timestamps in nanoseconds.
        fs (int): Sampling frequency of the signal in Hz.
    Returns:
        tuple: A tuple containing:
            - bcg_rr_peaks (np.ndarray): Detected peaks in the BCG signal.
            - rr_intervals (np.ndarray): Intervals between detected peaks in milliseconds.
    """
    bcg_rr_b = bandpass_butter(signal, fs=fs, lowcut=0.1, highcut=0.4)
    bcg_rr_peaks, rr_intervals = estimate_rr(bcg_rr_b, fs=fs)
    return bcg_rr_peaks, rr_intervals

def estimate_hr(signal, fs, test=False):
    if not test:
        peaks, _ = find_peaks(signal[:, 1], distance=fs/2.5)
    else:
        # peaks, _ = find_peaks(signal[:, 1], distance=fs/2.0, prominence=0.01)
        # peaks, _ = find_peaks(signal[:, 1], prominence=0.015)
        peaks, _ = find_peaks(signal[:, 1])

    hr_peaks = signal[peaks]

    hr_intervals = (np.diff(hr_peaks[:, 0]) / NANO_SECONDS_PER_MILLISECOND) * 3 # convert from nanoseconds to milliseconds
    # Stack timestamps and intervals as columns in a 2D array
    hr_intervals = np.column_stack((hr_peaks[1:, 0], hr_intervals))
    
    # cull any intervals that are more than 1200 ms (less than 50 bpm)
    # valid_idx = hr_intervals < 750
    # hr_intervals = hr_intervals[valid_idx]

    # peak_intervals = np.diff(peaks) / fs  # in seconds
    # if len(peak_intervals) == 0:
    #     return 0, []
    # hr_values = 60.0 / peak_intervals  # convert to bpm
    # avg_hr = np.mean(hr_values)

    return hr_peaks, hr_intervals

def estimate_ecg_hr_complex_chunk_based(signal):
    """
    Estimate heart rate from an ECG signal using bandpass filtering and wavelet decomposition.
    Args:
        signal (np.ndarray): The input ECG signal with timestamps in nanoseconds.
        fs (int): Sampling frequency of the signal in Hz.
    Returns:
        np.ndarray: 2D array with columns [time, value] where value is the number of detected peaks in each chunk.
    """
    start_time = signal[0, 0]

    clipped = False
    chunk_nr = 0
    chunk_size_sec = 20  # seconds
    results = []

    while not clipped:
        chunk_start = start_time + (chunk_nr * NANO_SECONDS_PER_SECOND)
        chunk, clipped = take_time_chunk_from_signal(signal, chunk_start, chunk_size_sec)
        if clipped:
            # If the chunk is clipped, we can stop processing further chunks
            break
        peaks, _ = find_peaks(chunk[:, 1], prominence=0.5)
        # Store [time, value] where value is number of peaks in this chunk
        results.append([chunk[:, 0][0], len(peaks)*3])
        chunk_nr += 1

    return np.array(results)


def estimate_ecg_hr(signal):
    """
    Estimate heart rate from ECG signal using peak detection.
    Args:
        signal (np.ndarray): The ECG signal with timestamps in nanoseconds.
    Returns:
        tuple: A tuple containing:
            - hr_peaks (np.ndarray): Detected peaks in the ECG signal.
            - hr_intervals (np.ndarray): Intervals between detected peaks in milliseconds.
    """
    peaks, _ = find_peaks(signal[:, 1], prominence=0.5)

    if len(peaks) < 2:
        return [], []

    hr_peaks = signal[peaks]

    # Calculate HR intervals in milliseconds with the corresponding timestamps
    hr_intervals = np.diff(hr_peaks[:, 0]) / NANO_SECONDS_PER_MILLISECOND  # convert from nanoseconds to milliseconds
    # Stack timestamps and intervals as columns in a 2D array
    hr_intervals = np.column_stack((hr_peaks[1:, 0], hr_intervals))

    return hr_peaks, hr_intervals

def estimate_rr(signal, fs):
    peaks, _ = find_peaks(signal[:,1])

    if len(peaks) < 2:
        return [], []

    rr_peaks = signal[peaks]

    # Calculate RR intervals in milliseconds with the corresponding timestamps
    rr_intervals = np.diff(rr_peaks[:, 0]) / NANO_SECONDS_PER_MILLISECOND  # convert from nanoseconds to milliseconds
    # Stack timestamps and intervals as columns in a 2D array
    rr_intervals = np.column_stack((rr_peaks[1:, 0], rr_intervals))

    return rr_peaks, rr_intervals

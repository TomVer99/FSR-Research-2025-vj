import numpy as np
from scipy.signal import butter, cheby1, filtfilt, sosfiltfilt
import pywt

NANO_SECONDS_PER_SECOND = 1e9

def bandpass_chebyshev(signal, fs, lowcut=2.5, highcut=5.0, order=4, ripple=0.5):
    """
    Apply a Chebyshev bandpass filter to the signal.
    Args:
        signal (np.ndarray): The input signal to be filtered.
        fs (float): Sampling frequency of the signal.
        lowcut (float, default=2.5): Low cutoff frequency for the bandpass filter.
        highcut (float, default=5.0): High cutoff frequency for the bandpass filter.
        order (int, default=4): Order of the Chebyshev filter.
        ripple (float, default=0.5): Ripple in the passband in dB.
    Returns:
        np.ndarray: The filtered signal with the same shape as the input signal.
    """
    nyq = 0.5 * fs
    low = lowcut / nyq
    high = highcut / nyq
    b, a = cheby1(order, ripple, [low, high], btype='band')
    filtered_signal = filtfilt(b, a, signal[:, 1])
    return np.column_stack((signal[:, 0], filtered_signal))

def bandpass_butter(signal, fs, lowcut=2.5, highcut=5.0, order=5):
    """
    Apply a Butterworth bandpass filter to the signal.

    Args:
        signal (np.ndarray): The input signal to be filtered.
        fs (float): Sampling frequency of the signal.
        lowcut (float, default=2.5): Low cutoff frequency for the bandpass filter.
        highcut (float, default=5.0): High cutoff frequency for the bandpass filter.
        order (int, default=5): Order of the Butterworth filter.
    Returns:
        np.ndarray: The filtered signal with the same shape as the input signal.
    """
    nyq = 0.5 * fs
    low = lowcut / nyq
    high = highcut / nyq
    FILTER = butter(order, [low, high], btype='bandpass', analog=False, output='sos')
    filtered_signal = sosfiltfilt(FILTER, signal[:, 1])
    return np.column_stack((signal[:, 0], filtered_signal))

def wavelet_decompose(signal, wavelet='bior3.9', level=4):
    """
    Perform wavelet decomposition and reconstruction on the signal using the specified wavelet and level.
    Args:
        signal (np.ndarray): The input signal to be decomposed.
        wavelet (str, default='bior3.9'): The wavelet to use for decomposition.
        level (int, default=4): The level of decomposition.
    Returns:
        np.ndarray: The reconstructed signal after wavelet decomposition.
    """
    coeffs = pywt.wavedec(signal[:, 1], wavelet, level=level, mode='periodization')
    reconstructed = pywt.waverec(coeffs[:level+2], wavelet, mode='periodization')
    # Ensure reconstructed has the same length as the original signal
    if len(reconstructed) > len(signal):
        reconstructed = reconstructed[:len(signal)]
    elif len(reconstructed) < len(signal):
        reconstructed = np.pad(reconstructed, (0, len(signal) - len(reconstructed)), mode='constant')
    return np.column_stack((signal[:, 0], reconstructed))

def fft(signal, fs, min_freq=0.15, max_freq=None):
    n = len(signal)
    freq = np.fft.fftfreq(n, d=1/fs)
    fft_values = np.fft.fft(signal)
    mask = (freq >= 0)
    if max_freq is not None:
        mask = mask & (freq <= max_freq)
    mask = mask & (freq >= min_freq)
    return freq[mask], np.abs(fft_values)[mask]

def detect_presence(signal, trim_sec=0, force_trim=False, mode='threshold'):
    """
    Detect presence in the signal based on a threshold.
    This function applies a simple threshold method to determine the presence of a signal.
    Args:
        signal (np.ndarray): The input signal to be analyzed.
        trim_sec (int, default=0): Number of seconds to trim from the start and end of the signal.
        force_trim (bool, default=False): If True, forces trimming even if no presence is detected.
        mode (str, default='threshold'): The method to use for presence detection. Options are 'threshold' or 'peaks'.
        Returns:
        np.ndarray: The signal with presence detection applied, trimmed if specified.
    """
    signal_start = signal[0][0]
    signal_end = signal[-1][0]

    if mode == 'threshold':
        threshold = np.mean(signal[:,1])
    elif mode == 'peaks':
        # Detect large changes in the signal to determine presence
        diff = np.abs(np.diff(signal[:, 1]))
        change_threshold = np.mean(diff) + 2 * np.std(diff)
        significant_changes = np.nonzero(diff > change_threshold)[0]

        if len(significant_changes) > 0:
            # Use the mean value around significant changes as threshold
            idx = significant_changes[0]
            window = signal[max(0, idx-10):min(len(signal), idx+10), 1]
            threshold = np.mean(window)
        else:
            # Fallback: use overall mean
            threshold = np.mean(signal[:, 1])
    elif mode == 'cut':
        threshold = 0
    else:
        return signal
    
    mask = signal[:, 1] >= threshold
    signal = signal[mask]

    if trim_sec > 0:
        start_time = signal[0][0] + trim_sec * NANO_SECONDS_PER_SECOND
        end_time = signal[-1][0] - trim_sec * NANO_SECONDS_PER_SECOND

        if signal[-1][0] == signal_end and not force_trim:
            end_time = signal_end

        if signal[0][0] == signal_start and not force_trim:
            start_time = signal_start

        def filter_data(data, start, end):
            mask = (data[:, 0] >= start) & (data[:, 0] <= end)
            return data[mask]
        
        signal = filter_data(signal, start_time, end_time)

    return signal

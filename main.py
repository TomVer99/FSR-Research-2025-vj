import datetime
from matplotlib import dates as mdates
import matplotlib.pyplot as plt
import pytz
import numpy as np

from src.algos import bandpass_butter, bandpass_chebyshev, wavelet_decompose
from src.logic import load_data, ns_to_datetime, take_time_chunk_from_signal, combine, trim_to_minimum, write_bland_altman_to_file
from src.estimation import estimate_hr, estimate_rr, estimate_ecg_hr, estimate_hr_complex, estimate_rr_complex, estimate_hr_complex_chunk_based, estimate_ecg_hr_complex_chunk_based
from src.plot import bland_altman_plot
import matplotlib as mpl

###################### Reading Data ######################

# ecg_file = './data/sitting_a.csv'
# bcg_file = './data/sitting_a.txt'

# ecg_file_a = './data/bed_cr_filt.csv'
# bcg_file_a = './data/bed_cr_filt.txt'

ecg_file_a = './data/bed_a.csv'
bcg_file_a = './data/bed_a.txt'

bcg_presence_a, ecg_a, hr_a, rr_a = load_data(
    ecg_file=ecg_file_a,
    bcg_file=bcg_file_a,
    extrapolate=True,
    fs=175,
    offset=0,
    detect_presence_en=True,
    trim_sec=120,
    trim_mode='cut',
)

ecg_file_b = './data/bed_b.csv'
bcg_file_b = './data/bed_b.txt'

bcg_presence_b, ecg_b, hr_b, rr_b = load_data(
    ecg_file=ecg_file_b,
    bcg_file=bcg_file_b,
    extrapolate=True,
    fs=175,
    offset=25,
    # detect_presence_en=False
    trim_sec=80, # Large time to remove part of data where subject was not in bed / got in and out of bed
)

bcg_talking_whisper = './data/bed_whisper.txt'
ecg_talking_whisper = './data/bed_whisper.csv'

bcg_presence_talking_whisper, ecg_talking_whisper, hr_talking_whisper, rr_talking_whisper = load_data(
    ecg_file=ecg_talking_whisper,
    bcg_file=bcg_talking_whisper,
    extrapolate=True,
    fs=175,
    offset=0,
    detect_presence_en=True,
    trim_sec=10,
    trim_mode='cut',
)

bcg_talking_normal = './data/bed_normal.txt'
ecg_talking_normal = './data/bed_normal.csv'

bcg_presence_talking_normal, ecg_talking_normal, hr_talking_normal, rr_talking_normal = load_data(
    ecg_file=ecg_talking_normal,
    bcg_file=bcg_talking_normal,
    extrapolate=True,
    fs=175,
    offset=0,
    detect_presence_en=True,
    trim_sec=10,
    trim_mode='cut',
)

bcg_o_sound = './data/bed_o_sound.txt'
ecg_o_sound = './data/bed_o_sound.csv'

bcg_presence_o_sound, ecg_o_sound, hr_o_sound, rr_o_sound = load_data(
    ecg_file=ecg_o_sound,
    bcg_file=bcg_o_sound,
    extrapolate=True,
    fs=175,
    offset=0,
    detect_presence_en=True,
    trim_sec=10,
    trim_mode='cut',
)

###################### Reading Data ######################

# Sig A Calcs
# ECG
ecg_hr_estimated_bpm_a = estimate_ecg_hr_complex_chunk_based(ecg_a)
ecg_rr_peaks_a, ecg_rr_intervals_a = estimate_rr(rr_a, fs=175)
# BCG
bcg_hr_estimated_bpm_a = estimate_hr_complex_chunk_based(bcg_presence_a, fs=175)
bcg_rr_peaks_a, rr_intervals_a = estimate_rr_complex(bcg_presence_a, fs=175)

# Sig B Calcs
# ECG
ecg_hr_estimated_bpm_b = estimate_ecg_hr_complex_chunk_based(ecg_b)
ecg_rr_peaks_b, ecg_rr_intervals_b = estimate_rr(rr_b, fs=175)
# BCG
bcg_hr_estimated_bpm_b = estimate_hr_complex_chunk_based(bcg_presence_b, fs=175)
bcg_rr_peaks_b, rr_intervals_b = estimate_rr_complex(bcg_presence_b, fs=175)

# Talking Whisper Calcs
# ECG
ecg_talking_whisper_hr_estimated_bpm = estimate_ecg_hr_complex_chunk_based(ecg_talking_whisper)
ecg_talking_whisper_rr_peaks, ecg_talking_whisper_rr_intervals = estimate_rr(rr_talking_whisper, fs=175)
# BCG
bcg_talking_whisper_hr_estimated_bpm = estimate_hr_complex_chunk_based(bcg_presence_talking_whisper, fs=175)
bcg_talking_whisper_rr_peaks, bcg_talking_whisper_rr_intervals = estimate_rr_complex(bcg_presence_talking_whisper, fs=175)

# Talking Normal Calcs
# ECG
ecg_talking_normal_hr_estimated_bpm = estimate_ecg_hr_complex_chunk_based(ecg_talking_normal)
ecg_talking_normal_rr_peaks, ecg_talking_normal_rr_intervals = estimate_rr(rr_talking_normal, fs=175)
# BCG
bcg_talking_normal_hr_estimated_bpm = estimate_hr_complex_chunk_based(bcg_presence_talking_normal, fs=175)
bcg_talking_normal_rr_peaks, bcg_talking_normal_rr_intervals = estimate_rr_complex(bcg_presence_talking_normal, fs=175)

# O Sound Calcs
# ECG
ecg_o_sound_hr_estimated_bpm = estimate_ecg_hr_complex_chunk_based(ecg_o_sound)
ecg_o_sound_rr_peaks, ecg_o_sound_rr_intervals = estimate_rr(rr_o_sound, fs=175)
# BCG
bcg_o_sound_hr_estimated_bpm = estimate_hr_complex_chunk_based(bcg_presence_o_sound, fs=175)
bcg_o_sound_rr_peaks, bcg_o_sound_rr_intervals = estimate_rr_complex(bcg_presence_o_sound, fs=175)

################################ Plotting

# plt.figure(figsize=(12, 8))
# short_bcg, _ = take_time_chunk_from_signal(bcg_presence_a, start_time=bcg_presence_a[0, 0] + 9.8 * 1e9, duration_sec=0.7)
# short_ecg, _ = take_time_chunk_from_signal(ecg_a, start_time=ecg_a[0, 0] + (9.8 + 0.08) * 1e9, duration_sec=0.7)

# #time shift the ecg signal by 0.1 seconds
# short_ecg[:, 0] -= 0.08 * 1e9  # shift by 0.1 seconds in nanoseconds

# offset = short_bcg[0, 0]  # Get the offset from the first timestamp of the BCG signal

# for i in range(len(short_ecg)):
#     # Convert timestamp from nanoseconds to seconds and remove the offset
#     short_ecg[i, 0] = (short_ecg[i, 0] - offset) / 1e9

# for i in range(len(short_bcg)):
#     # Convert timestamp from nanoseconds to seconds and remove the offset
#     short_bcg[i, 0] = (short_bcg[i, 0] - offset) / 1e9

# with open('sing_beat_ecg.typ', 'w') as f:
#     f.write("#let data = (\n")
#     for value in short_ecg:
#         f.write(f"({value[0]}, {value[1]}),\n")
#     f.write(")\n")

# with open('sing_beat_bcg.typ', 'w') as f:
#     f.write("#let data = (\n")
#     for value in short_bcg:
#         f.write(f"({value[0]}, {value[1]}),\n")
#     f.write(")\n")

# ax1 = plt.gca()
# ax2 = ax1.twinx()

# ax1.plot(
#     short_bcg[:, 0],
#     short_bcg[:, 1],
#     label='BCG Signal A',
#     color='green',
#     alpha=0.7
# )
# ax2.plot(
#     short_ecg[:, 0],
#     short_ecg[:, 1],
#     label='ECG Signal A',
#     color='orange',
#     alpha=0.7
# )

# ax1.set_xlabel('Time')
# ax1.set_ylabel('BCG Amplitude', color='green')
# ax2.set_ylabel('ECG Amplitude', color='orange')

# lines_1, labels_1 = ax1.get_legend_handles_labels()
# lines_2, labels_2 = ax2.get_legend_handles_labels()
# ax1.legend(lines_1 + lines_2, labels_1 + labels_2)

# plt.show()

plt.figure(figsize=(12, 8))
ecg_rr_intervals_a, rr_intervals_a = trim_to_minimum(ecg_rr_intervals_a, rr_intervals_a)
ecg_rr_intervals_b, rr_intervals_b = trim_to_minimum(ecg_rr_intervals_b, rr_intervals_b)
ecg_talking_whisper_rr_intervals, bcg_talking_whisper_rr_intervals = trim_to_minimum(ecg_talking_whisper_rr_intervals, bcg_talking_whisper_rr_intervals)
ecg_talking_normal_rr_intervals, bcg_talking_normal_rr_intervals = trim_to_minimum(ecg_talking_normal_rr_intervals, bcg_talking_normal_rr_intervals)
ecg_o_sound_rr_intervals, bcg_o_sound_rr_intervals = trim_to_minimum(ecg_o_sound_rr_intervals, bcg_o_sound_rr_intervals)
combined_ecg_rr_estimated_interval = combine(ecg_rr_intervals_a, ecg_rr_intervals_b)
combined_bcg_rr_estimated_interval = combine(rr_intervals_a, rr_intervals_b)
md, sd, data = bland_altman_plot(combined_ecg_rr_estimated_interval[:, 1], combined_bcg_rr_estimated_interval[:, 1], color='blue', alpha=0.7)
write_bland_altman_to_file('bland_altman_data_rr.typ', data, md, sd)
md, sd, data = bland_altman_plot(ecg_talking_whisper_rr_intervals[:, 1], bcg_talking_whisper_rr_intervals[:, 1], color='red', alpha=0.7)
write_bland_altman_to_file('talking_whisper_bland_altman_data_rr.typ', data, md, sd)
md, sd, data = bland_altman_plot(ecg_talking_normal_rr_intervals[:, 1], bcg_talking_normal_rr_intervals[:, 1], color='orange', alpha=0.7)
write_bland_altman_to_file('talking_normal_bland_altman_data_rr.typ', data, md, sd)
md, sd, data = bland_altman_plot(ecg_o_sound_rr_intervals[:, 1], bcg_o_sound_rr_intervals[:, 1], color='pink', alpha=0.7)
write_bland_altman_to_file('o_sound_bland_altman_data_rr.typ', data, md, sd)
plt.title('Bland-Altman Plot RR')
plt.show()

exit()


plt.figure(figsize=(12, 8))
combined_ecg_hr_estimated_bpm = combine(ecg_hr_estimated_bpm_a, ecg_hr_estimated_bpm_b)
combined_bcg_hr_estimated_bpm = combine(bcg_hr_estimated_bpm_a, bcg_hr_estimated_bpm_b)
md, sd, data = bland_altman_plot(combined_ecg_hr_estimated_bpm[:, 1], combined_bcg_hr_estimated_bpm[:, 1], color='blue', alpha=0.7)
write_bland_altman_to_file('bland_altman_data.typ', data, md, sd)
md, sd, data = bland_altman_plot(ecg_o_sound_hr_estimated_bpm[:, 1], bcg_o_sound_hr_estimated_bpm[:, 1], color='red', alpha=0.7)
write_bland_altman_to_file('o_sound_bland_altman_data.typ', data, md, sd)
md, sd, data = bland_altman_plot(ecg_talking_normal_hr_estimated_bpm[:, 1], bcg_talking_normal_hr_estimated_bpm[:, 1], color='orange', alpha=0.7)
write_bland_altman_to_file('talking_normal_bland_altman_data.typ', data, md, sd)
md, sd, data = bland_altman_plot(ecg_talking_whisper_hr_estimated_bpm[:, 1], bcg_talking_whisper_hr_estimated_bpm[:, 1], color='pink', alpha=0.7)
write_bland_altman_to_file('talking_whisper_bland_altman_data.typ', data, md, sd)
plt.title('Bland-Altman Plot HR')
plt.xlabel('Mean of HR BPM and ECG HR BPM')
plt.ylabel('Difference between HR BPM and ECG HR BPM')
plt.show()

plt.figure(figsize=(12, 8))
bcg_hr_bandpass = bandpass_butter(bcg_presence_b, fs=175, lowcut=2.5, highcut=6)
bcg_hr_peaks, bcg_hr_intervals = estimate_hr(bcg_hr_bandpass, fs=175, test=True)
ax1 = plt.gca()
ax2 = ax1.twinx()
ax1.plot(
    ns_to_datetime(bcg_hr_bandpass[:, 0]),
    bcg_hr_bandpass[:, 1],
    label='BCG Signal A',
    color='green',
    alpha=0.7
)
ax2.plot(
    ns_to_datetime(ecg_b[:, 0]),
    ecg_b[:, 1],
    label='ECG Signal A',
    color='orange',
    alpha=0.7
)
# Plot detected peaks as vertical lines
for i, peak in enumerate(bcg_hr_peaks):
    ax1.axvline(
        x=ns_to_datetime(peak[0]),
        color='red',
        linestyle='--',
        linewidth=1,
        label='BCG HR Peak' if i == 0 else ""
    )

plt.figure(figsize=(12, 8))
plt.plot(
    ns_to_datetime(bcg_hr_estimated_bpm_a[:, 0]),
    bcg_hr_estimated_bpm_a[:, 1],
    label='BCG Signal A',
    color='green',
    alpha=0.7
)
plt.plot(
    ns_to_datetime(hr_a[:, 0]),
    hr_a[:, 1],
    label='ECG Signal A',
    color='orange',
    alpha=0.7
)

plt.figure(figsize=(12, 8))
plt.plot(
    ns_to_datetime(bcg_hr_estimated_bpm_b[:, 0]),
    bcg_hr_estimated_bpm_b[:, 1],
    label='BCG Signal A',
    color='green',
    alpha=0.7
)
# plt.plot(
#     ns_to_datetime(ecg_hr_estimated_bpm_b[:, 0]),
#     ecg_hr_estimated_bpm_b[:, 1],
#     label='ECG Signal A',
#     color='orange',
#     alpha=0.7
# )
plt.plot(
    ns_to_datetime(hr_b[:, 0]),
    hr_b[:, 1],
    label='ECG Signal A',
    color='orange',
    alpha=0.7
)

# create a bland altman plot of estimated BCG and ECG HR
plt.figure(figsize=(12, 8))
bland_altman_plot(
    bcg_hr_estimated_bpm_a[:, 1],
    ecg_hr_estimated_bpm_a[:, 1],
    label='BCG HR Test Method Data Set A [3 minutes]',
    cmap_code="RdYlGn_r",
    # color='blue',
    alpha=0.7
)
bland_altman_plot(
    bcg_hr_estimated_bpm_b[:, 1],
    ecg_hr_estimated_bpm_b[:, 1],
    label='BCG HR Test Method Data Set B [10 minutes]',
    cmap_code="RdYlGn_r",
    # color='red',
    alpha=0.7
)
plt.title('Bland-Altman Plot')
plt.xlabel('Mean of HR BPM and ECG HR BPM')
plt.ylabel('Difference between HR BPM and ECG HR BPM')
plt.legend()

plt.figure(figsize=(12, 8))
# combined_bcg_hr_estimated_bpm = combine(bcg_hr_estimated_bpm_a, bcg_hr_estimated_bpm_b)
# combined_ecg_hr_estimated_bpm = combine(ecg_hr_estimated_bpm_a, ecg_hr_estimated_bpm_b)
md, sd, data = bland_altman_plot(
    combined_bcg_hr_estimated_bpm[:, 1],
    combined_ecg_hr_estimated_bpm[:, 1],
    label='BCG HR Test Method Data Set A [3 minutes]',
    # cmap_code="RdYlGn_r",
    # color='blue',
    # alpha=0.7
)

plt.title('Bland-Altman Plot HR')
plt.xlabel('Mean of HR BPM and ECG HR BPM')
plt.ylabel('Difference between HR BPM and ECG HR BPM')
plt.legend()

# ####################################################################
# # RR
# ####################################################################
# create a bland altman plot of rr_intervals and ecg_rr_intervals
rr_intervals_a, ecg_rr_intervals_a = trim_to_minimum(rr_intervals_a, ecg_rr_intervals_a)
rr_intervals_b, ecg_rr_intervals_b = trim_to_minimum(rr_intervals_b, ecg_rr_intervals_b)
combined_bcg_hr_intervals = combine(rr_intervals_a, rr_intervals_b)
combined_ecg_hr_intervals = combine(ecg_rr_intervals_a, ecg_rr_intervals_b)
plt.figure(figsize=(12, 8))
md, sd, data = bland_altman_plot(combined_bcg_hr_intervals[:, 1], combined_ecg_hr_intervals[:, 1])
plt.title('Bland-Altman Plot RR')
plt.xlabel('Mean of RR Intervals and ECG RR Intervals')
plt.ylabel('Difference between RR Intervals and ECG RR Intervals')

# Write data1 and data2 to a file
with open('bland_altman_data_rr.typ', 'w') as f:
    f.write(f"#let data = (\n")
    for value in data:
        f.write(f"({value[0]}, {value[1]}),\n")
    f.write(f")\n")
    f.write(f"#let data_md = {md}\n")
    f.write(f"#let data_sd = {sd}\n")



bcg_eight_min, _ = take_time_chunk_from_signal(
    bcg_presence_b,
    start_time=bcg_presence_b[0, 0] + 25 * 1e9,  # Start at 25 seconds
    duration_sec=20,  # 8 minutes
)

bcg_filt_eight_min = bandpass_butter(bcg_eight_min, fs=175, lowcut=2.5, highcut=6)
bcg_filt_rr_eight_min = bandpass_butter(bcg_eight_min, fs=175, lowcut=0.1, highcut=0.4)

plt.figure(figsize=(12, 8))
plt.plot(
    ns_to_datetime(bcg_filt_rr_eight_min[:, 0]),
    bcg_filt_rr_eight_min[:, 1],
    label='BCG RR Filtered',
)
plt.legend()
plt.show()

# offset = bcg_eight_min[0, 0]  # Get the offset from the first timestamp

# for i in range(len(bcg_eight_min)):
#     # Convert timestamp from nanoseconds to seconds and remove the offset
#     bcg_eight_min[i, 0] = (bcg_eight_min[i, 0] - offset) / 1e9

# ecg_eight_min, _ = take_time_chunk_from_signal(
#     ecg_b,
#     start_time=bcg_presence_b[0, 0] + 25 * 1e9,
#     duration_sec=20,  # 8 minutes
# )

# ecg_eight_min_rr, _ = take_time_chunk_from_signal(
#     rr_b,
#     start_time=bcg_presence_b[0, 0] + 25 * 1e9,
#     duration_sec=20,  # 8 minutes
# )

# # Convert timestamps from nanoseconds to seconds and remove the offset
# for i in range(len(ecg_eight_min)):
#     ecg_eight_min[i, 0] = (ecg_eight_min[i, 0] - offset) / 1e9

# for i in range(len(ecg_eight_min_rr)):
#     ecg_eight_min_rr[i, 0] = (ecg_eight_min_rr[i, 0] - offset) / 1e9

# for i in range(len(bcg_filt_eight_min)):
#     # Convert timestamp from nanoseconds to seconds and remove the offset
#     bcg_filt_eight_min[i, 0] = (bcg_filt_eight_min[i, 0] - offset) / 1e9

# for i in range(len(bcg_filt_rr_eight_min)):
#     # Convert timestamp from nanoseconds to seconds and remove the offset
#     bcg_filt_rr_eight_min[i, 0] = (bcg_filt_rr_eight_min[i, 0] - offset) / 1e9

# with open('test.typ', 'w') as f:
#     f.write(f"#let data = (\n")
#     for value in bcg_eight_min:
#         f.write(f"({value[0]}, {value[1]}),\n")
#     f.write(f")\n")

# with open('testb.typ', 'w') as f:
#     f.write(f"#let data = (\n")
#     for value in ecg_eight_min:
#         f.write(f"({value[0]}, {value[1]}),\n")
#     f.write(f")\n")

# with open('testa.typ', 'w') as f:
#     f.write(f"#let data = (\n")
#     for value in bcg_filt_eight_min:
#         f.write(f"({value[0]}, {value[1]}),\n")
#     f.write(f")\n")

# with open('testc.typ', 'w') as f:
#     f.write(f"#let data = (\n")
#     for value in bcg_filt_rr_eight_min:
#         f.write(f"({value[0]}, {value[1]}),\n")
#     f.write(f")\n")

# with open('testd.typ', 'w') as f:
#     f.write(f"#let data = (\n")
#     for value in ecg_eight_min_rr:
#         f.write(f"({value[0]}, {value[1]}),\n")
#     f.write(f")\n")

# ####################################################################

# ####################################################################
# # HR
# ####################################################################

# # moving average for BCG HR intervals
# # window_size = 5
# # bcg_hr_intervals_a_avg_values = np.convolve(bcg_hr_intervals_a[:, 1], np.ones(window_size)/window_size, mode='valid')
# # bcg_hr_intervals_a_avg_timestamps = bcg_hr_intervals_a[window_size-1:, 0]
# # bcg_hr_intervals_a_avg = np.column_stack((bcg_hr_intervals_a_avg_timestamps, bcg_hr_intervals_a_avg_values))

# # ecg_hr_intervals_avg_values = np.convolve(ecg_intervals[:, 1], np.ones(window_size)/window_size, mode='valid')
# # ecg_hr_intervals_avg_timestamps = ecg_intervals[window_size-1:, 0]
# # ecg_hr_intervals_avg = np.column_stack((ecg_hr_intervals_avg_timestamps, ecg_hr_intervals_avg_values))

# # plt.figure(figsize=(12, 8))
# # # plt.plot(ns_to_datetime(bcg_hr_intervals_a[:, 0]), bcg_hr_intervals_a[:, 1], label='BCG HR Intervals', color='blue', alpha=0.7)
# # plt.plot(ns_to_datetime(bcg_hr_intervals_a_avg[:, 0]), bcg_hr_intervals_a_avg[:, 1], label='BCG HR Intervals moving avg', color='orange', alpha=0.7)
# # plt.plot(ns_to_datetime(ecg_intervals[:, 0]), ecg_intervals[:, 1], label='ECG HR intervals', color='red', alpha=0.7)
# # # plt.plot(ns_to_datetime(ecg[:, 0]), ecg[:, 1], label='ECG HR intervals', color='orange', alpha=0.7)
# # plt.gca().xaxis.set_major_locator(mdates.SecondLocator(interval=10))
# # plt.gca().xaxis.set_major_formatter(mdates.DateFormatter('%H:%M:%S'))
# # plt.xticks(rotation=45)
# # plt.legend()
# # plt.show()

# plt.figure(figsize=(12, 8))
# ax1 = plt.gca()
# ax2 = ax1.twinx()

# # Calculate mean of BCG signal for centering
# bcg_mean = np.mean(bcg_presence_a[:, 1])

# ax1.plot(
#     ns_to_datetime(bcg_presence_a[:, 0]),
#     bcg_presence_a[:, 1],
#     label='BCG Signal A',
#     color='green',
#     alpha=0.7
# )
# ax2.plot(
#     ns_to_datetime(ecg_a[:, 0]),
#     ecg_a[:, 1],
#     label='ECG Signal A',
#     color='orange',
#     alpha=0.7
# )

# ax1.set_xlabel('Timestamp')
# ax1.set_ylabel('BCG Amplitude', color='green')
# ax2.set_ylabel('ECG Amplitude', color='orange')

# ax1.xaxis.set_major_locator(mdates.SecondLocator(interval=10))
# ax1.xaxis.set_major_formatter(mdates.DateFormatter('%H:%M:%S'))
# plt.xticks(rotation=45)
# plt.title('BCG and ECG Signals')
# ax1.grid()

# # Center y-axis of BCG around its mean
# ymin, ymax = ax1.get_ylim()
# y_range = max(abs(ymax - bcg_mean), abs(ymin - bcg_mean))
# ax1.set_ylim(bcg_mean - y_range, bcg_mean + y_range)
# ax1.axhline(y=bcg_mean, color='black', linestyle='--', linewidth=0.5)

# lines_1, labels_1 = ax1.get_legend_handles_labels()
# lines_2, labels_2 = ax2.get_legend_handles_labels()
# ax1.legend(lines_1 + lines_2, labels_1 + labels_2)

# plt.figure(figsize=(12, 8))
# bland_altman_plot(
#     bcg_hr_intervals_a[:, 1],
#     ecg_hr_intervals_a[:, 1],
#     label='BCG HR Test Method Data Set A [3 minutes]',
#     # cmap_code="RdYlGn_r",
#     color='blue',
#     alpha=0.7
# )
# bland_altman_plot(
#     bcg_hr_intervals_b[:, 1],
#     ecg_hr_intervals_b[:, 1],
#     label='BCG HR Test Method Data Set B [10 minutes]',
#     # cmap_code="RdYlGn_r",
#     color='red',
#     alpha=0.7
# )
# plt.title('Bland-Altman Plot')
# plt.xlabel('Mean of HR Intervals and ECG HR Intervals')
# plt.ylabel('Difference between HR Intervals and ECG HR Intervals')
# plt.legend()

# plt.figure(figsize=(12, 8))
# plt.hist(bcg_hr_intervals_a[:, 1], bins=50, alpha=0.5, label='BCG HR Intervals A', color='blue')
# plt.hist(bcg_hr_intervals_b[:, 1], bins=50, alpha=0.5, label='BCG HR Intervals B', color='red')
# plt.hist(ecg_hr_intervals_a[:, 1], bins=50, alpha=0.5, label='ECG HR Intervals A', color='orange')
# plt.hist(ecg_hr_intervals_b[:, 1], bins=50, alpha=0.5, label='ECG HR Intervals B', color='green')
# plt.title('Distribution of HR Intervals')
# plt.xlabel('HR Interval (ms)')
# plt.ylabel('Frequency')
# plt.legend()
# plt.show()

# ####################################################################
# # plt.figure(figsize=(12, 8))
# # # plot raw ECG signal
# # plt.plot(ns_to_datetime(ecg[:, 0]), ecg[:, 1], label='ECG Signal', color='orange')
# # plt.plot(ns_to_datetime(bcg_hr_wavelet[:, 0]), bcg_hr_wavelet[:, 1], label='Wavelet Signal', color='green')
# # # plot vertical lines for each detected hr peak
# # for i, peak in enumerate(ecg_peaks):
# #     amsterdam_tz = pytz.timezone('Europe/Amsterdam')
# #     plt.axvline(
# #         x=datetime.datetime.fromtimestamp(peak[0] / 1e9, tz=amsterdam_tz),
# #         color='red',
# #         linestyle='--',
# #         label='HR Peak' if i == 0 else ""
# #     )
# # plt.title('ECG Signal with Detected HR Peaks')
# # plt.xlabel('Timestamp')
# # plt.ylabel('ECG Amplitude (microvolts)')
# # plt.gca().xaxis.set_major_locator(mdates.SecondLocator(interval=10))
# # plt.gca().xaxis.set_major_formatter(mdates.DateFormatter('%H:%M:%S'))
# # plt.xticks(rotation=45)
# # plt.legend()
# # plt.show()
# ####################################################################

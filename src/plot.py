import numpy as np
import matplotlib.pyplot as plt
import matplotlib.cm as cm
import matplotlib as mpl

def bland_altman_plot(data1, data2, xlabel="", ylabel="", color=None, cmap_code=None, *args, **kwargs):
    data1 = np.asarray(data1)
    data2 = np.asarray(data2)
    mean = np.mean([data1, data2], axis=0)
    diff = data1 - data2                   # Difference between data1 and data2
    md = np.mean(diff)                     # Mean of the difference
    sd = np.std(diff, axis=0)              # Standard deviation of the difference

    if cmap_code is not None:
        cmap = cm.get_cmap(cmap_code)  # reversed so green is first, red is last
        num_points = len(mean)
        colors = [cmap(i / (num_points - 1)) for i in range(num_points)]
    else:
        colors = color

    plt.scatter(mean, diff, color=colors, *args, **kwargs)
    plt.axhline(md, color='gray')
    plt.axhline(md + 1.96*sd, color='gray', linestyle='--')
    plt.axhline(md - 1.96*sd, color='gray', linestyle='--')
    plt.xlabel(xlabel)
    plt.ylabel(ylabel)

    # Return the mean and standard deviation of the difference and the data as x,y pairs
    return md, sd, np.column_stack((mean, diff))

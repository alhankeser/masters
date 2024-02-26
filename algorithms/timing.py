import sys

sys.path.append("./")
from helpers import utils
from algorithms.insertion_sort import insertion_sort
from algorithms.merge_sort import merge_sort
from algorithms.bubble_sort import bubble_sort
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import time


def builtin_sort(arr: list[int]) -> list[int]:
    return sorted(arr)


funcs = [
    {
        "func": bubble_sort,
        "args": {},
    },
    {
        "func": insertion_sort,
        "args": {},
    },
    {
        "func": insertion_sort,
        "args": {"optimize": True},
    },
    {
        "func": merge_sort,
        "args": {
            "min_leaf": 1,
        },
    },
    {
        "func": merge_sort,
        "args": {
            "min_leaf": 200,
        },
    },
    {
        "func": builtin_sort,
        "args": {},
    },
]
n_min = 100
n_max = 1000
increment = 100
iterations = 1
n_list = np.linspace(
    n_min, n_max, num=(n_max - n_min) // increment + 1, dtype=int
).tolist()
results = utils.compare_timing(funcs=funcs, n_list=n_list, iterations=iterations)
df = pd.DataFrame(results)
df["func_version"] = df["func"] + df["version"]
sns.set_theme()
sns.lineplot(data=df, x="n", y="timing", hue="func_version")
plt_title = f"n_{min(n_list)}_to_{max(n_list)}"
plt.title(plt_title)
plt.savefig(f"./analysis/{plt_title}_{str(int(time.time() * 10))}.png")

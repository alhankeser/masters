import sys

sys.path.append("./")
from meta import utils
from algorithms.insertion_sort import insertion_sort
import pandas as pd

funcs = [
    {
        "func": insertion_sort,
        "args": {
            "only_distinct": True,
            "use_shortcuts": True,
            "shortcut_interval": 150,
        },
    },
    {
        "func": insertion_sort,
        "args": {
            "only_distinct": False,
            "use_shortcuts": False,
        },
    },
]
n_list = [10, 100, 1_000, 10_000]
results = utils.compare_timing(funcs=funcs, n_list=n_list)

print(pd.DataFrame(results))

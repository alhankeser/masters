import sys

sys.path.append("./")
from utils import utils
import timeit
import operator
import pandas as pd
import matplotlib.pyplot as plt

"""
Insertion Sort algorithm as described in Chapter 2 
of INTRODUCTION TO ALGORITHMS 3rd Edition
with a couple naive attempts at optimization without 
fundamentally changing the overall approach
"""

OPERATORS = {"asc": "lt", "desc": "gt"}


def get_insertion_index(i, comparison, value, array):
    insert_at_idx = i + 1
    if len(array) == 0:
        return insert_at_idx
    while i > -1 and comparison(value, array[i]):
        insert_at_idx = i
        i -= 1
    return insert_at_idx


def refresh_shortcut_subset(interval, array, subset, output_len, len_rounded):
    increment_by = int(interval / 2)
    for shortcut_idx in range(increment_by, output_len - increment_by, increment_by):
        subset.append(array[shortcut_idx])
    refresh_limit = len_rounded
    return subset, refresh_limit


def get_shortcut_index(
    compare_idx,
    interval,
    comparison,
    array,
    refresh_limit,
    subset,
    current_value,
    output_len,
):
    len_rounded = (output_len // interval) * interval
    if len_rounded > refresh_limit:
        subset, refresh_limit = refresh_shortcut_subset(
            interval, array, subset, output_len, len_rounded
        )
    subset_len = len(subset)
    shortcut_idx = subset_len - 1
    shortcut_idx = get_insertion_index(shortcut_idx, comparison, current_value, subset)
    if subset_len == shortcut_idx:
        return compare_idx, refresh_limit, subset
    else:
        subset_compare_value = subset[shortcut_idx]
        return array.index(subset_compare_value), refresh_limit, subset


def main(
    input_array,
    sort_order="asc",
    only_distinct=False,
    use_shortcuts=False,
    shortcut_interval=10,
):
    comparison = getattr(operator, OPERATORS[sort_order])
    output_array = []
    output_count = {}
    shortcut_refresh_limit = shortcut_interval
    shortcut_subset = []
    for i, current_value in enumerate(input_array):
        if only_distinct and current_value in output_array:
            output_count[current_value] += 1
            continue
        output_len = len(output_array)
        compare_idx = output_len - 1
        if use_shortcuts:
            compare_idx, shortcut_refresh_limit, shortcut_subset = get_shortcut_index(
                compare_idx,
                shortcut_interval,
                comparison,
                output_array,
                shortcut_refresh_limit,
                shortcut_subset,
                current_value,
                output_len,
            )
        insert_at_idx = get_insertion_index(
            compare_idx, comparison, current_value, output_array
        )
        output_array.insert(insert_at_idx, current_value)
        if only_distinct:
            output_count[current_value] = 1
    if only_distinct:
        for key, count in output_count.items():
            if count > 1:
                insert_at_idx = output_array.index(key)
                output_array[insert_at_idx:insert_at_idx] = [key] * (count - 1)
    return output_array


if __name__ == "__main__":
    n = 100_000
    min_n = 1
    max_n = n

    path = utils.get_path("inputs", "insertion_sort_input")
    input_array_source = utils.get_random_numbers(n, min_n, max_n)
    # utils.write_array_to_file(input_array, path)
    # input_array = utils.read_array_file(path)

    output_array = main(
        input_array = input_array_source,
        sort_order="asc",
        only_distinct=True,
        use_shortcuts=True,
        shortcut_interval=150,
    )

    """
    Compare timings
    """
    # timing_results = {}
    # for optimizations_enabled in [True, False]:
    #     timing_results[optimizations_enabled] = {}
    #     for n_len in [10, 100, 1_000, 10_000, 100_000]:
    #         input_array = input_array_source[:n_len-1]
    #         timing_results[optimizations_enabled][n_len] = timeit.timeit(
    #             lambda: main(
    #                 input_array=input_array,
    #                 sort_order="asc",
    #                 only_distinct=optimizations_enabled,
    #                 use_shortcuts=optimizations_enabled,
    #                 shortcut_interval=150,
    #             ),
    #             number=1,
    #         )
    # pd.DataFrame.from_dict(timing_results).plot(grid=True, marker='o', linestyle='-')
    # plt.savefig('./outputs/insertion_sort.png')

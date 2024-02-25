import sys

sys.path.append("./")
from meta import utils
import operator
from typing import Tuple, List, Literal, Callable, Dict

"""
Insertion Sort algorithm as described in Chapter 2 
of INTRODUCTION TO ALGORITHMS 3rd Edition
with a couple naive attempts at optimization without 
fundamentally changing the overall approach
"""

OPERATORS = {"asc": "lt", "desc": "gt"}


def get_insertion_index(
    i: int, comparison: Callable, value: int, arr: List[int]
) -> int:
    insert_at_idx = i + 1
    if len(arr) == 0:
        return insert_at_idx
    while i > -1 and comparison(value, arr[i]):
        insert_at_idx = i
        i -= 1
    return insert_at_idx


def refresh_shortcut_subset(
    interval: int,
    arr: List[int],
    subset: List[int],
    output_len: int,
    len_rounded: int,
) -> List[int]:
    increment_by = int(interval / 2)
    for shortcut_idx in range(increment_by, output_len - increment_by, increment_by):
        subset.append(arr[shortcut_idx])
    return subset


def get_shortcut_index(
    compare_idx: int,
    interval: int,
    comparison: Callable,
    arr: List[int],
    refresh_limit: int,
    subset: List[int],
    current_value: int,
    output_len: int,
) -> Tuple[int, int, List[int]]:
    len_rounded = (output_len // interval) * interval
    if len_rounded > refresh_limit:
        subset = refresh_shortcut_subset(interval, arr, subset, output_len, len_rounded)
    refresh_limit = len_rounded
    subset_len = len(subset)
    shortcut_idx = subset_len - 1
    shortcut_idx = get_insertion_index(shortcut_idx, comparison, current_value, subset)
    if subset_len == shortcut_idx:
        return compare_idx, refresh_limit, subset
    else:
        subset_compare_value = subset[shortcut_idx]
        return arr.index(subset_compare_value), refresh_limit, subset


def insertion_sort(
    input_array: List[int],
    sort_order: Literal["asc", "desc"] = "asc",
    only_distinct: bool = False,
    use_shortcuts: bool = False,
    shortcut_interval: int = 10,
) -> List[int]:
    comparison = getattr(operator, OPERATORS[sort_order])
    output_array: List[int] = []
    output_count: Dict[int, int] = {}
    shortcut_refresh_limit = shortcut_interval
    shortcut_subset: List[int] = []
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
    try:
        sys_argv = int(sys.argv[1])
    except:
        sys_argv = 10

    n = sys_argv
    n_min = 0
    n_max = n

    input_array = utils.get_random_numbers(n, n_min, n_max)

    output_array = insertion_sort(
        input_array=input_array,
        sort_order="asc",
        only_distinct=True,
        use_shortcuts=True,
        shortcut_interval=150,
    )

    print(output_array)

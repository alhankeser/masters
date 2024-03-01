import sys

sys.path.append("./")
from helpers import utils
import operator
import numpy as np
from numpy import ndarray
from typing import Tuple, List, Literal, Callable, Dict

"""
Insertion Sort algorithm as described in Chapter 2 
of INTRODUCTION TO ALGORITHMS 3rd Edition
"""


def insertion_sort_simple_np(arr: List[int]) -> ndarray:
    if len(arr) <= 1:
        return np.array(arr)
    arr = np.array(arr)
    for curr_index in range(1, len(arr)):
        curr_value = arr[curr_index]
        insert_index = curr_index
        comp_index = curr_index - 1
        while comp_index >= 0 and curr_value < arr[comp_index]:
            # arr[comp_index], arr[comp_index + 1] = arr[comp_index + 1], arr[comp_index]
            insert_index = comp_index
            comp_index -= 1
        if insert_index != curr_index:
            arr = np.concatenate([arr[:insert_index], [curr_value], arr[insert_index:curr_index], arr[curr_index+1:]])
    return arr

def insertion_sort_simple_list(arr: List[int]) -> List[int]:
    if len(arr) <= 1:
        return arr
    for curr_index in range(1, len(arr)):
        curr_value = arr[curr_index]
        insert_index = curr_index
        comp_index = curr_index - 1
        while comp_index >= 0 and curr_value < arr[comp_index]:
            # arr[comp_index], arr[comp_index + 1] = arr[comp_index + 1], arr[comp_index]
            insert_index = comp_index
            comp_index -= 1
        if insert_index != curr_index:
            # This is much faster than updating the position of items every time through
            arr = arr[:insert_index] + [curr_value] + arr[insert_index:curr_index] + arr[curr_index+1:]
    return arr

if __name__ == "__main__":
    try:
        sys_argv = int(sys.argv[1])
    except:
        sys_argv = 10

    n = sys_argv
    n_min = 0
    n_max = n

    arr = utils.get_random_numbers(n, n_min, n_max)

    print(arr)
    # output_array = insertion_sort_simple_np(arr=arr)
    output_array = insertion_sort_simple_list(arr=arr)
    print(output_array)

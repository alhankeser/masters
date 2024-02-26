import sys

sys.path.append("./")
from helpers import utils
from insertion_sort import insertion_sort
from typing import Tuple, List, Union


"""
Merge Sort algorithm as described in Chapter 2 
of INTRODUCTION TO ALGORITHMS 3rd Edition
"""


def split_array(arr: List[int]) -> Tuple[List[int], List[int]]:
    midpoint = (len(arr) - 1) // 2 + 1
    return arr[:midpoint], arr[midpoint:]


def merge_arrays(arr1: List[int], arr2: List[int]) -> List[int]:
    result = []
    i = 0
    j = 0
    while i < len(arr1) and j < len(arr2):
        if arr1[i] <= arr2[j]:
            result.append(arr1[i])
            i += 1
        else:
            result.append(arr2[j])
            j += 1
    result = result + arr1[i:] + arr2[j:]
    return result


def merge_sort(arr: List[int], min_leaf: int = 1) -> List[int]:
    if len(arr) <= min_leaf:
        return insertion_sort(arr=arr)
    arr1, arr2 = split_array(arr=arr)
    arr1 = merge_sort(arr1)
    arr2 = merge_sort(arr2)
    result = merge_arrays(arr1, arr2)
    return result


if __name__ == "__main__":
    try:
        sys_argv = int(sys.argv[1])
    except:
        sys_argv = 10

    n = sys_argv
    n_min = 0
    n_max = n

    arr = utils.get_random_numbers(n, n_min, n_max)
    result = merge_sort(arr=arr)
    print(result)

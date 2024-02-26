import sys

sys.path.append("./")
from helpers import utils
from typing import Tuple, List, Union


"""
Bubble Sort algorithm as described in Chapter 2 
of INTRODUCTION TO ALGORITHMS 3rd Edition
"""


def bubble_sort(arr: List[int]) -> List[int]:
    i = 0
    while i < len(arr):
        j = len(arr) - 1
        while j > i:
            if arr[j - 1] > arr[j]:
                arr[j - 1], arr[j] = arr[j], arr[j - 1]
            j -= 1
        i += 1
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
    result = bubble_sort(arr=arr)
    print(result)

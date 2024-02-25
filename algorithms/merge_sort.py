import sys

sys.path.append("./")
from helpers import utils
from insertion_sort import insertion_sort
from typing import Tuple, List, Union


def split_array(
    arr: List[int], min_leaf: int = 2
) -> Tuple[List[int], List[List[int]]]:
    output = []
    if len(arr) < min_leaf:
        output.append(arr)
    while len(arr) >= min_leaf:
        output.append(arr[:min_leaf])
        arr = arr[min_leaf:]
    return arr, output


def sort_arrays(
    arrays: List[List[int]], optimize: bool = False
) -> List[List[int]]:
    output = []
    for arr in arrays:
        output.append(insertion_sort(input_array=arr, optimize=optimize))
    return output


def merge_arrays(arrays: List[List[int]]) -> List[List[int]]:
    if len(arrays) < 2:
        return arrays
    arr1, arr2 = arrays[:2]
    merged = []
    while len(arr1) > 0 and len(arr2) > 0:
        if arr1[0] <= arr2[0]:
            merged.append(arr1[0])
            arr1.pop(0)
        else:
            merged.append(arr2[0])
            arr2.pop(0)
    arrays = arrays[2:] + [merged + arr1 + arr2]
    return arrays


def merge_sort(
    input_array: List[int], min_leaf: int = 2, optimize: bool = False
) -> Union[List[int], List[List[int]]]:
    arrays = split_array(arr=input_array, min_leaf=min_leaf)[1]
    sorted_arrays = sort_arrays(arrays=arrays, optimize=optimize)
    while len(sorted_arrays) > 1:
        sorted_arrays = merge_arrays(sorted_arrays)
    output_array = sorted_arrays[0]
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

    output_array = merge_sort(input_array=input_array, min_leaf=100)
    print(output_array)

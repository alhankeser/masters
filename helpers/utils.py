import random
import gzip
import array
import timeit
import os
import numpy as np
import matplotlib.pyplot as plt
from itertools import product
from typing import List, Callable, Dict, Any


def get_random_numbers(n: int, n_min: int, n_max: int) -> List[int]:
    return [random.randint(n_min, n_max) for _ in range(n)]


def get_path(dir: str, name: str) -> str:
    return f"./{dir}/{name}.gz"


def write_array_to_file(input_array: List[int], path: str) -> str:
    arr = array.array("i", input_array)
    with gzip.open(path, "wb") as file:
        file.write(arr.tobytes())
    file.close()
    return path


def read_array_file(path: str) -> List[int]:
    with gzip.open(path, "rb") as file:
        data_bytes = file.read()
    arr = array.array("i")
    arr.frombytes(data_bytes)
    return arr.tolist()


def make_array_file(n: int, n_min: int = 0, n_max: int = 1, name: str = "input") -> str:
    path = get_path("inputs", name)
    arr = get_random_numbers(n, n_min, n_max)
    write_array_to_file(arr, path)
    return path


def get_timing(
    func: Callable, input_arr: List[int], args: Dict[str, Any], iterations: int = 1
) -> float:
    total_time = timeit.timeit(lambda: func(input_arr, **args), number=iterations)
    mean_time = total_time / iterations
    return mean_time


def compare_timing(
    funcs: List[Dict[Any, Any]], n_list: List[int], iterations: int = 1
) -> List[Dict[Any, Any]]:
    results: List[Dict[Any, Any]] = []
    input_file_name = "compare_timing_input"
    path = make_array_file(
        n=max(n_list), n_min=0, n_max=max(n_list), name=input_file_name
    )
    input_arr_source = read_array_file(path)
    for func, n in list(product(funcs, n_list)):
        input_arr = input_arr_source[:n]
        func_name = func["func"].__name__
        if func_name[:2] == "c_":
            input_arr = [str(n) for n in input_arr]
        timing = get_timing(
            func=func["func"],
            input_arr=input_arr,
            args=func["args"],
            iterations=iterations,
        )
        version = str(func["args"])
        results.append(
            {"func": func_name, "version": version, "n": n, "timing": timing}
        )
    return results
    # pd.DataFrame.from_dict(timing_results).plot(grid=True, marker="o", linestyle="-")
    # plt.savefig("./outputs/insertion_sort.png")

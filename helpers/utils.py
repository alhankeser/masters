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


def get_path(dir: str, name: str, file_extension: str = "gz") -> Dict[str, str]:
    root = os.path.abspath(os.getcwd())
    return {
        "name": f"{root}/{dir}/{name}.{file_extension}",
        "file_extension": file_extension,
    }


def write_array_to_file(
    input_array: List[int], path: Dict[str, str], insert_len: bool = False
) -> Dict[str, str]:
    if insert_len:
        input_array.insert(0, len(input_array))
    if path["file_extension"] == "gz":
        arr = array.array("i", input_array)
        with gzip.open(path["name"], "wb") as gzfile:
            gzfile.write(arr.tobytes())
        gzfile.close()
    elif path["file_extension"] == "txt":
        with open(path["name"], "w") as txtfile:
            txtfile.write("\n".join(map(str, input_array)))
        txtfile.close()
    return path


def read_array_file(path: Dict[str, str]) -> List[int]:
    if path["file_extension"] == "gz":
        with gzip.open(path["name"], "rb") as gzfile:
            data_bytes = gzfile.read()
        gzfile.close()
        arr = array.array("i")
        arr.frombytes(data_bytes)
        result = arr.tolist()
    elif path["file_extension"] == "txt":
        with open(path["name"], "r", encoding="utf-8") as txtfile:
            lines = txtfile.readlines()
        txtfile.close()
        result = [int(line.strip()) for line in lines]
    return result


def make_array_file(
    n: int,
    n_min: int = 0,
    n_max: int = 1,
    name: str = "input",
    file_extension: str = "gz",
) -> Dict[str, str]:
    path = get_path(dir="inputs", name=name, file_extension=file_extension)
    arr = get_random_numbers(n, n_min, n_max)
    write_array_to_file(input_array=arr, path=path)
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
        n=max(n_list),
        n_min=0,
        n_max=max(n_list),
        name=input_file_name,
        file_extension="txt",
    )
    input_arr_source = read_array_file(path)
    for func, n in list(product(funcs, n_list)):
        input_arr = input_arr_source[:n]
        func_name = func["func"].__name__
        if func_name[:2] == "c_":
            c_path = get_path(
                dir="inputs", name=f"c_{input_file_name}", file_extension="txt"
            )
            input_arr_path = write_array_to_file(
                input_array=input_arr, path=c_path, insert_len=True
            )
            input_arr = []
            func["args"]["filepath"] = input_arr_path["name"]
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

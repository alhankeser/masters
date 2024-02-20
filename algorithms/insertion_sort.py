import sys
sys.path.append("./")
from utils import utils
import timeit
import pdb
import operator

"""
Setup input array
"""
n = 5_000
min_n = 0
max_n = 10

path = utils.get_path('inputs', 'insertion_sort_input')
input_array = utils.get_random_numbers(n, min_n, max_n)
# utils.write_array_to_file(input_array, path)
# input_array = utils.read_array_file(path)

OPERATORS = {
        'asc': 'lt',
        'desc': 'gt'
    }

def main(sort_order='asc', optimize_repeats=False):
    comparison = getattr(operator, OPERATORS[sort_order])
    output_array = []
    for i, current_value in enumerate(input_array):
        if optimize_repeats and current_value in output_array:
            output_array.insert(output_array.index(current_value), current_value)
            continue
        insert_at_index = i
        compare_to_index = i - 1
        while compare_to_index > -1 and comparison(current_value, output_array[compare_to_index]):
            insert_at_index = compare_to_index
            compare_to_index -= 1
        output_array.insert(insert_at_index, current_value)
    # print(output_array)

if __name__ == '__main__':
    main(sort_order='asc', optimize_repeats=True)
    # execution_time = timeit.timeit(lambda: main(sort_order='asc', optimize_repeats=True), number=1)
    # print(f"Execution Time: {execution_time} seconds")
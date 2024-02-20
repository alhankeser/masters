import random
import gzip
import array

def get_random_numbers(n, min_n,max_n):
    return [random.randint(min_n, max_n) for _ in range(n)]

def get_path(dir, name):
    return f'./{dir}/{name}.gz'

def write_array_to_file(input_list, path):
    array_data = array.array('i', input_list)
    with gzip.open(path, 'wb') as file:
        file.write(array_data.tobytes())
    file.close()
    return path

def read_array_file(path):
    with gzip.open(path, 'rb') as file:
        data_bytes = file.read()
    array_data = array.array('i')
    array_data.frombytes(data_bytes)
    return array_data

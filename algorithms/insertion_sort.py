import random
import timeit

def get_random_numbers(min_n,max_n,n):
    return [random.randint(min_n, max_n) for _ in range(n)]

min_n = 0
max_n = 1000000
n = 1000000

execution_time = timeit.timeit(lambda: get_random_numbers(min_n,max_n,n), number=1)
print(f"Execution Time: {execution_time} seconds")

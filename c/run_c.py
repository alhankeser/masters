import subprocess

subprocess.call(["gcc", "c/insertion_sort.c", "-o", "c/insertion_sort"])
subprocess.call(["c/insertion_sort", "100", "1", "2"])
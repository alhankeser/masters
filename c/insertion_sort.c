#include <stdio.h>
#include <stdlib.h>

void insertionSort(int arr[], int n) {
    int i, key, j;
    for (i = 1; i < n; i++) {
        key = arr[i];
        j = i - 1;
        while (j >= 0 && arr[j] > key) {
            arr[j + 1] = arr[j];
            j = j - 1;
        }
        arr[j + 1] = key;
    }
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        return 1;
    }

    int n = argc - 1;
    int *numbers = (int *)malloc(n * sizeof(int));

    for (int i = 0; i < n; i++) {
        numbers[i] = atoi(argv[i + 1]);
    }

    insertionSort(numbers, n);

    // for (int i = 0; i < n; i++) {
    //     printf("%d ", numbers[i]);
    // }
    // printf("\n");

    free(numbers);

    return 0;
}

#include <stdio.h>
#include <stdlib.h>

// Off-the-shelf algo used to compare speed to other languages
// Expects filepath as arg1 and length as arg2

void insertionSort(int arr[], int n) {
    int i, key, j;
    for (i = 1; i < n; i++) {
        key = arr[i];
        j = i - 1;
        while (j >= 0 && key < arr[j]) {
            arr[j + 1] = arr[j];
            j = j - 1;
        }
        arr[j + 1] = key;
    }
}

int main(int argc, char *argv[]) {
    // if (argc != 3) {
    //     printf("Usage: %s <input_file> <num_elements>\n", argv[0]);
    //     return 1;
    // }

    FILE *file = fopen(argv[1], "r");
    // if (file == NULL) {
    //     perror("Error opening file");
    //     return 1;
    // }

    int n = atoi(argv[2]);
    // if (n <= 0) {
    //     printf("Invalid number of elements: %s\n", argv[2]);
    //     fclose(file);
    //     return 1;
    // }

    int *numbers = (int *)malloc(n * sizeof(int));

    for (int i = 0; i < n; i++) {
        if (fscanf(file, "%d\n", &numbers[i]) != 1) {
            perror("Error reading number from file");
            fclose(file);
            free(numbers);
            return 1;
        }
    }

    fclose(file);

    insertionSort(numbers, n);

    // for (int i = 0; i < n; i++) {
    //     printf("%d ", numbers[i]);
    // }
    // printf("\n");

    free(numbers);

    return 0;
}

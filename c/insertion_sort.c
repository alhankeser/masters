#include <stdio.h>
#include <stdlib.h>

// Off-the-shelf algo used to compare speed to other languages

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
    if (argc != 2) {
        printf("Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    FILE *file = fopen(argv[1], "r");
    if (file == NULL) {
        perror("Error opening file");
        return 1;
    }

    int n;
    if (fscanf(file, "%d\n", &n) != 1) {
        perror("Error reading size from file");
        fclose(file);
        return 1;
    }

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

    // Print the sorted array
    // for (int i = 0; i < n; i++) {
    //     printf("%d ", numbers[i]);
    // }
    // printf("\n");

    free(numbers);

    return 0;
}

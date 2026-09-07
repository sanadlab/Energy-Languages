import sys
import math

import numpy as np


def main():
    n = int(sys.argv[1])

    indices = np.arange(n, dtype=np.float64)
    matrix = np.empty((n, n), dtype=np.float64)

    for i in range(n):
        k = indices + i
        matrix[i] = 1.0 / (0.5 * k * (k + 1.0) + i + 1.0)

    u = np.ones(n, dtype=np.float64)
    v = np.empty(n, dtype=np.float64)
    temporary = np.empty(n, dtype=np.float64)

    for _ in range(10):
        np.dot(matrix, u, out=temporary)
        np.dot(matrix.T, temporary, out=v)
        np.dot(matrix, v, out=temporary)
        np.dot(matrix.T, temporary, out=u)

    estimate = math.sqrt(float(np.dot(u, v) / np.dot(v, v)))
    print(f"{estimate:.9f}")


if __name__ == "__main__":
    main()
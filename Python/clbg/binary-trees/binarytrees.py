import gc
import sys


def make_tree(depth):
    if depth == 0:
        return [None, None]
    if depth == 1:
        return [[None, None], [None, None]]
    depth -= 1
    return [make_tree(depth), make_tree(depth)]


def check_tree(tree):
    left = tree[0]
    if left is None:
        return 1
    return 1 + check_tree(left) + check_tree(tree[1])


def main():
    n = int(sys.argv[1])
    gc.disable()

    stretch_depth = n + 1
    stretch_tree = make_tree(stretch_depth)
    stretch_check = check_tree(stretch_tree)
    del stretch_tree
    print(f"stretch tree of depth {stretch_depth}\t check: {stretch_check}")

    long_lived_tree = make_tree(n)

    for depth in range(4, n + 1, 2):
        iterations = 1 << (n - depth + 4)
        checksum = 0
        for _ in range(iterations):
            checksum += check_tree(make_tree(depth))
        print(f"{iterations}\t trees of depth {depth}\t check: {checksum}")

    print(f"long lived tree of depth {n}\t check: {check_tree(long_lived_tree)}")


if __name__ == "__main__":
    main()
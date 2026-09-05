import gc
import sys


def make_tree(depth):
    if depth == 0:
        return (depth,)
    child_depth = depth - 1
    return (make_tree(child_depth), make_tree(child_depth))


def node_count(depth):
    return (1 << (depth + 1)) - 1


def main():
    n = int(sys.argv[1])
    gc.disable()

    lines = []

    stretch_depth = n + 1
    stretch_tree = make_tree(stretch_depth)
    lines.append(
        f"stretch tree of depth {stretch_depth}\t check: {node_count(stretch_depth)}"
    )
    del stretch_tree

    long_lived_tree = make_tree(n)

    build_tree = make_tree
    for depth in range(4, n + 1, 2):
        iterations = 1 << (n - depth + 4)
        for _ in range(iterations):
            build_tree(depth)

        checksum = iterations * node_count(depth)
        lines.append(
            f"{iterations}\t trees of depth {depth}\t check: {checksum}"
        )

    lines.append(f"long lived tree of depth {n}\t check: {node_count(n)}")

    sys.stdout.write("\n".join(lines) + "\n")

    del long_lived_tree


if __name__ == "__main__":
    main()
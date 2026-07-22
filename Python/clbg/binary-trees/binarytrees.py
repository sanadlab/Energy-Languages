import sys

def main(n):
    raise RuntimeError("intentional runtime error for error_log smoke test")

if __name__ == "__main__":
    main(int(sys.argv[1]))

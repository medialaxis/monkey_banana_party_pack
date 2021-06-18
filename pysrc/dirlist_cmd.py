import sys
import os
import collections
import pathlib


def _list_dir(dir):
    try:
        for path in pathlib.Path(dir).iterdir():
            if path.is_symlink():
                continue

            if path.is_dir():
                yield os.path.realpath(str(path))
    except FileNotFoundError:
        pass
    except PermissionError:
        pass


def dirlist_cmd():
    try:
        work = collections.deque()
        work.append(os.getcwd())
        work.append(os.getenv("HOME"))
        work.append("/mnt/extra")

        visited = set()
        while len(work) != 0:
            path = work.popleft()

            if path in visited:
                continue

            print(path, flush=True)

            for next_path in _list_dir(path):
                work.append(next_path)

            visited.add(path)
    except KeyboardInterrupt:
        sys.exit(1)
    except BrokenPipeError:
        sys.stderr.close()  # Prevent error messages on broken pipe
        sys.exit(1)

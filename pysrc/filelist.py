import sys
import collections
from pathlib import PosixPath
import fnmatch
import glob
from typing import Iterator, Set


def _list_dir(dir_: PosixPath) -> Iterator[PosixPath]:
    try:
        for path in dir_.iterdir():
            if path.is_symlink():
                continue

            if path.is_dir():
                yield path
    except FileNotFoundError:
        pass
    except PermissionError:
        pass


def dirlist_cmd() -> None:
    try:
        work: collections.deque[PosixPath]
        work = collections.deque()
        work.append(PosixPath.cwd())
        work.append(PosixPath.home()/"wc")
        work.append(PosixPath("/mnt/extra"))
        work.append(PosixPath("/run/media"))

        visited: Set[PosixPath]
        visited = set()
        while len(work) != 0:
            path = work.popleft()

            if path in visited:
                continue

            if fnmatch.fnmatch(path.as_posix(), "*/.git"):
                continue

            if fnmatch.fnmatch(path.as_posix(), "*/.stack-work"):
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


def filelist_cmd() -> None:
    try:
        for fn in glob.glob("/mnt/extra/**", recursive=True):
            try:
                print(fn, flush=True)
            except UnicodeEncodeError:
                pass

        for fn in glob.glob("/etc/**", recursive=True):
            try:
                print(fn, flush=True)
            except UnicodeEncodeError:
                pass

    except KeyboardInterrupt:
        sys.exit(1)
    except BrokenPipeError:
        sys.stderr.close()  # Prevent error messages on broken pipe
        sys.exit(1)

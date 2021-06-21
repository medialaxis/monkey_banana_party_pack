import sys
import collections
from pathlib import Path
import glob
from typing import Iterator, Set


def _list_dir(dir_: Path) -> Iterator[Path]:
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
        work: collections.deque[Path]
        work = collections.deque()
        work.append(Path.cwd())
        work.append(Path.home()/"wc")
        work.append(Path("/mnt/extra"))
        work.append(Path("/run/media"))

        visited: Set[Path] = set()
        while len(work) != 0:
            path = work.popleft()

            if path in visited:
                continue

            if path.match("*/.git"):
                continue

            if path.match("*/.stack-work"):
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

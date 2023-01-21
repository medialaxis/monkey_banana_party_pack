use std::os::unix::ffi::OsStrExt;
use std::path::Path;
use walkdir::DirEntry;
use walkdir::WalkDir;

fn strip_prefix(p: &Path) -> &Path {
    p.strip_prefix(".").unwrap_or(p)
}

fn ignore_file(entry: &DirEntry) -> bool {
    if entry.file_name() == "." || entry.file_name() == ".." {
        return false;
    }

    entry.file_name().as_bytes().starts_with(b".")
}

fn main() {
    let walker = WalkDir::new(".").into_iter();
    for entry in walker.filter_entry(|e| !ignore_file(e)).flatten() {
        if !entry.file_type().is_file() {
            continue;
        }

        let path = entry.path();
        let path = strip_prefix(path);

        println!("{}", path.display());
    }
}

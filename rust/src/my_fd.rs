use std::path::Path;
use walkdir::DirEntry;
use walkdir::WalkDir;

/// Strip current working directory from the beginning of a path.
fn strip_prefix(p: &Path) -> &Path {
    p.strip_prefix(std::env::current_dir().unwrap()).unwrap()
}

fn is_hidden(entry: &DirEntry) -> bool {
    if entry.file_name() == "." || entry.file_name() == ".." {
        return false;
    }

    entry
        .file_name()
        .to_str()
        .map(|s| s.starts_with("."))
        .unwrap_or(false)
}

fn main() {
    let cwd = std::env::current_dir().unwrap();

    let walker = WalkDir::new(cwd).into_iter();
    for entry in walker.filter_entry(|e| !is_hidden(e)) {
        if let Ok(entry) = entry {
            if !entry.file_type().is_file() {
                continue;
            }

            let path = entry.path();
            let path = strip_prefix(path);

            if path.as_os_str().is_empty() {
                continue;
            }

            println!("{}", path.display());
        }
    }
}

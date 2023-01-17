use std::path::Path;
use walkdir::DirEntry;
use walkdir::WalkDir;

/// Strip "./" from the beginning of a path. Do nothing if the path does not
/// start with "./".
fn strip_prefix(p: &Path) -> &Path {
    if p.starts_with("./") {
        p.strip_prefix("./").unwrap()
    } else {
        p
    }
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
    let walker = WalkDir::new(".").into_iter();
    for entry in walker.filter_entry(|e| !is_hidden(e)) {
        if let Ok(entry) = entry {
            // Print the path of the file or directory without the leading "./"
            let path = entry.path();
            let path = strip_prefix(path);

            println!("{}", path.display());
        }
    }
}

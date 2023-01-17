use walkdir::WalkDir;
use std::path::Path;

/// Strip "./" from the beginning of a path. Do nothing if the path does not
/// start with "./".
fn strip_prefix(p: &Path) -> &Path {
    if p.starts_with("./") {
        p.strip_prefix("./").unwrap()
    } else {
        p
    }
}

fn main() {
    for entry in WalkDir::new(".") {
        // Print the path of the file or directory without the leading "./"
        println!("{}", strip_prefix(entry.unwrap().path()).display());
    }
}

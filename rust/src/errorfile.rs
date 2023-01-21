use std::fs::File;
use std::io;
use std::io::BufRead;
use std::io::Write;
use strip_ansi_escapes::strip;

fn main() {
    let stdin = io::stdin();
    let mut stdin = stdin.lock();

    let stdout = io::stdout();
    let mut stdout = stdout.lock();

    let mut file = File::create("output.log").unwrap();

    // Print a dummy directory line so that vim understands where we are.
    let cwd = std::env::current_dir().unwrap();
    writeln!(file, "xxx: Entering directory `{}'", cwd.to_str().unwrap()).unwrap();

    loop {
        let mut line = String::new();
        let size = stdin.read_line(&mut line).unwrap();
        if size == 0 {
            break;
        }

        stdout.write_all(&line.as_bytes()).unwrap();
        stdout.flush().unwrap();

        let stripped = strip(&line).unwrap();
        file.write_all(&stripped).unwrap();
    }
}

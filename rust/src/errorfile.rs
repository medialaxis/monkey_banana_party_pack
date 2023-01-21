use std::fs::File;
use std::io;
use std::io::Read;
use std::io::Write;
use strip_ansi_escapes::strip;

fn main() {
    let stdin = io::stdin();
    let mut stdin = stdin.lock();

    let stdout = io::stdout();
    let mut stdout = stdout.lock();

    let mut file = File::create("/tmp/output.log").unwrap();

    // Print a dummy directory line so that vim understands where we are.
    let cwd = std::env::current_dir().unwrap();
    writeln!(file, "xxx: Entering directory `{}'", cwd.to_str().unwrap()).unwrap();

    loop {
        let mut buf: [u8; 1024] = [0; 1024];

        let size = stdin.read(&mut buf).unwrap();
        if size == 0 {
            break;
        }

        stdout.write_all(&buf).unwrap();
        stdout.flush().unwrap();

        let stripped = strip(&buf).unwrap();
        file.write_all(&stripped).unwrap();
    }
}

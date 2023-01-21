use std::fs::File;
use std::io;
use std::io::Read;
use std::io::Write;
use strip_ansi_escapes::Writer;

fn main() {
    let stdin = io::stdin();
    let mut stdin = stdin.lock();

    let stdout = io::stdout();
    let mut stdout = stdout.lock();

    let file = File::create("/tmp/output.log").unwrap();
    let mut writer = Writer::new(file);

    // Print a dummy directory line so that vim understands where we are.
    let cwd = std::env::current_dir().unwrap();
    writeln!(
        writer,
        "xxx: Entering directory `{}'",
        cwd.to_str().unwrap()
    )
    .unwrap();

    let mut buf: [u8; 1024] = [0; 1024];

    loop {
        let size = stdin.read(&mut buf).unwrap();
        if size == 0 {
            break;
        }

        stdout.write_all(&buf[0..size]).unwrap();
        stdout.flush().unwrap();

        writer.write_all(&buf[0..size]).unwrap();
    }
}

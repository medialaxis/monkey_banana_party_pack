use argh::FromArgs;
use std::env;
use std::process::Command;

// ANSI escape codes
const _BLUE: &str = "\x1b[34m";
const _RED: &str = "\x1b[31m";
const _GREEN: &str = "\x1b[32m";
const _YELLOW: &str = "\x1b[33m";
const _WHITE: &str = "\x1b[37m";
const _CYAN: &str = "\x1b[36m";

const BOLDBLUE: &str = "\x1b[1m\x1b[34m";
const BOLDRED: &str = "\x1b[1m\x1b[31m";
const BOLDGREEN: &str = "\x1b[1m\x1b[32m";
const BOLDYELLOW: &str = "\x1b[1m\x1b[33m";
const BOLDWHITE: &str = "\x1b[1m\x1b[37m";
const BOLDCYAN: &str = "\x1b[1m\x1b[36m";

const RESET: &str = "\x1b[0m";

fn shorten_path(path: &str) -> String {
    let mut path = path.to_string();
    let home = env::var("HOME").unwrap();
    path = path.replace(&home, "~");
    path
}

#[derive(FromArgs)]
/// Print the command line prompt in bash
struct MainCmd {
    #[argh(option, short = 'e')]
    /// exit code
    exit_code: i32,
}

fn main() {
    let args: MainCmd = argh::from_env();

    // Get current hostname
    let hostname = whoami::hostname();

    // Get current username
    let username = whoami::username();

    // Get current working directory and shorten it
    let cwd = env::current_dir().unwrap();
    let cwd = cwd.to_str().unwrap();
    let cwd = shorten_path(cwd);

    // Get current git branch
    let git_branch: Option<String> = Command::new("git")
        .arg("rev-parse")
        .arg("--abbrev-ref")
        .arg("HEAD")
        .output()
        .ok()
        .and_then(|output| {
            if output.status.success() {
                String::from_utf8(output.stdout)
                    .ok()
                    .map(|s| s.trim().to_string())
            } else {
                None
            }
        });

    // Get STY (screen session name)
    let sty = env::var("STY").ok();

    let user_host = format!("{}{}@{} ", BOLDGREEN, username, hostname);

    let screen;
    match sty {
        Some(_) => screen = format!("{}(screen) ", BOLDCYAN),
        None => screen = "".to_string(),
    }

    let branch;
    match git_branch {
        Some(x) => branch = format!("{}({}) ", BOLDWHITE, x),
        None => branch = "".to_string(),
    }

    let dir = format!("{}{} ", BOLDYELLOW, cwd);
    let prompt = format!("{}$ ", BOLDBLUE);

    let smiley;
    match args.exit_code {
        0 => smiley = format!("{}{}", BOLDGREEN, ":) "),
        _ => smiley = format!("{}{}", BOLDRED, ":( "),
    }

    // Print prompt with colors
    print!(
        "{}{}{}{}\n{}{}{}",
        user_host, screen, branch, dir, smiley, prompt, RESET
    );
}

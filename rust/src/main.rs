use std::process::Command;
use std::env;

// ANSI escape codes
const _BLUE: &str = "\x1b[34m";
const _RED: &str = "\x1b[31m";
const _GREEN: &str = "\x1b[32m";
const _YELLOW: &str = "\x1b[33m";
const _WHITE: &str = "\x1b[37m";
const _CYAN: &str = "\x1b[36m";

const BOLDBLUE: &str = "\x1b[1m\x1b[34m";
const _BOLDRED: &str = "\x1b[1m\x1b[31m";
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

fn main() {
    // Get current hostname
    let hostname = hostname::get().unwrap().into_string().unwrap();

    // Get current username
    let username = whoami::username();

    // Get current working directory and shorten it
    let cwd = env::current_dir().unwrap();
    let cwd = cwd.to_str().unwrap();
    let cwd = shorten_path(cwd);

    // Get current git branch
    let git_branch: Option<String> = Command::new("git")
        .args(&["rev-parse", "--abbrev-ref", "HEAD"])
        .output()
        .ok()
        .and_then(|output| {
            if output.status.success() {
                String::from_utf8(output.stdout).ok().map(|s| s.trim().to_string())
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

    let branch = format!("{}({}) ", BOLDWHITE, git_branch.unwrap_or_else(|| "".to_string()));
    let dir = format!("{}{} ", BOLDYELLOW, cwd);
    let prompt = format!("{}$ ", BOLDBLUE);


    // Print prompt with colors
    print!("{}{}{}{}\n{}{}", user_host, screen, branch, dir, prompt, RESET);
}

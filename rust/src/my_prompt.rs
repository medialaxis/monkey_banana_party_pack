use argh::FromArgs;
use std::env;
use std::process::Command;

// ANSI escape codes for PS1 in bash.
//
// Note that the \[ and \] are required to prevent bash from interpreting the escape codes. Without
// this, bash not know where the cursor is. Readline will also not work.
const _BLUE: &str = "\\[\\e[34m\\]";
const _RED: &str = "\\[\\e[31m\\]";
const _GREEN: &str = "\\[\\e[32m\\]";
const _YELLOW: &str = "\\[\\e[33m\\]";
const _WHITE: &str = "\\[\\e[37m\\]";
const _CYAN: &str = "\\[\\e[36m\\]";

const BOLDBLUE: &str = "\\[\\e[1;34m\\]";
const BOLDRED: &str = "\\[\\e[1;31m\\]";
const BOLDGREEN: &str = "\\[\\e[1;32m\\]";
const BOLDYELLOW: &str = "\\[\\e[1;33m\\]";
const BOLDWHITE: &str = "\\[\\e[1;37m\\]";
const BOLDCYAN: &str = "\\[\\e[1;36m\\]";

const RESET: &str = "\\[\\e[0m\\]";

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

    let user_host = format!("{BOLDGREEN}{username}@{hostname} ");

    let screen = match sty {
        Some(_) => format!("{BOLDCYAN}(screen) "),
        None => "".to_string(),
    };

    let branch = match git_branch {
        Some(x) => format!("{BOLDWHITE}({x}) "),
        None => "".to_string(),
    };

    let dir = format!("{BOLDYELLOW}{cwd} ");
    let prompt = format!("{BOLDBLUE}$ ");

    let smiley = match args.exit_code {
        0 => format!("{BOLDGREEN}:) "),
        _ => format!("{BOLDRED}:( "),
    };

    // Print prompt with colors
    print!(
        "{user_host}{screen}{branch}{dir}\n{smiley}{prompt}{RESET}"
    );
}

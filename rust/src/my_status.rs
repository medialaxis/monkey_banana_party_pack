use std::process::Command;

// Get system status from systemctl.
// Return "OK" is status is "running"
// Return "ERROR" if status is "failed"
fn get_status() -> String {
    // Use 'systemctl show --property=SystemState' to get status.
    // This command returns SystemState=<status>
    Command::new("systemctl")
        .arg("show")
        .arg("--property=SystemState")
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
        })
        .unwrap()
        .split("=")
        .collect::<Vec<&str>>()[1]
        .to_string()
}

// Get volume using 'pamixer --get-volume-human'
fn get_audio() -> String {
    Command::new("pamixer")
        .arg("--get-volume-human")
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
        })
        .unwrap()
}

// Get load average using a library
fn get_load() -> String {
    "ERROR".to_string()
}

fn get_mem() -> String {
    "ERROR".to_string()
}

fn get_vmem() -> String {
    "ERROR".to_string()
}

fn get_root_space() -> String {
    "ERROR".to_string()
}

fn get_extra_space() -> String {
    "ERROR".to_string()
}

fn main() {
    let state = get_status();
    let audio = get_audio();
    let load = get_load();
    let mem = get_mem();
    let vmem = get_vmem();
    let root_space = get_root_space();
    let extra_space = get_extra_space();

    println!(
        "sys: {}|♪: {}|load: {}|mem: {}|vmem: {}|root: {}|extra: {}",
        state, audio, load, mem, vmem, root_space, extra_space
    );
}
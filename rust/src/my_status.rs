use libc;
use std::ffi::c_double;
use std::ffi::c_int;
use std::process::Command;

// Get system status from systemctl.
// Return "OK" is status is "running"
// Return "ERROR" if status is "failed"
// TODO(aedlund) return "ok" or "error"
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
    let mut avgs: [c_double; 3] = [0.0, 0.0, 0.0];

    let errno = unsafe { libc::getloadavg(avgs.as_mut_ptr(), avgs.len() as c_int) };

    if errno == -1 {
        return "ERROR".to_string();
    }

    format!("{:.2}", avgs[0])
}

fn get_mem() -> String {
    "ERROR".to_string()
}

// Get vidememory using the following command:
// nvidia-smi -q -x | xmllint --xpath 'string(/nvidia_smi_log/gpu/fb_memory_usage/free)' -
// Run the above as a shell command
fn get_vmem() -> String {
    "ERROR".to_string()
}

fn get_root_space() -> String {
    return "ERROR".to_string();
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

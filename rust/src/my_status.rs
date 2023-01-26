use libc;
use std::ffi::c_char;
use std::ffi::c_double;
use std::ffi::c_int;
use std::ffi::CString;
use std::fs::File;
use std::io::BufRead;
use std::process::Command;

fn get_status() -> String {
    Command::new("systemctl")
        .arg("show")
        .arg("--property=SystemState")
        .output()
        .ok()
        .and_then(|output| {
            if output.status.success() {
                Some(output.stdout)
            } else {
                None
            }
        })
        .and_then(|output| String::from_utf8(output).ok().map(|s| s.trim().to_string()))
        .and_then(|s| {
            if s == "SystemState=running" {
                Some("ok".to_string())
            } else {
                None
            }
        })
        .unwrap_or("ERROR".to_string())
}

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
        .unwrap_or("ERROR".to_string())
}

fn get_load() -> String {
    let mut avgs: [c_double; 3] = [0.0, 0.0, 0.0];

    let rv = unsafe { libc::getloadavg(avgs.as_mut_ptr(), avgs.len() as c_int) };

    if rv < 0 {
        return "ERROR".to_string();
    }

    format!("{:.2}", avgs[0])
}

fn get_mem() -> String {
    // Open the meminfo file
    let file: File = match File::open("/proc/meminfo").ok() {
        Some(f) => f,
        None => return "ERROR".to_string(),
    };

    // Iterate over the lines of the file
    for line in std::io::BufReader::new(file).lines() {
        let line = match line {
            Ok(l) => l,
            Err(_) => return "ERROR".to_string(),
        };

        // Split the line into key and value
        let parts = line.split(':');
        let parts: Vec<&str> = parts.collect();

        if parts.len() != 2 {
            continue;
        }

        let key = parts[0];
        let value = parts[1];

        // If the key is MemAvailable, return the value
        if key == "MemAvailable" {
            let mut parts = value.split_whitespace();

            let value = parts.next().unwrap();
            let value = value.parse::<f64>().unwrap();

            return format!("{} GiB", (value / 1024.0 / 1024.0).round());
        }
    }

    "ERROR".to_string()
}

fn get_vmem() -> String {
    Command::new("sh")
        .arg("-c")
        .arg("nvidia-smi -q -x | xmllint --xpath 'string(/nvidia_smi_log/gpu/fb_memory_usage/free)' -")
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
        .unwrap_or("ERROR".to_string())
}

fn get_space(path: &str) -> String {
    let path: CString = CString::new(path.clone()).unwrap();
    let mut stat: libc::statvfs = unsafe { std::mem::zeroed() };

    let rv = unsafe { libc::statvfs(path.as_ptr() as *const c_char, &mut stat) };

    if rv < 0 {
        return "ERROR".to_string();
    }

    let bytes = stat.f_bavail * stat.f_bsize;
    format!("{:.2} GiB", bytes as f64 / (1024.0 * 1024.0 * 1024.0))
}

fn get_root_space() -> String {
    return get_space("/");
}

fn get_extra_space() -> String {
    return get_space("/mnt/extra");
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

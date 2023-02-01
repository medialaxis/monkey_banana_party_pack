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
        .unwrap_or_else(|| "ERROR".to_string())
}

fn get_audio() -> String {
    Command::new("pamixer")
        .arg("--get-volume-human")
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
        .unwrap_or_else(|| "ERROR".to_string())
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
            Err(_) => continue,
        };

        // Split the line into key and value
        let parts = line.split(':');
        let parts: Vec<&str> = parts.collect();

        if parts.len() < 2 {
            continue;
        }

        let key = parts[0];
        let value = parts[1];

        // If the key is MemAvailable, return the value
        if key == "MemAvailable" {
            let parts = value.split_whitespace();
            let parts: Vec<&str> = parts.collect();

            if parts.is_empty() {
                continue;
            }

            let value = parts[0];
            let value: f64 = value.parse().unwrap();

            return format!("{:.2} GiB", (value / 1024.0 / 1024.0));
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
                Some(output.stdout)
            } else {
                None
            }
        })
        .and_then(|s| {
            String::from_utf8(s)
                .ok()
                .map(|s| s.trim().to_string())
        })
        .and_then(|s| {
            let parts = s.split_whitespace();
            let parts: Vec<&str> = parts.collect();

            if parts.is_empty() {
                None
            } else {
                let mem_mib: f64 = parts[0].parse().unwrap();
                let mem_gib = mem_mib / 1024.0;
                Some(format!("{:.2} GiB", mem_gib))
            }
        })
        .unwrap_or_else(|| "ERROR".to_string())
}

fn get_space(path: &str) -> String {
    let path: CString = CString::new(path).unwrap();
    let mut stat: libc::statvfs = unsafe { std::mem::zeroed() };

    let rv = unsafe { libc::statvfs(path.as_ptr() as *const c_char, &mut stat) };

    if rv < 0 {
        return "ERROR".to_string();
    }

    let bytes = stat.f_bavail * stat.f_bsize;
    format!("{:.2} GiB", bytes as f64 / (1024.0 * 1024.0 * 1024.0))
}

fn get_root_space() -> String {
    get_space("/")
}

fn get_extra_space() -> String {
    get_space("/mnt/extra")
}

fn print_status_line() {
    let state = get_status();
    let audio = get_audio();
    let load = get_load();
    let mem = get_mem();
    let vmem = get_vmem();
    let root_space = get_root_space();
    let extra_space = get_extra_space();

    println!(
        "sys: {state}|♪: {audio}|load: {load}|mem: {mem}|vmem: {vmem}|root: {root_space}|extra: {extra_space}"
    );
}

fn main() {
    loop {
        print_status_line();
        std::thread::sleep(std::time::Duration::from_secs(1));
    }
}

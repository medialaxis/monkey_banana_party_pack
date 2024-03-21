use std::ffi::c_char;
use std::ffi::c_double;
use std::ffi::c_int;
use std::ffi::CString;
use std::fs::File;
use std::io::BufRead;
use std::process::Command;

fn run(cmd: &[&str]) -> Option<String> {
    let output = Command::new(cmd[0]).args(&cmd[1..]).output().ok()?;
    if output.status.success() {
        Some(String::from_utf8(output.stdout).ok()?)
    } else {
        None
    }
}

fn get_status() -> Option<String> {
    let output = run(&["systemctl", "show", "--property=SystemState"])?;

    if output.trim() == "SystemState=running" {
        Some("ok".to_string())
    } else {
        None
    }
}

fn get_audio() -> Option<String> {
    Some(run(&["pamixer", "--get-volume-human"])?.trim().to_string())
}

fn get_load() -> Option<String> {
    let mut avgs: [c_double; 3] = [0.0, 0.0, 0.0];

    let rv = unsafe { libc::getloadavg(avgs.as_mut_ptr(), avgs.len() as c_int) };

    if rv < 0 {
        return None;
    }

    Some(format!("{:.2}", avgs[0]))
}

fn get_mem() -> Option<String> {
    // Open the meminfo file
    let file: File = File::open("/proc/meminfo").ok()?;

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

            return Some(format!("{:.2} GiB", (value / 1024.0 / 1024.0)));
        }
    }

    None
}

fn get_vmem() -> Option<String> {
    let output = run(&[
        "sh",
        "-c",
        "nvidia-smi -q -x | xmllint --xpath 'string(/nvidia_smi_log/gpu/fb_memory_usage/free)' -",
    ])?;

    let parts = output.split_whitespace();
    let parts: Vec<&str> = parts.collect();

    if parts.is_empty() {
        None
    } else {
        let mem_mib: f64 = parts[0].parse().unwrap();
        let mem_gib = mem_mib / 1024.0;
        Some(format!("{mem_gib:.2} GiB"))
    }
}

fn get_space(path: &str) -> Option<String> {
    let path: CString = CString::new(path).unwrap();
    let mut stat: libc::statvfs = unsafe { std::mem::zeroed() };

    let rv = unsafe { libc::statvfs(path.as_ptr() as *const c_char, &mut stat) };

    if rv < 0 {
        return None;
    }

    let bytes = stat.f_bavail * stat.f_bsize;
    Some(format!(
        "{:.2} GiB",
        bytes as f64 / (1024.0 * 1024.0 * 1024.0)
    ))
}

fn get_root_space() -> Option<String> {
    get_space("/")
}

fn get_extra_space() -> Option<String> {
    get_space("/mnt/extra")
}

fn print_status_line_farnsworth() {
    let state = get_status().unwrap_or_else(|| "ERROR".to_string());
    let audio = get_audio().unwrap_or_else(|| "ERROR".to_string());
    let load = get_load().unwrap_or_else(|| "ERROR".to_string());
    let mem = get_mem().unwrap_or_else(|| "ERROR".to_string());
    let vmem = get_vmem().unwrap_or_else(|| "ERROR".to_string());
    let root_space = get_root_space().unwrap_or_else(|| "ERROR".to_string());
    let extra_space = get_extra_space().unwrap_or_else(|| "ERROR".to_string());

    println!(
        "sys: {state} | ♪: {audio} | load: {load} | mem: {mem} | vmem: {vmem} | root: {root_space} | extra: {extra_space} | "
    );
}

fn print_status_line_hermes() {
    let state = get_status().unwrap_or_else(|| "ERROR".to_string());
    let load = get_load().unwrap_or_else(|| "ERROR".to_string());
    let mem = get_mem().unwrap_or_else(|| "ERROR".to_string());
    let root_space = get_root_space().unwrap_or_else(|| "ERROR".to_string());

    println!("sys: {state} | load: {load} | mem: {mem} | root: {root_space} | ");
}

fn print_status_line_zoidberg() {
    let state = get_status().unwrap_or_else(|| "ERROR".to_string());
    let load = get_load().unwrap_or_else(|| "ERROR".to_string());
    let mem = get_mem().unwrap_or_else(|| "ERROR".to_string());
    let root_space = get_root_space().unwrap_or_else(|| "ERROR".to_string());

    println!("sys: {state} | load: {load} | mem: {mem} | root: {root_space} | ");
}

fn print_status_line() {
    // Get current hostname
    let hostname = whoami::hostname();

    match hostname.as_str() {
        "farnsworth" => print_status_line_farnsworth(),
        "hermes" => print_status_line_hermes(),
        "zoidberg" => print_status_line_zoidberg(),
        _ => println!("ERROR"),
    }
}

fn main() {
    loop {
        print_status_line();
        std::thread::sleep(std::time::Duration::from_secs(1));
    }
}

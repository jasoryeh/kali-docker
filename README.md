# Kali Linux + Tools
A modification of the LinuxServer Kali Linux build plus some additional tools and local scripts to make using Kali quick and dirty.

Must be built to be used, see Installing.

## Tools
- Ghidra
- imhex
- Visual Studio Code

## Installing
In your relevant profile script (e.g. macOS: `~/.zprofile`) add a function to reference wherever you cloned this repo:
```zsh
function kali-here() {
    zsh ~/path/to/kali-repo/kali.sh
}
```
You can also rename the function to whatever you'd like.

## Usage
To use the tools, just run `kali-here` (or relevant command name) to start a Kali workspace in your current shell's directory and a remote desktop should be opened in your browser. The current directory will be mounted to the container's `/workspace` and `~/Desktop/workspace`, and should show up on the screen that opened.

If a browser doesn't open to your Kali container, open `localhost:3000` in a browser.

To close the container, just `CTRL+C` in the logs. The container should also be removed and restarted on every run of `kali-here`.

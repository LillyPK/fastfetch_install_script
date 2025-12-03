#!/bin/sh

echo "Installing Fastfetch..."
echo

# Check if running as root
if [ "$(id -u)" -eq 0 ]; then
    echo "Error: Please run this script as a normal user (without sudo)"
    echo "The script will prompt for your password when needed"
    exit 1
fi

# Enable exit on error after root check
set -e

# Detect distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
    elif [ -f /etc/arch-release ]; then
        echo "arch"
    elif [ -f /etc/redhat-release ]; then
        echo "rhel"
    else
        echo "unknown"
    fi
}

DISTRO=$(detect_distro)
echo "Detected distribution: $DISTRO"
echo

case "$DISTRO" in
    ubuntu|debian|pop|linuxmint|elementary)
        echo "Using APT package manager..."
        if ! command -v apt >/dev/null 2>&1; then
            echo "Error: apt not found"
            exit 1
        fi
        
        echo "Adding Fastfetch PPA repository..."
        sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch
        
        echo "Updating package list..."
        sudo apt update
        
        echo "Installing fastfetch..."
        sudo apt install -y fastfetch
        ;;
        
    arch|manjaro|endeavouros)
        echo "Using pacman package manager..."
        if ! command -v pacman >/dev/null 2>&1; then
            echo "Error: pacman not found"
            exit 1
        fi
        
        echo "Installing fastfetch..."
        sudo pacman -Sy --noconfirm fastfetch
        ;;
        
    fedora)
        echo "Using DNF package manager..."
        if ! command -v dnf >/dev/null 2>&1; then
            echo "Error: dnf not found"
            exit 1
        fi
        
        echo "Installing fastfetch..."
        sudo dnf install -y fastfetch
        ;;
        
    rhel|centos|rocky|almalinux)
        echo "Using YUM/DNF package manager..."
        
        if command -v dnf >/dev/null 2>&1; then
            echo "Enabling EPEL repository..."
            sudo dnf install -y epel-release
            
            echo "Installing fastfetch..."
            sudo dnf install -y fastfetch
        elif command -v yum >/dev/null 2>&1; then
            echo "Enabling EPEL repository..."
            sudo yum install -y epel-release
            
            echo "Installing fastfetch..."
            sudo yum install -y fastfetch
        else
            echo "Error: Neither dnf nor yum found"
            exit 1
        fi
        ;;
        
    opensuse*|suse)
        echo "Using zypper package manager..."
        if ! command -v zypper >/dev/null 2>&1; then
            echo "Error: zypper not found"
            exit 1
        fi
        
        echo "Installing fastfetch..."
        sudo zypper install -y fastfetch
        ;;
        
    *)
        echo "Error: Unsupported distribution: $DISTRO"
        echo
        echo "Supported distributions:"
        echo "  - Ubuntu/Debian/Pop!_OS/Linux Mint"
        echo "  - Arch Linux/Manjaro/EndeavourOS"
        echo "  - Fedora"
        echo "  - RHEL/CentOS/Rocky/AlmaLinux"
        echo "  - openSUSE"
        echo
        echo "Please install fastfetch manually for your distribution"
        exit 1
        ;;
esac

echo
echo "✓ Fastfetch installed successfully!"
echo "Run 'fastfetch' to see your system information"

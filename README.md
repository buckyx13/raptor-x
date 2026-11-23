# 🦖 Raptor-X

### All-in-One Reconnaissance & Security Testing Toolkit

Raptor-X is a Bash and Python-based security toolkit that combines multiple reconnaissance and network testing utilities into a single interactive command-line application.

## 🚀 Features

1. **Subdomain Enumeration** – Discover subdomains using a custom wordlist.
2. **Directory Enumeration** – Find accessible web directories.
3. **Service Scanner** – Identify running services and versions using Nmap.
4. **Port Scanner** – Scan TCP ports and identify open ports.
5. **Hash Cracker** – Perform wordlist-based hash matching.
6. **SSH Password Testing** – Test SSH credentials on authorized systems.
7. **Google Dorking** – Search using predefined Google Dork operators.
8. **File Transfer** – Send and receive files using SCP.

## 🛠️ Requirements

- Linux (Kali Linux / Ubuntu / Debian recommended)
- Python 3
- pip3
- Bash
- Nmap
- SSH and SCP

## 📥 Installation

**1. Clone the repository**

```bash
git clone https://github.com/YOUR_USERNAME/Raptor-X.git
```

**2. Navigate to the project directory**

```bash
cd Raptor-X
```

**3. Install system dependencies**

```bash
sudo apt update
sudo apt install python3 python3-pip python3-venv nmap openssh-client -y
```

**4. Create and activate a virtual environment**

```bash
python3 -m venv venv
source venv/bin/activate
```

**5. Install Python requirements**

```bash
pip install -r requirements.txt
```

## ▶️ Usage

Give execution permission to the script:

```bash
chmod +x raptor-x.sh
```

Run the application:

```bash
./raptor-x.sh
```

After launching, the interactive menu will appear:

```text
1. Subdomain Enumeration
2. Directory Enumeration
3. Service Scanner
4. Port Scanner
5. Hash Cracker
6. SSH Brute Forcer
7. Google Dorking
8. Upload Basic Linux Enumeration Script
```

Select your desired option and provide the requested inputs.

## 📦 Installing Requirements

If you have cloned the repository, requirements.txt is already included.

Install all dependencies using:

```bash
pip install -r requirements.txt
```

To upgrade the dependencies:

```bash
pip install --upgrade -r requirements.txt
```

## ⚠️ Disclaimer

Raptor-X is intended for educational purposes, authorized penetration testing, and security research.

- Only test systems you own or have explicit permission to assess.
- Do not use this tool for unauthorized access or malicious activities.
- The developer is not responsible for misuse of this application.

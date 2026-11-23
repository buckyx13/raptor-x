#! /bin/bash

python3 <<EOF
import pyfiglet
def banner():
    custom_fig = pyfiglet.Figlet(font='slant')
    print(custom_fig.renderText("Raptor - X"))
banner()
EOF

echo "1. subdomain enumeration"
echo "2. Directory Enumeration"
echo "3. Service Scanner"
echo "4. Port Scanner"
echo "5. Hash Cracker"
echo "6. ssh Brute Forcer"
echo "7. Google Dorking"
echo "8. upload basic linux enumuration script"
read -p "Enter the required option:" option  

if [ "$option" -eq 1 ]; then
pip3 install requests

echo -n "Enter the base domain name: "
read base_domain

echo -n "Enter the wordlist path: "
read file

python3 <<EOF
import requests

base_domain = "${base_domain}"
file = "${file}"
sub_list = open(file).read()
subdoms = sub_list.splitlines()

print("")
print("Trying subdomains")
print("")

for sub in subdoms:
    sub_domains = f"http://{sub}.{base_domain}"
    try:
        print(sub_domains)
        requests.get(sub_domains)
    except requests.ConnectionError:
        pass
    else:
        print("Valid domain: ", sub_domains)
EOF

elif [ $option -eq 2 ];  then 

echo -n "Enter the base domain name: "
read base_domain

echo -n "Enter the wordlist path: "
read file

python3 <<EOF
import requests 
import sys 

base_domain = "${base_domain}"
file = "${file}"
sub_list = open(file).read() 
directories = sub_list.splitlines()
for dir in directories:
    dir_enum = f"http://{base_domain}/{dir}" 
    r = requests.get(dir_enum)
    if r.status_code==404: 
        pass
    else:
        print("Valid directory:" ,dir_enum)
EOF

elif [ $option -eq 3 ];  then

echo -n "Enter the target hosname: "
read target_host

python3 <<EOF
import nmap
import subprocess
import sys
from tqdm import tqdm

target_host = "${target_host}"
common_ports = "21-80"  # You can expand this range as needed

# Set the verbosity level for the nmap scan
nmap_verbose_level = "-vv"  # Adjust verbosity as needed ("-v" for verbose, "-vv" for more verbose, etc.)

# Function to perform service enumeration using nmap
def enumerate_services(target_host, port_range):
    nm = nmap.PortScanner()

    # Run nmap with the specified verbosity level
    cmd = ["nmap", nmap_verbose_level, "-p", port_range, target_host]
    process = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

    # Read the output of nmap and update the progress bar
    total_ports = len(nm.all_hosts()) * len(port_range.split('-'))
    completed_ports = 0
    with tqdm(total=total_ports, unit="port") as pbar:
        while True:
            line = process.stdout.readline()
            if not line:
                break
            if "Host: " in line and "Ports:" in line:
                completed_ports += 1
                pbar.update(1)
            print(line, end='')

    process.stdout.close()

    # Perform the scan using the nmap library
    nm.scan(target_host, port_range)
    for host in nm.all_hosts():
        for proto in nm[host].all_protocols():
            lport = nm[host][proto].keys()
            for port in lport:
                service_info = nm[host][proto][port]
                service_name = service_info.get('product', 'Unknown Service')
                service_version = service_info.get('version', 'Unknown Version')
                print(f"Host: {host}, Port: {port}, Service: {service_name}, Version: {service_version}")

# Perform service enumeration with verbosity and progress bar
enumerate_services(target_host, common_ports)
EOF

elif [ $option -eq 4 ];  then
pip3 install socket

temp_python_script=$(mktemp)
cat <<EOL > $temp_python_script

import sys
import socket
from concurrent.futures import ThreadPoolExecutor

def scan_ports(ip, start_port, end_port, timeout, max_threads=10):
    open_ports = []

    print(f"Scanning ports on {ip} from {start_port} to {end_port}...\n")

    def scan_port(port):
        result = probe_port(ip, port, timeout)
        if result == 0:
            open_ports.append(port)
            print(f"Port {port} is open")

    with ThreadPoolExecutor(max_threads) as executor:
        for port in range(start_port, end_port + 1):
            sys.stdout.flush()
            executor.submit(scan_port, port)

    return open_ports

def probe_port(ip, port, timeout):
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
            sock.settimeout(timeout)
            result = sock.connect_ex((ip, port))
            return result
    except Exception as e:
        return 1

if __name__ == "__main__":
    ip = input("Enter the IP address to scan: ")
    start_port = int(input("Enter the starting port: "))
    end_port = int(input("Enter the ending port: "))
    timeout = float(input("Enter the connection timeout (e.g., 0.5): "))

    open_ports = scan_ports(ip, start_port, end_port, timeout)

    if open_ports:
        print("\nOpen Ports:")
        print(sorted(open_ports))
    else:
        print("\nNo open ports found.")

EOL
python3 $temp_python_script
rm $temp_python_script

elif [ $option -eq 5 ];  then
apt install python3-pyfiglet
pip3 install pyfiglet
pip3 install hashlib

echo -n "Enter the hash to crack: "
read user_hash

echo -n "Enter the wordlist: "
read file_location

python3 <<EOF
import hashlib

def hash_string(algorithm, input_string):
    hash_object = hashlib.new(algorithm)
    hash_object.update(input_string.encode())
    return hash_object.hexdigest()

def find_matching_words(user_hash, file_location):
    matching_words = []

    with open(file_location, 'r') as file:
        for line in file:
            words = line.split()
            for word in words:
                for algorithm in hashlib.algorithms_guaranteed:
                    if algorithm.startswith('shake_'):
                        continue
                    word_hash = hash_string(algorithm, word)
                    if user_hash == word_hash:
                        matching_words.append((word, algorithm))

    return matching_words

if __name__ == "__main__":
    user_hash = "${user_hash}"
    file_location = "${file_location}"

    matching_words = find_matching_words(user_hash, file_location)

    if matching_words:
        print(f"Matching words for hash '{user_hash}':")
        for word, algorithm in matching_words:
            print(f"Word: {word}, Algorithm: {algorithm}")
    else:
        print("No matching words found.")
EOF

elif [ $option -eq 6 ];  then
pip3 install paramiko
pip3 install os

echo -n "Enter the target: "
read target

echo -n "Enter the username: "
read username

echo -n "Enter the wordlist: "
read password_file

echo -n "Enter the port number: "
read port

python3 <<EOF
import paramiko
import sys
import os

target = "${target}"
username = "${username}"
password_file = "${password_file}"
port = "${port}"

def ssh_connect(password, code=0):
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

    try:
        ssh.connect(target, port, username=username, password=password)
    except paramiko.AuthenticationException:
        code = 1
    ssh.close()
    return code

with open(password_file, 'r') as file:
    for line in file.readlines():
        password = line.strip()

        try:
            response = ssh_connect(password)

            if response == 0:
                 print('password found: '+ password)
                 exit(0)
            elif response == 1: 
                print('no luck')
        except Exception as e:
            print(e)
        pass

input_file.close()
EOF

elif [ $option -eq 7 ];  then

temp_python_script=$(mktemp)
cat <<EOL > $temp_python_script
import requests
from bs4 import BeautifulSoup

# Function to perform a Google search and parse the results
def google_dork_search(query, num_results=10):
    search_url = f"https://www.google.com/search?q={query}&num={num_results}"

    try:
        response = requests.get(search_url, headers={"User-Agent": "Mozilla/5.0"})
        if response.status_code == 200:
            soup = BeautifulSoup(response.text, "html.parser")
            search_results = soup.find_all("a")
            for result in search_results:
                link = result.get("href")
                if link and link.startswith("/url?"):
                    # Extract and print the URLs
                    url = link.replace("/url?q=", "").split("&")[0]
                    print(url)
    except Exception as e:
        print(f"Error during Google Dork search: {e}")

# Get user input for the general search query
user_query = input("Enter a general search query (e.g., 'disney'): ")
num_results = int(input("Enter the number of results to retrieve: "))

# List of predefined Google Dork queries
queries = [
    "site:",
    "filetype:",
    "inurl:",
    "intitle:",
    "link:",
    "cache:",
    "info:",
    "related:",
]

# Display the available query options
print("Choose a Google Dork query option:")
for i, query_option in enumerate(queries, 1):
    print(f"{i}. {query_option}")

# Get the user's choice for the query option
choice = int(input("Enter the option number: "))
selected_query_option = queries[choice - 1]

# Combine the user's search query with the selected query option
full_query = f"{selected_query_option}{user_query}"

# Perform the Google Dork search
google_dork_search(full_query, num_results)
EOL
python3 $temp_python_script
rm $temp_python_script

elif [ $option -eq 8 ];  then

send_file() {
    echo "Enter the recipient's username@hostname:"
    read recipient
    echo "Enter the local file path:"
    read local_file
    echo "Enter the destination path on the remote server:"
    read remote_path

    scp "$local_file" "$recipient:$remote_path"

    if [ $? -eq 0 ]; then
        echo "File sent successfully to $recipient:$remote_path"
    else
        echo "Error: File transfer failed."
    fi
}

receive_file() {
    echo "Enter the sender's username@hostname:"
    read sender
    echo "Enter the remote file path:"
    read remote_file
    echo "Enter the local destination path:"
    read local_path

    scp "$sender:$remote_file" "$local_path"

    if [ $? -eq 0 ]; then
        echo "File received successfully from $sender:$remote_file"
    else
        echo "Error: File transfer failed."
    fi
}

echo "Select an option:"
echo "1. Send a file"
echo "2. Receive a file"
read choice

case $choice in
    1)
        send_file
        ;;
    2)
        receive_file
        ;;
    *)
        echo "Invalid option"
        ;;
esac

else  
echo "Select correct required option"  
fi

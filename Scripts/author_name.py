import subprocess

def get_full_name():
    command = 'osascript -e "long user name of (system info)"'
    process = subprocess.Popen(command, stdout=subprocess.PIPE, shell=True)
    output, _ = process.communicate()
    return output.decode().strip()

print(get_full_name())

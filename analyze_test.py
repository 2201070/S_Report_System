import subprocess

with open("output.txt", "w", encoding="utf-8") as f:
    result = subprocess.run(["flutter", "analyze"], capture_output=True, text=True)
    f.write(result.stdout)
    f.write(result.stderr)

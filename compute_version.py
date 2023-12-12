import semver
import subprocess
import argparse

p = argparse.ArgumentParser()
p.add_argument("type", type=str, choices=["major", "minor"], default="minor")
a = p.parse_args()

all_tags = subprocess.run("git tag".split(), capture_output=True, text=True)
tags = all_tags.stdout.split("\n")[:-1]
tags = ["1.2.0", "1.0.0", "2.0.0", "1.5.0", "0.10.0"]
print(tags)
tags.sort(key=lambda x: semver.Version.parse(x))
print("sorted", tags)
v = semver.Version.parse(tags[-1])
if a.type == "minor":
    print(v.bump_minor())
else:
    print(v.bump_major())

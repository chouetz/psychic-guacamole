from codeowners import CodeOwners
from collections import defaultdict
from subprocess import run


with open('.github/CODEOWNERS', 'r') as f:
    owners = CodeOwners(f.read())

run('git checkout nschweitzer/AP-2376/revive'.split())
result = run('git diff --name-only main..nschweitzer/AP-2376/revive'.split(), capture_output=True, text=True)

modified_files = result.stdout.split('\n')
modified_files = modified_files[:-1]  # last is empty

assign_map = defaultdict(list)
for file in modified_files:
    for owner in owners.of(file):
        assign_map[owner[1][1:]].append(file)  # remove the @

for team, files in assign_map.items():
    run(f'git stash push -u -- {files.join(" ")}'.split())
    run('git checkout main'.split())
    run(f'git checkout -b revive/{team}'.split())
    run('git stash pop'.split())
    run(f'git commit -am "revive/{team}"'.split())
    run('git push'.split())
    run('git checkout nschweitzer/AP-2376/revive'.split())

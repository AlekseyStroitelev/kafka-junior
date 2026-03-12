#!/bin/bash

terraform output -json instance_ips | python3 -c "
import json, sys, yaml
ips = json.load(sys.stdin)
inventory = {'all': {'hosts': {}, 'vars': {'ansible_user': 'ubuntu', 'ansible_ssh_private_key_file': '~/.ssh/id_rsa'}}}
for i, ip in enumerate(ips):
    hostname = f'kafka-server-{i+1}'
    inventory['all']['hosts'][hostname] = {'ansible_host': ip}
with open('../ansible/inventory.yml', 'w') as f:
    yaml.dump(inventory, f)
"
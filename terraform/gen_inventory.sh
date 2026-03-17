#!/bin/bash

# Получаем IP адреса Kafka серверов
terraform output -json instance_ips | python3 -c "
import json, sys, yaml

# Загружаем IP адреса Kafka серверов
ips = json.load(sys.stdin)

# Базовая структура inventory
inventory = {
    'all': {
        'hosts': {},
        'children': {
            'kafka_brokers': {
                'hosts': {}
            },
            'monitoring': {
                'hosts': {}
            }
        }
    }
}

# Добавляем Kafka серверы
for i, ip in enumerate(ips):
    hostname = f'kafka-server-{i+1}'
    inventory['all']['hosts'][hostname] = {
        'ansible_host': ip,
        'node_id': i + 1  # Добавляем node.id для Ansible
    }
    inventory['all']['children']['kafka_brokers']['hosts'][hostname] = {}

# Получаем IP адрес AKHQ сервера (если он есть)
try:
    import subprocess
    result = subprocess.run(['terraform', 'output', '-raw', 'akhq_ip'], 
                          capture_output=True, text=True, check=True)
    akhq_ip = result.stdout.strip()
    
    if akhq_ip:
        inventory['all']['hosts']['akhq-server'] = {
            'ansible_host': akhq_ip
        }
        inventory['all']['children']['monitoring']['hosts']['akhq-server'] = {}
        print(f\"✅ AKHQ сервер добавлен с IP: {akhq_ip}\", file=sys.stderr)
    else:
        print(\"⚠️  AKHQ IP пустой, пропускаем добавление\", file=sys.stderr)
except subprocess.CalledProcessError:
    print(\"⚠️  AKHQ сервер не найден в outputs Terraform\", file=sys.stderr)
except Exception as e:
    print(f\"⚠️  Ошибка при получении AKHQ IP: {e}\", file=sys.stderr)

# Сохраняем inventory файл
output_path = '../ansible/inventory.yml'
with open(output_path, 'w') as f:
    yaml.dump(inventory, f, default_flow_style=False, sort_keys=False)

print(f\"\\n✅ Inventory файл создан: {output_path}\", file=sys.stderr)
print(\"📋 Состав кластера:\", file=sys.stderr)
print(f\"   - Kafka брокеров: {len(ips)}\", file=sys.stderr)
if 'akhq-server' in inventory['all']['hosts']:
    print(f\"   - AKHQ сервер: {akhq_ip}\", file=sys.stderr)
"
# Ansible

Запускаем playbook из директории `ansible`:

`ansible-playbook -i inventory.yml kafka-playbook.yml -v`, ждем окончания процесса.

В процессе работы playbook происходит:

1. Установка зависимостей: Java.

2. Создание пользователя: Безопасный запуск от отдельного пользователя kafka.

3. Загрузка и установка: Скачивается бинарный архив Kafka с официального сайта.

4. Генерация ID: Для каждой машины генерируется уникальный node.id (1, 2, 3), а для всего кластера — один общий cluster_id.

5. Конфигурация: Шаблон server.properties.j2 копируется на каждую машину с подстановкой правильных IP-адресов и ID. `controller.quorum.voters` — формируется динамически на основе всех хостов в группе, что критически важно для KRaft.

6. Форматирование: Выполняется команда `kafka-storage.sh format`, которая инициализирует директорию с метаданными.

7. Systemd: Создается сервис для управления Kafka, чтобы она автоматически запускалась при загрузке ОС.
---

# Проверка работоспособности кластера

1. Проверка статуса сервиса на каждом сервере

`ansible all -i inventory.yml -m shell -a "sudo systemctl status kafka | grep Active" -b`

**Должны увидеть Active: active (running) на всех трех серверах.**

2. Создание тестового топика с репликацией
Подключитесь к любому серверу по SSH и выполните:

`/opt/kafka/bin/kafka-topics.sh --create --topic test-topic --bootstrap-server localhost:9092 --replication-factor 3 --partitions 3`

**Ожидаемый вывод: Created topic test-topic.**

3. Проверка описания топика
Так же на любом сервере выполняем:

`/opt/kafka/bin/kafka-topics.sh --describe --topic test-topic --bootstrap-server localhost:9092`

**Ожидаемый вывод:**

```
Topic: test-topic	PartitionCount: 3	ReplicationFactor: 3	Configs: 
	Topic: test-topic	Partition: 0	Leader: 1	Replicas: 1,2,3	Isr: 1,2,3
	Topic: test-topic	Partition: 1	Leader: 2	Replicas: 2,3,1	Isr: 2,3,1
	Topic: test-topic	Partition: 2	Leader: 3	Replicas: 3,1,2	Isr: 3,1,2
```
4. Проверка статуса кластера (метаданные)

`/opt/kafka/bin/kafka-metadata-quorum.sh --bootstrap-server localhost:9092 describe --status`

5. Тест отправки и чтения сообщений 
Отправка сообщения:

`echo "Hello Kafka" | /opt/kafka/bin/kafka-console-producer.sh --topic test-topic --bootstrap-server localhost:9092`

Чтение сообщения:

`/opt/kafka/bin/kafka-console-consumer.sh --topic test-topic --bootstrap-server localhost:9092 --from-beginning --max-messages 1`

**Должны увидеть: Hello Kafka**

---

<p align="center">
  <img src="https://github.com/AlekseyStroitelev/kafka-junior/blob/main/pictures/ansible_logo.png"/>
</p>
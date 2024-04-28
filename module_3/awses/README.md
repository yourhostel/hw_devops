# AWS Session Script

Цей скрипт дозволяє автоматизувати процес отримання сесійних облікових даних для AWS CLI за допомогою MFA.

## Вимоги

Перед використанням скрипта вам потрібно встановити `jq`, який використовується для обробки JSON відповідей від AWS CLI:

```bash
sudo apt install jq
```
Налаштування скрипта
1. Заміна MFA_SERIAL_NUMBER:
Відредагуйте скрипт, замінивши значення змінної MFA_SERIAL_NUMBER на реальний ARN вашого MFA пристрою:
```bash
MFA_SERIAL_NUMBER="arn:aws:iam::123456789012:mfa/your-device"
```
2. Зробіть файл виконуваним:
```bash
chmod +x aws_session.sh
```
3. Використання скрипта з будь-якого місця:
```bash
sudo mv aws_session.sh /usr/local/bin/awses && chmod +x /usr/local/bin/awses
```
4. Використання скрипта
![2024-04-28.jpg](screenshots%2F2024-04-28.jpg)
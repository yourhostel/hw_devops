#!/usr/bin/env bash

# Перевіряємо, чи встановлені змінні середовища для сесії
if [[ -n "$AWS_ACCESS_KEY_ID" && -n "$AWS_SECRET_ACCESS_KEY" && -n "$AWS_SESSION_TOKEN" ]]; then
    echo "Виявлено активну сесію AWS CLI."
    echo "1 - завершити цю сесію та розпочати нову"
    echo "2 - завершити цю сесію"
    read -p "Введіть ваш вибір: " RESPONSE
    case $RESPONSE in
        1)
            unset AWS_ACCESS_KEY_ID
            unset AWS_SECRET_ACCESS_KEY
            unset AWS_SESSION_TOKEN
            echo "Активну сесію було завершено. Введіть MFA код з Вашого пристрою та натисніть Enter:"
            ;;
        2)
            unset AWS_ACCESS_KEY_ID
            unset AWS_SECRET_ACCESS_KEY
            unset AWS_SESSION_TOKEN
            echo "Активну сесію було завершено."
            exit 0
            ;;
        *)
            echo "Невідома опція: $RESPONSE"
            exit 1
            ;;
    esac
fi

# Запитуємо MFA код для створення нової сесії
read -p "Введіть MFA код з Вашого пристрою та натисніть Enter: " MFA_CODE
MFA_SERIAL_NUMBER="Вкажіть ваш ARN для пристрою MFA"
OUTPUT=$(aws sts get-session-token --serial-number $MFA_SERIAL_NUMBER --token-code $MFA_CODE 2>&1)

if echo $OUTPUT | grep -q 'Credentials'; then
    ACCESS_KEY=$(echo $OUTPUT | jq -r '.Credentials.AccessKeyId')
    SECRET_KEY=$(echo $OUTPUT | jq -r '.Credentials.SecretAccessKey')
    SESSION_TOKEN=$(echo $OUTPUT | jq -r '.Credentials.SessionToken')

    # Встановлюємо нові змінні середовища
    export AWS_ACCESS_KEY_ID=$ACCESS_KEY
    export AWS_SECRET_ACCESS_KEY=$SECRET_KEY
    export AWS_SESSION_TOKEN=$SESSION_TOKEN

    echo "Сесія встановлена успішно!"
    # Додаткова перевірка встановленої сесії
    aws sts get-caller-identity
else
    echo "Не вдалося отримати облікові дані. Будь ласка, перевірте ваш MFA код і спробуйте знову."
    echo "Помилка:"
    echo $OUTPUT
fi


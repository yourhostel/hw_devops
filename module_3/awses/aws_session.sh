#!/usr/bin/env bash

# Перевірка поточних облікових даних AWS
if [ -n "$AWS_ACCESS_KEY_ID" ]; then
    echo "Виявлено активну сесію AWS CLI."
    echo "Ви хочете завершити цю сесію та розпочати нову? (yes/no)"
    read RESPONSE
    if [ "$RESPONSE" == "yes" ]; then
        unset AWS_ACCESS_KEY_ID
        unset AWS_SECRET_ACCESS_KEY
        unset AWS_SESSION_TOKEN
        echo "Активну сесію було завершено."
    else
        echo "Продовження використання існуючої сесії."
        exit 0
    fi
fi

echo "Введіть MFA код з Вашого пристрою та натисніть Enter:"
read MFA_CODE

MFA_SERIAL_NUMBER="arn:aws:iam::590184137042:mfa/redmi1"
OUTPUT=$(aws sts get-session-token --serial-number $MFA_SERIAL_NUMBER --token-code $MFA_CODE 2>&1)

if echo $OUTPUT | grep -q 'Credentials'; then
    ACCESS_KEY=$(echo $OUTPUT | jq -r '.Credentials.AccessKeyId')
    SECRET_KEY=$(echo $OUTPUT | jq -r '.Credentials.SecretAccessKey')
    SESSION_TOKEN=$(echo $OUTPUT | jq -r '.Credentials.SessionToken')

    export AWS_ACCESS_KEY_ID=$ACCESS_KEY
    export AWS_SECRET_ACCESS_KEY=$SECRET_KEY
    export AWS_SESSION_TOKEN=$SESSION_TOKEN

    echo "Сесія встановлена успішно!"
    # Додаткова перевірка встановлення сесії
    aws sts get-caller-identity
else
    echo "Не вдалося отримати облікові дані. Будь ласка, перевірте ваш MFA код і спробуйте знову."
    echo "Помилка:"
    echo $OUTPUT
fi
# homework-20240707/start_postgres.sh

echo "Waiting for postgres_password..."
while [ ! -f /vault/secrets/postgres_password ]; do
  sleep 1
done
export POSTGRES_PASSWORD=$(cat /vault/secrets/postgres_password)
echo "Found postgres_password, starting PostgreSQL..."
exec docker-entrypoint.sh postgres
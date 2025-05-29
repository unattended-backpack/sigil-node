# In the future we can put a snapshot download here

# Common variables.
INITIALIZED_FLAG=/shared/initialized.txt
JWT_PATH=/shared/jwt.txt

echo "Creating JWT..."
mkdir -p $(dirname $JWT_PATH)
openssl rand -hex 32 >$JWT_PATH

# mark as initialized
touch $INITIALIZED_FLAG

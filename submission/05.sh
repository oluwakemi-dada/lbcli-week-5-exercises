# Create a CSV script that would lock funds until one hundred and fifty blocks had passed
# publicKey=02e3af28965693b9ce1228f9d468149b831d6a0540b25e8a9900f71372c11fb277

BLOCKS=150

PUBLIC_KEY=02e3af28965693b9ce1228f9d468149b831d6a0540b25e8a9900f71372c11fb277

BLOCKS_HEX=$(printf '%02x' "$BLOCKS")

# Append a sign-padding byte because the high bit is set.
BLOCKS_HEX="${BLOCKS_HEX}00"

# Calculate HASH160 of the public key.
PUBKEY_HASH=$(printf '%s' "$PUBLIC_KEY" \
  | xxd -r -p \
  | openssl dgst -sha256 -binary \
  | openssl dgst -ripemd160 \
  | awk '{print $2}')

# Construct the CSV script with a P2PKH spending condition.
CSV_SCRIPT="02${BLOCKS_HEX}b27576a914${PUBKEY_HASH}88ac"

echo "$CSV_SCRIPT"
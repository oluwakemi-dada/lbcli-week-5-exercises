# Create a CLTV script with a timestamp of 1495584032 and public key below:
# publicKey=02e3af28965693b9ce1228f9d468149b831d6a0540b25e8a9900f71372c11fb277

TIMESTAMP=1495584032

PUBLIC_KEY=02e3af28965693b9ce1228f9d468149b831d6a0540b25e8a9900f71372c11fb277

TIMESTAMP_HEX=$(printf '%08x' "$TIMESTAMP" | sed 's/../& /g' | awk '{for(i=NF;i>0;i--) printf "%s", $i}')

# Calculate HASH160 of the supplied public key.
PUBKEY_HASH=$(printf '%s' "$PUBLIC_KEY" \
  | xxd -r -p \
  | openssl dgst -sha256 -binary \
  | openssl dgst -ripemd160 \
  | awk '{print $2}')

# Construct the CLTV script using the P2PKH spending condition.
CLTV_SCRIPT="04${TIMESTAMP_HEX}b17576a914${PUBKEY_HASH}88ac"

echo "$CLTV_SCRIPT"
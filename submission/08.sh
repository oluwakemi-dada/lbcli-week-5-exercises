# Create a time-based CSV script that would lock funds for 6 months (using 30-day months)
# Time-based CSV uses 512-second units with the type flag (bit 22) set
# publicKey=02e3af28965693b9ce1228f9d468149b831d6a0540b25e8a9900f71372c11fb277


#!/bin/bash

# Set the lock period to six 30-day months.
MONTHS=6
DAYS_PER_MONTH=30
SECONDS_PER_DAY=86400
CSV_TIME_UNIT=512

# Convert the lock period into 512-second units.
TOTAL_SECONDS=$((MONTHS * DAYS_PER_MONTH * SECONDS_PER_DAY))
TIME_UNITS=$((TOTAL_SECONDS / CSV_TIME_UNIT))

# Set the time-based CSV type flag (bit 22).
TYPE_FLAG=$((1 << 22))
CSV_VALUE=$((TIME_UNITS + TYPE_FLAG))

# Convert the CSV value to hexadecimal.
CSV_HEX=$(printf '%x' "$CSV_VALUE")

# Reverse the bytes for little-endian encoding.
CSV_HEX=$(echo "$CSV_HEX" | sed 's/../& /g' | awk '{for(i=NF;i>0;i--) printf "%s", $i}')

# Calculate HASH160 of the supplied public key.
PUBLIC_KEY="02e3af28965693b9ce1228f9d468149b831d6a0540b25e8a9900f71372c11fb277"

PUBKEY_HASH=$(printf '%s' "$PUBLIC_KEY" \
  | xxd -r -p \
  | openssl dgst -sha256 -binary \
  | openssl dgst -ripemd160 \
  | awk '{print $2}')

# Calculate the byte length of the CSV value.
PUSH_LENGTH=$(printf '%02x' "$(( ${#CSV_HEX} / 2 ))")

# Construct the time-based CSV script.
CSV_SCRIPT="${PUSH_LENGTH}${CSV_HEX}b27576a914${PUBKEY_HASH}88ac"

echo "$CSV_SCRIPT"
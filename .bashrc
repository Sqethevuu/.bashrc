# Get my IP addresses
myip(){
  echo "=== Local IPs ==="
  if command -v ifconfig >/dev/null; then
      ifconfig 2>dev/null \
      | awk '
          /^[a-zA-Z0-9]/ { iface=$1 }
          /inet / { print iface ": " $2 }
      ' || echo "No local IP found"
  else
      echo "ifconfig not found"
  fi

  echo
  echo "=== Public IP ==="
  if command -v curl >/dev/null; then
      curl -s --max-time 3 ifconfig.me || echo "Timeout/error getting public IP"
  elif command -v wget >/dev/null; then
      wget -q0- ifconfig.me
  else
      echo "No curl or wget installed"
  fi
  echo
}

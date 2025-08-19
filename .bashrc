# Get my IP addresses
myip(){
  echo "=== Local IPs ==="
  if command -v ifconfig >/dev/null; then
      ifconfig 2>/dev/null \
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
      curl -s --max-time 3 https://api64.ipify.org || echo "Timeout/error getting public IP"
  elif command -v wget >/dev/null; then
      wget -qO- https://api64.ipify.org
  else
      echo "No curl or wget installed"
  fi
  echo
}

# Make a directory and move into it
mkcd() {
  show_help() {
    cat <<EOF
Usage: mkcd [OPTIONS] DIR...

Create one or more directories and optionally navigate into one.

Options:
  -h, --help, -?   Show this help message and exit

Examples:
  mkcd projects            # create "projects" and enter it
  mkcd dir1 dir2 dir3      # create three dirs, then choose which one to enter
EOF
  }

  # Check for flags
  case "$1" in
    -h|--help|-\?)
      show_help
      return 0
      ;;
  esac

  # Ensure at least one directory was given
  if [ "$#" -eq 0 ]; then
    echo "Error: Please provide at least one directory name."
    echo "Try 'mkcd -h' for usage."
    return 1
  fi

  # Create directories
  created_dirs=()
  for dir in "$@"; do
    mkdir -p "$dir"
    if [ $? -eq 0 ]; then
      created_dirs+=("$dir")
    else
      echo "Error: Failed to create directory '$dir'."
    fi
  done

  # If only one dir, cd into it
  if [ "${#created_dirs[@]}" -eq 1 ]; then
    cd "${created_dirs[0]}" || return 1
    echo "Changed into '${created_dirs[0]}'."
  else
    echo "Directories created:"
    for i in "${!created_dirs[@]}"; do
      echo "  [$i] ${created_dirs[$i]}"
    done

    read -p "Enter the number of the directory to navigate into: " choice
    if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 0 ] && [ "$choice" -lt "${#created_dirs[@]}" ]; then
      cd "${created_dirs[$choice]}" || return 1
      echo "Changed into '${created_dirs[$choice]}'."
    else
      echo "Invalid selection. Staying in current directory."
    fi
  fi
}

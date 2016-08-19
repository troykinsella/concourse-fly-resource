FLY=/usr/local/bin/fly

fetch_fly() {
  local url="$1"
  local username="$2"
  local password="$3"
  test -x $FLY || {
    echo "Fetching fly...";
    curl -SsL -u "$username:$password" "$url/api/v1/cli?arch=amd64&platform=linux" > $FLY;
    chmod +x $FLY;
  }
}

login() {
  local url="$1"
  local username="$2"
  local password="$3"
  local tried="$4"

  set +e
  local out=$($FLY login -t main -c "$url" --username="$username" --password="$password" 2>&1)
  set -e

  # This sucks
  echo "$out" | grep "fly -t main sync" > /dev/null && {
    test -n "$tried" && return 1;
    fetch_fly;
    login "$url" "$username" "$password" yes;
  }
}

init_fly() {
  local url="$1"
  local username="$2"
  local password="$3"

  fetch_fly "$url"
  login "$url" "$username" "$password"
}

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
  local team="$4"
  local tried="$5"

  set +e
  local out=$($FLY login -t main -n "$team" -c "$url" --username="$username" --password="$password" 2>&1)

  # This sucks
  echo "$out" | grep "fly -t main sync" > /dev/null && {
    test -n "$tried" && return 1;
    fetch_fly;
    login "$url" "$username" "$password" "$team" yes;
  }
  set -e
}

init_fly() {
  local url="$1"
  local username="$2"
  local password="$3"
  local team="$4"

  fetch_fly "$url"
  login "$url" "$username" "$password" "$team"
}

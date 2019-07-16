FLY=/usr/local/bin/fly

fetch_fly() {
  local url=$1
  local insecure=$4

  local insecure_arg=""
  test "$insecure" = "true" && insecure_arg="--insecure"

  if ! [ -x $FLY ]; then
    echo "Fetching fly..."
    curl -SsL $insecure_arg "$url/api/v1/cli?arch=amd64&platform=linux" -o $FLY
    chmod +x $FLY
  fi
}

login() {
  local url=$1
  local username=$2
  local password=$3
  local team=$4
  local insecure=$5
  local tried=$6
  local target=$7

  local insecure_arg=""
  test "$insecure" = "true" && insecure_arg="--insecure"

  echo "Logging in..."
  local out=$($FLY login -t $target $insecure_arg -c $url -n $team --username=$username --password=$password 2>&1)

  # This sucks
  if echo "$out" | grep "fly -t $target sync" > /dev/null; then
    test -n "$tried" && return 1
    fetch_fly $url $insecure
    login $url $username $password $team $insecure yes
  fi
}

init_fly() {
  local url=$1
  local username=$2
  local password=$3
  local team=$4
  local insecure=$5

  fetch_fly $url $username $password $insecure
  login $url $username $password $team $insecure
}

FLY=/usr/local/bin/fly

fetch_fly() {
  local url=$1
  local username=$2
  local password=$3
  local insecure=$4

  local insecure_arg=""
  test "$insecure" = "true" && insecure_arg="--insecure"

  test -x $FLY || {
    echo "Fetching fly..."
    curl -SsL $insecure_arg -u "$username:$password" "$url/api/v1/cli?arch=amd64&platform=linux" -o $FLY
    chmod +x $FLY
  }
}

login() {
  local url=$1
  local username=$2
  local password=$3
  local team=${4:-main}
  local insecure=$5
  local tried=$6

  local insecure_arg=""
  test "$insecure" = "true" && insecure_arg="--insecure"

  echo "Logging in..."
  (
    set +e
    local out=$($FLY login -t main $insecure_arg -c $url -n $team --username=$username --password=$password 2>&1)

    # This sucks
    echo "$out" | grep "fly -t main sync" > /dev/null && {
      test -n "$tried" && return 1
      fetch_fly $url $username $password $insecure
      login $url $username $password $team $insecure yes
    }
  )
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

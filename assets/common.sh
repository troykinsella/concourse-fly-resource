FLY=/usr/local/bin/fly

fetch_fly() {
  local url=$1
  local insecure=$2

  local insecure_arg=""
  test "$insecure" = "true" && insecure_arg="--insecure"

  if ! [ -x $FLY ]; then
    echo "Fetching fly..."

    COOKIE_FILE="${TMP_DIR}/cookie.txt"
    echo "Getting FORM token..."
    FORM_TOKEN="$(curl $insecure_arg -b ${COOKIE_FILE} -c ${COOKIE_FILE} -s -L "${url}/sky/login" | \
         grep -i '?req=' | cut -d '"' -f 2 | tail -n1)"
    if [ -z "${FORM_TOKEN}" ];then
      echo "Could not retrieve FORM token"
      exit 1
    fi

    echo "Getting OAUTH token..."
    curl -Ss $insecure_arg -o /dev/null -s -b ${COOKIE_FILE} -c ${COOKIE_FILE} -L --data-urlencode "login=${username}" \
        --data-urlencode "password=${password}" "${url}${FORM_TOKEN}"
    OAUTH_TOKEN=$(cat ${COOKIE_FILE} | grep 'skymarshal_auth' | grep -o 'Bearer .*$' | tr -d '"')
    if [ -z "$OAUTH_TOKEN" ];then
      echo "Could not retrieve OAUTH token"
      exit 1
    fi

    curl -SsL $insecure_arg -H "Authorization: $OAUTH_TOKEN" "$url/api/v1/cli?arch=amd64&platform=linux" -o $FLY
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
  local target=main

  local insecure_arg=""
  test "$insecure" = "true" && insecure_arg="--insecure"

  echo "Logging in..."
  local out=$($FLY login -t "$target" $insecure_arg -c "$url" -n "$team" "--username=$username" "--password=$password" 2>&1)

  # This sucks
  if echo "$out" | grep "fly -t $target sync" > /dev/null; then
    test -n "$tried" && return 1
    fetch_fly "$url" "$insecure"
    login "$url" "$username" "$password" "$team" "$insecure" "$target" yes
  fi
}

init_fly() {
  local url="$1"
  local username="$2"
  local password="$3"
  local team="$4"
  local insecure="$5"
  local target="$6"

  fetch_fly "$url" "$insecure"
  login "$url" "$username" "$password" "$team" "$insecure" "$target"
}

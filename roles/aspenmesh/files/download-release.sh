#!/bin/bash

set -eEo pipefail

function check-cmd {
  CMD=$1

  command -v "$CMD" >/dev/null 2>&1 || {
    echo >&2 "Could not find $CMD. Please install it."
    exit 1
  }
}

check-cmd curl
check-cmd jq
check-cmd base64

if [ -z "$ASPEN_MESH_USERNAME" ]; then
  echo -n "Enter your Aspen Mesh username: "
  read -r ASPEN_MESH_USERNAME
fi

if [ -z "$ASPEN_MESH_PASSWORD" ]; then
  stty -echo
  echo -n "Enter your Aspen Mesh password: "
  read -r ASPEN_MESH_PASSWORD
  stty echo
  echo
fi

if ! COGNITO_OUT=$(curl --request POST https://cognito-idp.us-east-1.amazonaws.com/ \
    --silent --fail \
    --header "X-Amz-Target: AWSCognitoIdentityProviderService.InitiateAuth" \
    --header "Content-Type: application/x-amz-json-1.1" \
    --data '{
      "ClientMetadata": {},
      "AuthParameters": {
        "USERNAME": "'"$ASPEN_MESH_USERNAME"'",
        "PASSWORD": "'"$ASPEN_MESH_PASSWORD"'"
      },
      "AuthFlow": "USER_PASSWORD_AUTH",
      "ClientId": "75pv0l4jijmff7qefnhtfg66s2"
    }'); then
  echo >&2 "Failed to log in to Aspen Mesh. Check your username and password."
  exit 1
fi

BASE64_OPTS=""
if [ "$(uname)" == "Linux" ]; then
  BASE64_OPTS="--wrap=0"
fi
TOKEN=$(echo "$COGNITO_OUT" |
  jq -c ".AuthenticationResult | {access: .AccessToken, id: .IdToken}" - |
  base64 $BASE64_OPTS
)

if [ -z "$ASPEN_MESH_VERSION" ]; then
  echo -n "Enter the version of the Aspen Mesh release to download (e.g.: 1.4.3-am2): "
  read -r ASPEN_MESH_VERSION
fi

FILE="aspenmesh-$ASPEN_MESH_VERSION"
case $(uname | tr "[:upper:]" "[:lower:]") in
  linux*)
    FILE="$FILE-linux.tar.gz"
    ;;
  darwin*)
    FILE="$FILE-osx.tar.gz"
    ;;
  msys*)
    FILE="$FILE-win.zip"
    ;;
  *)
    echo >&2 "Operating system not recognized."
    exit 1
    ;;
esac

curl --fail --header "Authorization: Bearer $TOKEN" --output "$FILE" \
  "https://my.aspenmesh.io/client/release/$ASPEN_MESH_VERSION/$FILE"

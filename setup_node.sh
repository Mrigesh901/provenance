#!/bin/bash

# Usage: ./setup_node.sh  -p pass -u sahil --zeeve-user zsahil --zeeve-pass zpass

[[ $(id -u) = '0' ]] || {
    echo "[+] Run The Script From Root"
    exit
}

GETOPT=$(getopt -o p:u: -l password:,username:,zeeve-user:,zeeve-pass:,binary-user:,binary-pass:, -- "$@")
eval set -- "$GETOPT"

set -o allexport
source .environment
source .path
set +o allexport

while true; do
    case "$1" in
    -u | --username)
        username="$2"
        shift 2
        ;;
    -p | --password)
        password="$2"
        shift 2
        ;;
    --zeeve-user)
        z_username="$2"
        shift 2
        ;;
    --zeeve-pass)
        z_password="$2"
        shift 2
        ;;
    --)
        shift
        break
        ;;
    *)
        echo "Unexpected option $1"
        exit 1
        ;;
    esac
done

[[ ${username} != "" ]] || {
    echo "Error! --username is mandatory"
    exit 1
}
[[ ${password} != "" ]] || {
    echo "Error! --password is mandatory"
    exit 1
}
[[ ${z_username} != "" ]] || {
    echo "Error! --zeeve-user is mandatory"
    exit 1
}
[[ ${z_password} != "" ]] || {
    echo "Error! --zeeve-pass is mandatory"
    exit 1
}
export password
export username
export z_username
export z_password
export scripts_path=$PWD
export provenance_job=$PWD/jobs/provenance
# nginx_job=$PWD/jobs/proxy

# # Setup Proxy
# echo
# echo "--------------------------------------------"
# echo "  ***** Setting Proxy *****  "
# echo
# bash jobs/proxy/setup_proxy.sh -d $domain -p $para_rpc_port /rpc -p $para_prom_port /prom -p $para_ws_port /ws -c $ssl_cert -k $ssl_key -n myserver.conf -a $username $password -a $z_username $z_password
# echo
# echo "  ***** Proxy Setup Complete *****  "
# echo "--------------------------------------------"
# echo

# Setup Provenance
echo
echo "--------------------------------------------"
echo "  ***** Starting provenance Provisioning *****  "
echo
bash ${provenance_job}/setup_provenance.sh
echo
echo "  ***** Provenance Provision Complete *****  "
echo "--------------------------------------------"
echo

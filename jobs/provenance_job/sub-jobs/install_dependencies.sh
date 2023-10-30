#! /bin/bash

# Install required packages
echo "=== Installing Dependencies ==="
echo
sudo apt update -y
sudo apt install pkg-config build-essential libssl-dev curl jq git libleveldb-dev -y
sudo apt-get install manpages-dev -y

#install go1.20
function go_setup {
    # Create GOHOME and the required directories
    if [ ! -d /usr/local/go ]; then 
        cd $PROVENANCE_DIR
        sudo wget https://go.dev/dl/go1.20.6.linux-amd64.tar.gz
        sudo tar -C /usr/local -xvf go1.20.6.linux-amd64.tar.gz 

    fi
    grep -q -F 'export PATH=$PATH:/usr/local/go/bin' $HOME/.bashrc || echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee -a $HOME/.bashrc
    source $HOME/.bashrc

    echo
    echo "...... Go Installed......."
}
configure_firewall () {
    apt-get update
    apt-get install ufw
    ufw allow 22
    ufw allow 80 
    ufw allow 443
    ufw allow 26656
    ufw enable
}

go_setup
configure_firewall

[[ $? -eq 0 ]] && echo "=== Dependencies successfully installed ===" || ( echo "Error in Installing Deps......" && exit 1 )

echo

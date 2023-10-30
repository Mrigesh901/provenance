#!/bin/bash
set -x

install_provenance () {
    echo "==Installing Provenance binary=="

export PIO_HOME=$PROVENANCE_DIR/.provenanced
cd $PROVENANCE_DIR
git clone $provenance_binary
cd provenance
git checkout tags/$binary_version -b $binary_version
echo "==Building Binary=="
make clean
make install
provenanced version --long
cp $PROVENANCE_BINARY $PROVENANCE_DIR
}

initialize_testnet_provenance () {
    export PIO_HOME=$PROVENANCE_DIR/.provenanced
    provenanced -t init $moniker --chain-id pio-testnet-1
    rm -r $PROVENANCE_DIR/.provenanced/data
    curl https://raw.githubusercontent.com/provenance-io/testnet/main/pio-testnet-1/genesis.json> genesis.json
    mv genesis.json $PIO_HOME/config
}

initialize_mainnet_provenance () {
    export PIO_HOME=$PROVENANCE_DIR/.provenanced
    provenanced init ${moniker} --chain-id pio-mainnet-1
    curl https://raw.githubusercontent.com/provenance-io/mainnet/main/pio-mainnet-1/genesis.json> genesis.json
    mv genesis.json $PIO_HOME/config
}

install_provenance
if [[ $network == 'mainnet' ]]; then
    initialize_mainnet_provenance
elif [[ $network == 'testnet' ]]; then
    initialize_testnet_provenance
fi

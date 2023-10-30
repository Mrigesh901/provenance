#! /bin/bash

#Download snapshot data
function download_snapshot_data() {
    echo "***** Downloading snapshot data *****"
    local snapshot_url="$testnet_snap"
    isDownloaded=0
    mkdir -p $LOG_DIR

    [[ $network == 'testnet' ]] || {
        snapshot_url="$mainnet_snap"
    }

    while [ "$isDownloaded" -ne 1 ]; do
        cd ${PROVENANCE_DIR}
        wget -q -O - ${snapshot_url} | tar -xzf -
        if  [ $? -eq 0 ] ; then
            echo "File Downloaded"
            isDownloaded=$(($isDownloaded + 1))
        else
            echo "File not downloaded, going to retry."
        fi
        sleep 5
    done
    
}

download_snapshot_data
mv data ${data_dir}
rm *.tar.gz
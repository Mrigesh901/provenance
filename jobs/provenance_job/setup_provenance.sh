#! /bin/bash

jobs=${provenance_job}/sub-jobs


if [ -f ./.environment ]; then
    echo "===== Installing Dependencies ====="
    echo
    bash ${jobs}/install_dependencies.sh

    echo "===== Installing Binaries ====="
    echo
    bash ${jobs}/install_binaries.sh
    
    echo "===== Add user and give permissions ====="
    echo
    bash ${jobs}/add_user.sh

    echo "===== Creating Service Files ====="
    echo
    bash ${jobs}/create_services.sh

    #start provenance service
    systemctl start provenanced

    # [[ ${enable_validator} == "0" ]] || bash ${jobs}/validator_setup.sh
else
    echo ".environment file not found. Cannot proceed ..."
    echo
fi


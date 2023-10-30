#!/bin/bash
passed_arg=$1
create_provenanced_service () {
    local exec_command=$1

    echo "
    [Unit]
        Description=Provenance Daemon
        #After=network.target
        StartLimitInterval=350
        StartLimitBurst=10

    [Service]
        Type=simple
        User=${script_user}
        ExecStart=${exec_command}
        Restart=on-abort
        RestartSec=30
        LimitNOFILE=1048576
        
    [Install]
        WantedBy=multi-user.target
" | sudo tee /etc/systemd/system/provenanced.service

echo "System service for provenance created..."

}


function create_provenance_exec_command() {
    if [[ $network == 'mainnet' ]]; then
        cmd="${PROVENANCE_BINARY} start --home ${PROVENANCE_DIR}/.provenanced --p2p.seeds ${testnet_seeds} --x-crisis-skip-assert-invariants"
    elif [[ $network == 'testnet' ]]; then
        cmd="${PROVENANCE_BINARY} start --testnet --home ${PROVENANCE_DIR}/.provenanced --p2p.seeds ${mainnet_seeds} --x-crisis-skip-assert-invariants"
    fi

  local start_provenance=${cmd}
  echo ${start_provenance}
} 

# Enable services
function enable_services() {
  sudo systemctl daemon-reload
  sudo systemctl enable provenanced
}

provenance_exec_command=$(create_provenance_exec_command)

create_provenance_service "${provenance_exec_command}"

enable_services

echo "=== Services successfully created ==="
echo

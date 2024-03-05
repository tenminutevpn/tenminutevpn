#!/bin/bash
if [[ ! -f "{{ wireguard_server_privatekey }}" ]]; then
    wg genkey | tee "{{ wireguard_server_privatekey }}" | wg pubkey | tee "{{ wireguard_server_publickey }}"
    chmod 600 "{{ wireguard_server_privatekey }}"
fi

if [[ ! -f "{{ wireguard_client_privatekey }}" ]]; then
    wg genkey | tee "{{ wireguard_client_privatekey }}" | wg pubkey | tee "{{ wireguard_client_publickey }}"
    chmod 600 "{{ wireguard_client_privatekey }}"
fi

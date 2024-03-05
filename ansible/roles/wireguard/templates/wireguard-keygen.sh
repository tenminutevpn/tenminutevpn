#!/bin/bash
if [[ -f "{{ wireguard_privatekey }}" ]]; then
    exit 0
fi

wg genkey | tee "{{ wireguard_privatekey }}" | wg pubkey | tee "{{ wireguard_publickey }}"

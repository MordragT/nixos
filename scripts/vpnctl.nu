#!/usr/bin/env -S nix shell nixpkgs#nushell nixpkgs#openconnect nixpkgs#wireguard-tools --command nu

export def fh-aachen [] {
    let $response = openconnect --authenticate --useragent=AnyConnect vpn.fh-aachen.de
    let $start = $response | str index-of "COOKIE"
    let $response = ($"[response]\n($response | str substring $start..)" | from ini).response
    sudo openconnect --servercert $response.FINGERPRINT --cookie $response.COOKIE $response.CONNECT_URL
}

export def down [] {
    sudo nmcli connection delete wg-0
}

export def up [id] {
    let $cacert = "/home/tom/Desktop/Mordrag/nixos/secrets/pia/ca.rsa.4096.crt"

    let $servers = (http get https://serverlist.piaservers.net/vpninfo/servers/v4 | lines).0 | from json
    let $record = $servers.regions | where {|region| $region.id | str starts-with $id}

    if ($record | is-empty) {
        return $"Fatal: No record found for region: ($id)"
    }

    let $server = {
        meta: $record.servers.meta.0.0
        wg: $record.servers.wg.0.0
    }
    echo $server.meta

    let $user_pass = sudo cat /var/secrets/pia
    let $response = (curl -s -u $user_pass
        --connect-to $"($server.meta.cn)::($server.meta.ip)"
        --cacert $cacert
        $"https://($server.meta.cn)/authv3/generateToken") | from json
    let $token = if $response.status == "OK" {
        $response.token
    } else {
        return "Fatal: Could not retrieve token"
    }
    echo $token

    let $private = (wg genkey)
    let $public = $private | wg pubkey

    let $response = (curl -s -G
        --connect-to $"($server.wg.cn)::($server.wg.ip):"
        --cacert $cacert
        --data-urlencode $"pt=($token)"
        --data-urlencode $"pubkey=($public)"
        $"https://($server.wg.cn):1337/addKey") | from json
    let $config = if $response.status == "OK" {
        $"
        [Interface]
        Address = ($response.peer_ip)
        PrivateKey = ($private)
        DNS = ($response.dns_servers.0)
        [Peer]
        PersistentKeepalive = 25
        PublicKey = ($response.server_key)
        AllowedIPs = 0.0.0.0/0
        Endpoint = ($server.wg.ip):($response.server_port)
        "
    } else {
        return "Fatal: Could not connect to wg server"
    }

    let $path = $"/tmp/wg-0.conf"
    echo $path

    ($config | save -f $path)
    sudo nmcli connection import type wireguard file $path
}
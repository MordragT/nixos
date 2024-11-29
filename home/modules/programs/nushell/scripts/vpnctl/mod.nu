#!/usr/bin/env -S nix shell nixpkgs#nushell nixpkgs#openconnect nixpkgs#wireguard-tools --command nu

export def fh-aachen [] {
    let response = openconnect --authenticate --useragent=AnyConnect vpn.fh-aachen.de
    let start = $response | str index-of "COOKIE"
    let response = ($"[response]\n($response | str substring $start..)" | from ini).response
    sudo openconnect --servercert $response.FINGERPRINT --cookie $response.COOKIE $response.CONNECT_URL
}

export def down [] {
    sudo nmcli connection delete wg-0
}

export def up [id] {
    let servers = (http get https://serverlist.piaservers.net/vpninfo/servers/v6 | lines).0 | from json
    let regions = $servers.regions
    let server = find-by-id $regions $id
    print ($server | table --expand)
    enable $server
}

export def "up best" [--count = 1] {
    let servers = (http get https://serverlist.piaservers.net/vpninfo/servers/v6 | lines).0 | from json
    let regions = $servers.regions
    let server = find-best $regions $count
    print ($server | table --expand)
    enable $server
}

export def best [--count = 1] {
    let servers = (http get https://serverlist.piaservers.net/vpninfo/servers/v6 | lines).0 | from json
    let regions = $servers.regions
    let server = find-best $regions $count
    print ($server | table --expand)
}

def ping-time [ip, count] {
    let ping_table = ping -c $count $ip | lines | skip 1 | parse "{bytes} bytes from {ip}: icmp_seq={id} ttl={ttl} time={time} ms"
    let time = (
        $ping_table
        | get time
        | reduce --fold 0 { |it, acc| ($it | into int) + $acc }
        | into float
    ) / $count

    return $time
}

def find-by-id [regions, id] {
    let filtered = $regions | where {|region| $region.id | str starts-with $id}

    if ($filtered | is-empty) {
        return $"Fatal: No record found for region: ($id)"
    }

    return (find-best $filtered 5)
}

def find-best [regions, count] {
    let best = (
        $regions
        | par-each { |region|
            let time = ping-time $region.servers.wg.0.ip $count

            {
                id: $region.id
                meta: $region.servers.meta.0
                wg: $region.servers.wg.0
                time: $time
            }
        }
        | sort-by time
        | first
    )
    return $best
}

def enable [server] {
    # TODO FILE_PWD is really weird why do I have to do this ??
    let cacert = $env.CERTIFICATES | path join ca.rsa.4096.crt

    let user_pass = sudo cat /var/secrets/pia
    let response = (curl -s -u $user_pass
        --connect-to $"($server.meta.cn)::($server.meta.ip)"
        --cacert $cacert
        $"https://($server.meta.cn)/authv3/generateToken") | from json    
    let token = if $response.status == "OK" {
        $response.token
    } else {
        return "Fatal: Could not retrieve token"
    }
    echo $token

    let private = (wg genkey)
    let public = $private | wg pubkey

    let response = (curl -s -G
        --connect-to $"($server.wg.cn)::($server.wg.ip):"
        --cacert $cacert
        --data-urlencode $"pt=($token)"
        --data-urlencode $"pubkey=($public)"
        $"https://($server.wg.cn):1337/addKey") | from json
    let config = if $response.status == "OK" {
        $"
        [Interface]
        Address = ($response.peer_ip)
        PrivateKey = ($private)
        DNS = ($response.dns_servers.0)
        MTU = 1350
        [Peer]
        PersistentKeepalive = 25
        PublicKey = ($response.server_key)
        AllowedIPs = 0.0.0.0/0
        Endpoint = ($server.wg.ip):($response.server_port)
        "
    } else {
        return "Fatal: Could not connect to wg server"
    }

    let path = $"/tmp/wg-0.conf"
    echo $path

    ($config | save -f $path)
    sudo nmcli connection import type wireguard file $path
}
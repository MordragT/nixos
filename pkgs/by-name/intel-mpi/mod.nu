#!/usr/bin/env -S nix shell nixpkgs#nushell --command nu

export def main [] {
    const file = path self ./default.lock

    const major = "2021.17"
    const version = "2021.17.0-376"

    const packages = [
        $"mpi-($version)"
        $"mpi-devel-($version)"
        $"runtime-mpi-($version)"
    ]
    let index = http get https://apt.repos.intel.com/oneapi/dists/all/main/binary-amd64/Packages | from apt-packages | select package filename sha256
    let filenames = $packages | each { |package| $"pool/main/intel-oneapi-($package)_amd64.deb" }
    let sources = $index | where { |src| $src.filename in $filenames }
    let missing = $filenames | where { |filename| $filename not-in ($sources | get filename) }

    print "Missing:"
    for $name in $missing {
        print $name
    }

    let sources = (
        $sources
        | reduce --fold {} { |it, acc| $acc | insert $it.package { url: $"https://apt.repos.intel.com/oneapi/($it.filename)", hash: (nix hash convert --hash-algo sha256 --to sri $it.sha256) } }
    )

    $sources | sort | to json | save --force $file
}

#!/usr/bin/env -S nix shell nixpkgs#nushell --command nu

export def main [] {
    # change this when the following gets resolved
    # https://github.com/nushell/nushell/issues/12195
    const file = "/home/tom/Desktop/Mordrag/nixos/pkgs/by-name/intel-tbb/default.lock"

    const major = "2022.0"
    const version = "2022.0.0-402"

    const packages = [
        $"tbb-($major)-($version)"
        $"tbb-devel-($major)-($version)"
        $"runtime-tbb-($version)"
    ]
    const packages_all = [
        # $"tbb-common-($major)-($version)"
        # $"tbb-common-devel-($major)-($version)"
        # $"runtime-tbb-common-($version)"
    ]

    let index = http get https://apt.repos.intel.com/oneapi/dists/all/main/binary-amd64/Packages | from apt-packages | select package filename sha256
    let index_all = http get https://apt.repos.intel.com/oneapi/dists/all/main/binary-all/Packages | from apt-packages | select package filename sha256

    let filenames = $packages | each { |package| $"pool/main/intel-oneapi-($package)_amd64.deb" }
    let filenames_all = $packages_all | each { |package| $"pool/main/intel-oneapi-($package)_all.deb" }
    
    let sources = $index | where { |src| $src.filename in $filenames }
    let sources_all = $index_all | where { |src| $src.filename in $filenames_all }

    let missing = $filenames | filter { |filename| $filename not-in ($sources | get filename) }
    let missing_all = $filenames_all | filter { |filename| $filename not-in ($sources_all | get filename) }
    
    print "Missing:"
    for $name in ($missing ++ $missing_all) {
        print $name
    }

    let sources = (
        $sources 
        | append $sources_all 
        | reduce --fold {} { |it, acc| $acc | insert $it.package { url: $"https://apt.repos.intel.com/oneapi/($it.filename)", hash: (nix hash convert --hash-algo sha256 --to sri $it.sha256) } }
    )
    
    $sources | to json | save --force $file
}
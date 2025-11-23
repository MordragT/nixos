#!/usr/bin/env -S nix shell nixpkgs#nushell --command nu

export def main [] {
    const file = path self ./default.lock

    const major = "2025.3"
    const version = "2025.3.1-760"
    const classic_version = "2023.2.4-2023.2.4-49553"

    const packages = [
        $"dpcpp-cpp-($major)-($version)"
        $"compiler-dpcpp-cpp-($major)-($version)"
        $"compiler-dpcpp-cpp-runtime-($major)-($version)"
        $"compiler-shared-($major)-($version)"
        $"compiler-shared-runtime-($major)-($version)"
        $"openmp-($major)-($version)"
        $"compiler-dpcpp-cpp-and-cpp-classic-($classic_version)"
        $"compiler-dpcpp-cpp-and-cpp-classic-runtime-($classic_version)"
    ]
    const packages_all = [
        $"compiler-dpcpp-cpp-common-($major)-($version)"
        $"compiler-shared-common-($major)-($version)"
        $"openmp-common-($major)-($version)"
        $"compiler-dpcpp-cpp-and-cpp-classic-common-($classic_version)"
    ]

    let index = http get https://apt.repos.intel.com/oneapi/dists/all/main/binary-amd64/Packages | from apt-packages | select package filename sha256
    let index_all = http get https://apt.repos.intel.com/oneapi/dists/all/main/binary-all/Packages | from apt-packages | select package filename sha256

    let filenames = $packages | each { |package| $"pool/main/intel-oneapi-($package)_amd64.deb" }
    let filenames_all = $packages_all | each { |package| $"pool/main/intel-oneapi-($package)_all.deb" }

    let sources = $index | where { |src| $src.filename in $filenames }
    let sources_all = $index_all | where { |src| $src.filename in $filenames_all }

    let missing = $filenames | where { |filename| $filename not-in ($sources | get filename) }
    let missing_all = $filenames_all | where { |filename| $filename not-in ($sources_all | get filename) }

    print "Missing:"
    for $name in ($missing ++ $missing_all) {
        print $name
    }
    let sources = (
        $sources
        | append $sources_all
        | reduce --fold {} { |it, acc| $acc | insert $it.package { url: $"https://apt.repos.intel.com/oneapi/($it.filename)", hash: (nix hash convert --hash-algo sha256 --to sri $it.sha256) } }
    )

    $sources | sort | to json | save --force $file
}

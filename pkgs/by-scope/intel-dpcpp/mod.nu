#!/usr/bin/env -S nix shell nixpkgs#nushell --command nu

# def fetch-debs [packages: list<string>] {
#     let debs = (
#         $packages
#         | each { |package| { key: $package, val: (fetch-deb $package) } }
#         | reduce --fold {} { |it, acc| $acc | insert $it.key $it.val}
#     )
#     return $debs
# }

# def fetch-deb [package: string] {
#     let url = $"https://apt.repos.intel.com/oneapi/pool/main/($package).deb"
#     let hash = nix store prefetch-file $url --json | from json | get hash

#     return {
#         url: $url,
#         hash: $hash,
#     }
# }

export def main [] {
    # change this when the following gets resolved
    # https://github.com/nushell/nushell/issues/12195
    const file = "/home/tom/Desktop/Mordrag/nixos/pkgs/by-scope/intel-dpcpp/default.lock"

    const major = "2024.2"
    const version = "2024.2.0-981"
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
    
    let sources = $index | where { |src| $filenames | find $src.filename | is-not-empty }
    let sources_all = $index_all | where { |src| $filenames_all | find $src.filename | is-not-empty }

    let sources = (
        $sources 
        | append $sources_all 
        | reduce --fold {} { |it, acc| $acc | insert $it.package { url: $"https://apt.repos.intel.com/oneapi/($it.filename)", hash: (nix hash to-sri --type sha256 $it.sha256) } }
    )
    
    $sources | to json | save --force $file
}
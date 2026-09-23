#!/usr/bin/env -S nix shell nixpkgs#nushell --command nu

export def main [] {
    const file = path self ./wheels.lock

    const packages = [
        { name: "intel-cmplr-lib-rt"  version: "2026.1.2" }
        { name: "intel-cmplr-lib-ur"  version: "2026.1.2" }
        { name: "intel-cmplr-lic-rt"  version: "2026.1.2" }
        { name: "intel-sycl-rt"       version: "2026.1.2" }
        { name: "oneccl-devel"        version: "2022.1.2" }
        { name: "oneccl"              version: "2022.1.2" }
        { name: "impi-rt"             version: "2021.18.1" }
        { name: "onemkl-license"      version: "2026.1.0" }
        { name: "onemkl-sycl-blas"    version: "2026.1.0" }
        { name: "onemkl-sycl-dft"     version: "2026.1.0" }
        { name: "onemkl-sycl-lapack"  version: "2026.1.0" }
        { name: "onemkl-sycl-rng"     version: "2026.1.0" }
        { name: "onemkl-sycl-sparse"  version: "2026.1.0" }
        { name: "dpcpp-cpp-rt"        version: "2026.1.2" }
        { name: "intel-opencl-rt"     version: "2026.1.2" }
        { name: "mkl"                 version: "2026.1.0" }
        { name: "intel-openmp"        version: "2026.1.2" }
        { name: "tbb"                 version: "2023.1.0" }
        { name: "tcmlib"              version: "1.5.0" }
        { name: "umf"                 version: "1.1.0" }
        { name: "intel-pti"           version: "1.1.0" }
    ]

    const pattern = "py2.py3-none-manylinux_2_28_x86_64.whl"

    let results = $packages | each { |pkg|
        let meta = http get $"https://pypi.org/pypi/($pkg.name)/($pkg.version)/json"

        let wheel = $meta.urls
            | where filename =~ $"($pattern)$"
            | first

        if ($wheel | is-empty) {
            print $"MISSING wheel matching '($pattern)': ($pkg.name) ($pkg.version)"
            null
        } else {
            # hex digest -> base64 SRI, same as nix hash convert
            let hex = $wheel.digests.sha256
            let b64 = $hex | decode hex | encode base64
            {
                name: $pkg.name
                value: {
                    version: $pkg.version
                    url: $wheel.url
                    hash: $"sha256-($b64)"
                }
            }
        }
    } | compact

    let sources = $results | reduce --fold {} { |it, acc| $acc | insert $it.name $it.value }

    $sources | sort | to json | save --force $file
}

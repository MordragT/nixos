#!/usr/bin/env -S nix shell nixpkgs#nushell nixpkgs#ghostscript --command nu

export def "compress pdf" [
    input: string,
    output: string
] {
    (gs
        -sDEVICE=pdfwrite
        -dCompatibilityLevel=1.7
        -dPDFSETTINGS=/ebook
        -dNOPAUSE
        -dQUIET
        -dBATCH
        -sOutputFile=$output
        $input
    )
}

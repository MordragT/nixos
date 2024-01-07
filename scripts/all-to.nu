#!/usr/bin/env -S nix shell nixpkgs#ffmpeg nixpkgs#nushellFull nixpkgs#imagemagick --command nu

export def main [] {}

export def "main hevc" [path: string = ".", --extension(-e): string, --delete(-d), --recursive(-r)] {
    (convert-to
        { |entry, basename|
            let source = $entry.name
            let dest = $"($entry.name | path dirname)/($basename).mkv"

            print $"Converting ($source) to ($dest)"
            ffmpeg -i $source -c:v libx265 $dest
        }
        $path
        $extension
        $delete
        $recursive
    )
}

export def "main opus" [path: string = ".", --extension(-e): string, --delete(-d), --recursive(-r)] {
    (convert-to
        { |entry, basename|
            let source = $entry.name
            let dest = $"($entry.name | path dirname)/($basename).opus"

            print $"Converting ($source) to ($dest)"
            ffmpeg -i $source $dest
        }
        $path
        $extension
        $delete
        $recursive
    )
}

export def "main png" [path: string = ".", --extension(-e): string, --delete(-d), --recursive(-r)] {
    (convert-to
        { |entry, basename|
            let source = $entry.name
            let dest = $"($entry.name | path dirname)/($basename).png"

            print $"Converting ($source) to ($dest)"
            convert $source $dest
        }
        $path
        $extension
        $delete
        $recursive
    )
}

export def "main enum" [path: string = ".", --extension(-e): string, --recursive(-r)] {
    let extension = $extension | str trim --left --char '.'

    (convert-to
        { |entry, basename|
            let source = $entry.name
            let dest = $"($entry.name | path dirname)/($entry.index)-($basename).($extension)"

            mv $source $dest
        }
        $path
        $extension
        false
        $recursive
    )
}

export def "main prefix" [path: string = ".", --extension(-e): string, --prefix(-p): string, --recursive(-r)] {
    let extension = $extension | str trim --left --char '.'

    (convert-to
        { |entry, basename|
            let source = $entry.name
            let dest = $"($entry.name | path dirname)/($prefix)-($basename).($extension)"

            mv $source $dest
        }
        $path
        $extension
        false
        $recursive
    )
}


def convert-to [f, path: string, extension: string, delete: bool, recursive: bool] {
    let extension = $extension | str trim --left --char '.'
    let pattern = if $recursive {
        $"($path)/**/*"
    } else {
        $path
    }

    ls $pattern -f
        | where { |it| $it.name | str ends-with $extension }
        | enumerate
        | each { |entry|
            let entry = $entry.item | merge ($entry.index | wrap index)
            let basename = $entry.name | path basename
            let rpos = ($basename | str length) - ($extension | str length) - 1
            let basename = $basename | str substring 0..$rpos

            do $f $entry $basename

            if $delete {
                rm $entry.name
            }
        }
}
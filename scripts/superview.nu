#!/usr/bin/env -S nix shell nixpkgs#ffmpeg nixpkgs#nushellFull --command nu

def sequeeze [width, height, orig_width] {
    # let inv = 1.0 - ($tx | math abs)
    # let offset = $inv * ((($width / 16.0) * 7.0) / 2.0) - ((($inv / 16.0) * 7.0) ** 2) * ((($width / 7.0) * 16.0) / 2.0)

    # let wx = if $tx < 0 {
    #     ($sx + $offset * -1) | into int
    # } else {
    #     ($sx + $offset) | into int
    # }
}

def gen-ymap [width: int, height: int] {
    let pgm = $"P2 ($width) ($height) 65535\n"

    let table = 0..<$height | each { |y|
        0..<$width | each { |x|
            $y
        } | str join  ' '
    } | str join "\n"

    $pgm + $table
}

def gen-xmap [stream, width: int, height: int] {
    let cx = ($stream.width | into float) / 2.0
    let ratio = ($stream.width | into float) / ($width | into float)
    # let cy = $stream.height | into float / 2.0

    let pgm = $"P2 ($width) ($height) 65535\n"

    let table = 1..$height | each { |y|
        1..$width | each { |x|
            let x = ($x | into float) * $ratio
            # normalized distance from the center -1..0..1
            let dx = ($x - $cx) / $cx

            # use tanh/sinh ? to smooth distortion
            let sx = $dx * 3.141592 / 2.0 | math sin
            # let sx = $dx * 3.141592 / 2.0 | math tanh

            # todo maybe combine functions

            let x = ($cx + $sx * $cx) | into int

            {($y - 1): $x}
        }
    } | reduce {|it, acc| $acc | merge $it }

    $pgm + ($table | values | each { |row| $row | str join ' ' } | str join "\n")
}

#  def pgm [width: float, height: float, orig_width: float] {
#     let init = [$"P2 ($width) ($height) 65535\n" $"P2 ($width) ($height) 65535\n"]
    
#     let dx = ($width - $orig_width) / 2.0

#     let result = (seq 0.0 $height | reduce --fold $init { |y, acc| 
#         let result = (seq 0.0 $width| reduce --fold $acc { |x, acc|
#             let tx = ($x / $width - 0.5) * 2.0
#             let sx = $x - $dx

#             let offset = $tx ** 2 * $dx

#             let wx = if $tx < 0 {
#                 ($sx - $offset * -1) | into int
#             } else {
#                 ($sx - $offset) | into int
#             }

#             [
#                 ($acc.0 + ($wx | into string) + " "),
#                 ($acc.1 + ($y | into string) + " ")
#             ]
#         })

#         [
#             ($result.0 + "\n"),
#             ($result.1 + "\n")
#         ]
#     })

#     return $result
# }

export def main [file, --skip(-s), --output(-o): string] {
    echo ("Processing: " + $file)

    let specs = ((ffprobe
        -i $file
        -v error
        -select_streams v:0
        -show_entries stream=codec_name,width,height,duration,bit_rate
        -print_format json) | from json)
    
    let stream = $specs.streams.0

    echo $stream

    if not $skip {
        echo "Creating pgm files"

        let width = ((($stream.height  * (16 / 9) / 2) | into int) * 2) | into float
        let height = $stream.height | into float

        echo $"Width: ($width)"
        echo $"Height: ($height)"

        # let pgm_res = pgm $width $height ($stream.width | into float)

        # echo $pgm_res.0 | save x.pgm
        # echo $pgm_res.1 | save y.pgm

        gen-xmap $stream $width $height | save -f x.pgm
        gen-ymap $width $height | save -f y.pgm
    }

    let output = if $output == null {
        $"($file)-streched.mkv"
    } else {
        $output
    }

    echo $"Creating streched video at ($output)"

    (ffmpeg
        -hide_banner
        -progress pipe:1
        -loglevel panic
        -y
        -re
        -i $file
        -i x.pgm
        -i y.pgm
        -filter_complex remap,format=yuv444p,format=yuv420p
        -c:v libx265
        -c:a libopus
        -x265-params
        log-level=error
        $output)
}
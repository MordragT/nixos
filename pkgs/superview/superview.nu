#!/usr/bin/env nu

def pgm [width, height, orig_width] {
    let init = [$"P2 ($width) ($height) 65535\n" $"P2 ($width) ($height) 65535\n"]

    let result = (seq 0 $height | reduce --fold $init { |y, acc| 
        let result = (seq 0 $width | reduce --fold $acc { |x, acc|
            let tx = ($x / $width - 0.5) * 2.0
            let sx = ($x - ($width - $orig_width) / 2.0)
            let inv = 1.0 - ($tx | math abs)
            let offset = $inv * ((($width / 16.0) * 7.0) / 2.0) - ((($inv / 16.0) * 7.0) ** 2) * ((($width / 7.0) * 16.0) / 2.0)

            let $wx = if $tx < 0 {
                ($sx + $offset * -1) | into int
            } else {
                ($sx + $offset) | into int
            }

            [
                ($acc.0 + ($wx | into string) + " "),
                ($acc.1 + ($y | into string) + " ")
            ]
        })

        [
            ($result.0 + "\n"),
            ($result.1 + "\n")
        ]
    })

    return $result
}

export def superview [file, --skip: bool] {
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

        let width = ((($stream.height  * (16 / 9) / 2) | into int) * 2)
        let height = ($stream.height | into int)

        echo $"Width: ($width)"
        echo $"Height: ($height)"

        let pgm_res = pgm $width $height $stream.width

        echo $pgm_res.0 | save width_x.pgm
        echo $pgm_res.1 | save width_y.pgm
    }

    let output = $file + "_out.mkv"

    (ffmpeg
        -hide_banner
        -progress pipe:1
        -loglevel panic
        -y -re
        -i $file
        -i width_x.pgm
        -i width_y.pgm
        -filter_complex remap,format=yuv444p,format=yuv420p
        -c:v libx265
        -c:a libopus
        -x265-params
        log-level=error
        $output)
}
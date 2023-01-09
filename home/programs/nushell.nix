{ pkgs, ... }:
{
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  #programs.direnv.enableNushellIntegration = true;

  #programs.starship.enable = true;
  #programs.starship.enableNushellIntegration = true;

  programs.nushell = {
    enable = true;
    configFile.text = ''
      def pgm [width, height] {
          mut pgm_w = $"P2 ($width) ($height) 65535"
          mut pgm_h = $"P2 ($width) ($height) 65535"

          for y in 0..<height { 
              for x in 0..<width {
                  let tx = ($x / $width - 0.5) * 2
                  let inv = (1 - $tx | math abs)
                  mut offset = $inv * (((($width / 16) * 7) / 2.0) - (((($inv / 16) * 7) ** 2) * (($width / 7) * 16) / 2.0))

                  if $tx < 0 {
                      $offset *= -1
                  }

                  $pgm_w += ($x + $offset | into string) + "\n \n"
                  $pgm_h += ($y | into string) + "\n \n"
              }

              $pgm_w += "\n"
              $pgm_h += "\n"
          }

          let res = { width: $pgm_w, height: $pgm_h }
          $res
      }

      export def superview [file] {
          let specs = ((${pkgs.ffmpeg}/bin/ffprobe \
              $"-i ($file) -v error -select_streams v:0 -show_entries stream=codec_name,width,height,duration,bit_rate -print_format json") | from json)
          
          echo specs

          let width = $specs.Streams[0].Width * (16/9) / 2 * 2
          let height = $specs.Streams[0].Height

          let pgm_res = pgm $width $height

          echo $pgm_res.width | save width_x.pgm
          echo $pgm_res.height | save width_y.pgm

          let output = $specs.File + "_out.mkv"

          ${pkgs.ffmpeg}/bin/ffmpeg \
              $"-hide_banner -progress pipe:1 -loglevel panic -y -re -i ($specs.File) -i width_x.pgm -i width_y.pgm -filter_complex remap,format=yuv444p,format=yuv420p -c:v libx265 -c:a libopus -x265-params log-level=error ($output)"
      }


      def , [...pkgs: string] {
        let $pkgs = ($pkgs
          | each { |pkg| "nixpkgs#" + $pkg }
          | str collect ' ')
        let cmd = $"nix shell ($pkgs)"
        bash -c $cmd
      }
      
      alias comojit = comoji commit
      alias r = direnv reload
    '';
    envFile.text = "";
  };
}

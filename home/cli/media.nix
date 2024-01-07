{pkgs, ...}: {
  home.packages = with pkgs; [
    asciinema # record terminals
    ffmpeg_6-full
    # ((ffmpeg_6-full.overrideAttrs (old: {
    #     configureFlags = old.configureFlags ++ ["--enable-libvpl"];
    #     buildInputs = old.buildInputs ++ [pkgs.oneVPL];
    #   }))
    #   .override {withMfx = false;})
    # silicon # rust tool to create beautiful code images
    yt-dlp # download youtube videos
  ];
}

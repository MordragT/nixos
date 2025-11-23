{
  makeDesktopItem,
  writeTextFile,
  scrcpy,
}: let
  icon = writeTextFile {
    name = "tft-icon";
    text = ''
           <svg version="1.0" id="katman_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
       viewBox="0 0 96 72" style="enable-background:new 0 0 96 72;" xml:space="preserve">
           <style type="text/css">
      .st0{fill-rule:evenodd;clip-rule:evenodd;fill:url(#SVGID_1_);}
           </style>
           <linearGradient id="SVGID_1_" gradientUnits="userSpaceOnUse" x1="34.8739" y1="12.8925" x2="64.828" y2="60.9741" gradientTransform="matrix(1 0 0 -1 0 74)">
      <stop  offset="4.909790e-02" style="stop-color:#AF893D"/>
      <stop  offset="0.2178" style="stop-color:#D29D40"/>
      <stop  offset="0.6393" style="stop-color:#FFCC74"/>
      <stop  offset="0.8142" style="stop-color:#E8B55D"/>
           </linearGradient>
           <path class="st0" d="M30.7,40c0.3,0.3,0.9,0.7,1.9,1.3v3.6l12,7l0-1.7c3.6,1.6,6.4,2.6,8.4,2.9l0.1,0L48,56L30.7,45.9V40z M48,16
      l17.3,10v15.2c1.7,1.2,3.1,2.7,4.3,4.5c-0.3-0.1-0.9-0.4-1.8-0.8c1.1,2.5,1.3,6.3-2.8,7.2c-9.8,2.3-22.6-4.1-27.4-7.3
      c2.5,1,4.8,1.9,7,2.6l0-1.6c-2.3-0.8-6.3-2.4-10.6-5.3c-4-2.7-7.1-6-7.5-6.6c0.7,0.2,1.2,0.3,1.7,0.3c-1.5-2.7,0.1-5.6,2.6-6.7V26
      L48,16z M48,18.1L32.6,27v7.2c-0.7-0.6-1.7-2.3-1.9-3.3c-0.7,0.5-0.8,1.5-0.4,2.6c1.8,4.6,9.4,9.5,14.2,12.1l0-12.2h-7.5l-2.6-5.9
      h27.2L59,33.5h-7.5l0,15.7c2.2,0.4,4.3,0.7,6.2,0.8c8.3,0.4,8.9-2,7.5-4l-4.8,2.8c-1.3,0.1-2.5,0.1-3.6-0.1l6.6-3.8V27L48,18.1z"/>
           </svg>

    '';
    destination = "/share/icons/tft/scalable/favicon.svg";
  };
in
  makeDesktopItem {
    name = "teamfight-tactics";
    desktopName = "Teamfight Tactics";
    icon = "${icon}/share/icons/tft/scalable/favicon.svg";
    exec = "${scrcpy}/bin/scrcpy --video-bit-rate=8M --new-display=1440x2560 --max-fps=60 --video-codec=h265 --video-encoder=c2.mtk.hevc.encoder --render-driver=opengl --start-app=com.riotgames.league.teamfighttactics --fullscreen --stay-awake";
  }

{
  pkgs,
  config,
  ...
}: {
  boot.extraModulePackages = with config.boot.kernelPackages; [akvcam v4l2loopback];
  boot.kernelModules = ["akvcam" "v4l2loopback"];
  environment.systemPackages = with pkgs; [
    webcamoid
  ];

  security.polkit.enable = true;

  environment.etc."akvcam/config.ini" = {
    text = "[Cameras]
cameras/size = 2

cameras/1/type = output
cameras/1/mode = mmap, userptr, rw
cameras/1/description = Akvcam (Output device)
cameras/1/formats = 1

cameras/2/type = capture
cameras/2/mode = mmap, rw
cameras/2/description = Akvcam (Capture device)
cameras/2/formats = 1

[Formats]
formats/size = 1

formats/1/format = YUY2
formats/1/width = 1280
formats/1/height = 720
formats/1/fps = 30

[Connections]
connections/size = 1
connections/1/connection = 1:2";
    mode = "0644";
  };
}

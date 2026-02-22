final: prev:
let
  callScope = path: prev.lib.makeScope final.newScope (import path final);
in
{
  intel-dpcpp = callScope ./intel-dpcpp;
  intel-sycl = callScope ./intel-sycl;
  pti-gpu = callScope ./pti-gpu;
  # steamPackages = pkgs.steamPackages.overrideScope (_: _: makeScope ./steam-packages self.steamPackages);
}

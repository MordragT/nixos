{
  lib,
  fetchFromGitHub,
  libcosmicAppHook,
  rustPlatform,
  just,
  stdenv,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "cosmic-ext-applet-tailscale";
  version = "unstable-2025-03-24";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "gui-scale-applet";
    rev = "957bb3c2d2fb483e5bce4b855b86a71c0a3621f3";
    hash = "sha256-Hc6oplWdyRc5PkDY1Gq2Ja7tihNVutci7jg+ZZYp6ws=";
  };

  cargoHash = "sha256-m8Ap3aXnjwQ14boE+e3zrYSOimLK+NXjA+KO7uwXktQ=";
  # cargoLock = {
  #   lockFile = "${src}/Cargo.lock";
  #   outputHashes = {
  #     "accesskit-0.16.0" = "sha256-yeBzocXxuvHmuPGMRebbsYSKSvN+8sUsmaSKlQDpW4w=";
  #     "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
  #     "clipboard_macos-0.1.0" = "sha256-tovB4fjPVVRY8LKn5albMzskFQ+1W5ul4jT5RXx9gKE=";
  #     "cosmic-client-toolkit-0.1.0" = "sha256-/DJ/PfqnZHB6VeRi7HXWp0Vruk+jWBe+VCLPpiJeEv4=";
  #     "cosmic-config-0.1.0" = "sha256-7CKtRpQKYyUwANz5OMkfqDkfbGP4y0pSjvWBngby+yI=";
  #     "cosmic-freedesktop-icons-0.2.6" = "sha256-+WmCBP9BQx7AeGdFW2KM029vuweYKM/OzuCap5aTImw=";
  #     "cosmic-panel-config-0.1.0" = "sha256-7NBwrSFE5HVNTX6WnnaEZ7bfKl8pgfqXcdGh6aZYBgw=";
  #     "cosmic-text-0.12.1" = "sha256-+litEIoCWfwt/+wqRCtWuGr5DHAuDFV/naHnADNLbQI=";
  #     "dpi-0.1.1" = "sha256-whi05/2vc3s5eAJTZ9TzVfGQ/EnfPr0S4PZZmbiYio0=";
  #     "iced_glyphon-0.6.0" = "sha256-u1vnsOjP8npQ57NNSikotuHxpi4Mp/rV9038vAgCsfQ=";
  #     "smithay-client-toolkit-0.19.2" = "sha256-wwfX5zJis8CwtJA9YjFKLQvb8pPwU+QP9zrvz/Jasls=";
  #     "smithay-clipboard-0.8.0" = "sha256-4InFXm0ahrqFrtNLeqIuE3yeOpxKZJZx+Bc0yQDtv34=";
  #     "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
  #     "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
  #   };
  # };

  nativeBuildInputs = [
    libcosmicAppHook
    just
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/gui-scale-applet"
  ];

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "A COSMIC applet for managing tailscale VPN connections";
    homepage = "https://github.com/cosmic-utils/gui-scale-applet";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [mordrag];
    mainProgram = "gui-scale-applet";
    broken = true; # problem with git dependencies and missing sctk patch
  };
}

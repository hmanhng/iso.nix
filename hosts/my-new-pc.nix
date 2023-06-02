{ pkgs, lib, config, modulesPath, inputs, ... }:
{
  imports = [
    "${toString modulesPath}/installer/cd-dvd/iso-image.nix"
  ];
  isoImage.makeEfiBootable = true;
  isoImage.makeUsbBootable = true;

  programs.fish = {
    enable = true;
    shellAliases = {
      hmanhng_flake = "git clone https://github.com/hmanhng/.flakes --branch=tmpfs && cd .flakes";
    };
  };
  users.defaultUserShell = pkgs.fish;
  environment.shells = with pkgs; [ fish ];

  networking.networkmanager.enable = true;
  services.getty.autologinUser = "root";
  nix = {
    settings = {
      substituters = [
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
      auto-optimise-store = true; # Optimise syslinks
    };
    package = pkgs.nixVersions.unstable;
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      warn-dirty            = false
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';
  };
  nixpkgs.config.allowUnfree = true;
  nixpkgs.system = "x86_64-linux";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-128n.psf.gz";
    packages = with pkgs; [ terminus_font ];
    keyMap = "us";
  };
  environment.systemPackages = with pkgs;[ parted neovim git ];
}

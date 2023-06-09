{ pkgs, lib, config, modulesPath, inputs, ... }:
{
  imports = [
    "${toString modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];
  isoImage.squashfsCompression = "gzip -Xcompression-level 1";

  programs.bash = {
    shellInit = ''
      setfont ter-128n

      systemctl start wpa_supplicant
      connect_to_wifi() {
        local wifi=$(iwconfig 2>/dev/null | grep -oP '^[^\s]+')
        # wpa_supplicant -B -i ''${3:-$wifi} -c <(wpa_passphrase $1 $2)
        wpa_cli -i ''${3:-$wifi} add_network
        wpa_cli -i ''${3:-$wifi} set_network 0 ssid "\"$1\""
        wpa_cli -i ''${3:-$wifi} set_network 0 scan_ssid 1
        wpa_cli -i ''${3:-$wifi} set_network 0 key_mgmt WPA-PSK
        wpa_cli -i ''${3:-$wifi} set_network 0 psk "\"$2\""
        wpa_cli -i ''${3:-$wifi} enable_network 0
      }
    '';
    shellAliases = {
      hmanhng_flake = "git clone https://github.com/hmanhng/.flakes --branch=tmpfs && cd .flakes";
    };
  };
  # users.defaultUserShell = pkgs.fish;

  services.getty.autologinUser = lib.mkForce "root";
  nix = {
    extraOptions = ''
      accept-flake-config   = true
      warn-dirty            = false
      experimental-features = nix-command flakes
    '';
  };
  nixpkgs.system = "x86_64-linux";
  environment.systemPackages = with pkgs;[ parted neovim git ];
  system.stateVersion = "22.11";
}

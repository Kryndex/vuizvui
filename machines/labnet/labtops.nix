{
  labtop = {
    vuizvui.user.openlab.labtops.enable = true;
    boot.kernelModules = [ "kvm-intel" ];
    boot.initrd.availableKernelModules = [
      "uhci_hcd" "ehci_pci" "ata_piix" "firewire_ohci" "usb_storage"
    ];

    vuizvui.hardware.thinkpad.enable = true;

    hardware.trackpoint.enable = false;

    networking.enableIntel3945ABGFirmware = true;

  };

  hannswurscht = { pkgs, ... }:
    let musicDir = "/data/music"; in
  {
    vuizvui.user.openlab.base.enable = true;

    nixpkgs.system = "i686-linux";

    users.users.openlab.extraGroups = [ "audio" ];
    services.mingetty.autologinUser = "openlab";

    hardware.pulseaudio = {
      enable = true;
      systemWide = true;
      package = pkgs.pulseaudioFull;
      zeroconf.discovery.enable = false;
      zeroconf.publish.enable = true;
      tcp.enable = true;
      tcp.anonymousClients.allowedIpRanges = [ "172.16.0.0/16" "127.0.0.1" ];
    };

    vuizvui.user.openlab.stackenblocken.enable = true;

    services.logind.extraConfig = "HandleLidSwitch=ignore";

    services.mpd = {
      enable = true;
      musicDirectory = musicDir;
      network.listenAddress = "any";
      extraConfig = ''
        auto_update yes
        audio_output {
          type            "pulse"
          name            "MPD Pulse Output"
          server          "127.0.0.1"
        }
      '';
    };

    fileSystems = {
      "${musicDir}" = {
        device = "ftp.openlab.lan:/data/upload/music";
        fsType = "nfs";
        label = "lab-ftp";
        options = [ "nolock" "x-systemd.automount"];
      };
    };
  };
}

{ pkgs, config, lib, ... }:

with lib;

let
  cfg = config.vuizvui.user.openlab.stackenblocken;

in
{
  options.vuizvui.user.openlab.stackenblocken = {
    enable = mkEnableOption "STACKENBLOCKEN EVERY DAY";
  };

  config = mkIf cfg.enable {

    systemd.user = {
      services.stackenblocken = {
        description = "stackenblocken timer";
#        wantedBy = [ "default.target" ];
        serviceConfig = {
          ExecStart = "${lib.getBin pkgs.vuizvui.openlab.stackenblocken}/bin/stackenblocken";
        };
        # everyday at 21:45, except Wednesday (Yoga silence)
        startAt = [ "Mon,Tue,Thu,Fri,Sat,Sun 21:45" "Wed 22:00" ];
      };
    };

  };
}

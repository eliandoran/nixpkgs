{ pkgs, config, lib, ...}:

with lib;

let
  cfg = config.services.librenms-agent;
in {
  options.services.librenms-agent = {
    enable = mkEnableOption "LibreNMS agent";

    package = mkPackageOption pkgs "librenms-agent" {};

    listenStream = mkOption {
      type = with types; listOf str;
      default = [ "6556" ];
      example = [ "192.168.1.1:6556" ];
      description = mdDoc ''
        Addresses/ports on which the LibreNMS Agent should listen to.
        For detailed syntax see ListenStream in {manpage}`systemd.socket(5)`.
      '';
    };

    ipAddressAllow = mkOption {
      example = [ "192.168.1.0/24" ];
      type = types.listOf types.str;
      description = ''
        Allows access to the LibreNMS Agent only for the given addresses.
      '';
    };

  };

  config = mkIf cfg.enable {
    systemd.sockets.librenms-agent = {
      description = "Check_MK LibreNMS Agent Socket";
      wantedBy = [ "sockets.target" ];
      socketConfig = {
        ListenStream = cfg.listenStream;
        Accept = "yes";
      };
    };

    systemd.services."librenms-agent@" = {
      description = "Check_MK LibreNMS Agent Service";
      after = [ "network.target" "librenms-agent.socket" ];
      requires = [ "librenms-agent.socket" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/check_mk_agent";
        StandardOutput = "socket";
        IPAddressDeny = "any";
        IPAddressAllow = cfg.ipAddressAllow;
      };
    };
  };
}

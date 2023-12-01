{ pkgs, config, lib, ...}:

with lib;

let
  cfg = config.services.librenms-agent;
in {
  options.services.librenms-agent = {
    enable = mkEnableOption "LibreNMS agent";

    package = mkPackageOption pkgs "librenms-agent" {};

    port = mkOption {
      type = types.port;
      default = 6556;
      description = mdDoc "Port where the LibreNMS Agent will listen.";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Open port for LibreNMS Agent.
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
        ListenStream = toString cfg.port;
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

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];
  };
}

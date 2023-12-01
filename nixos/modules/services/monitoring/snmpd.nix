{ pkgs, config, lib, ... }:

with lib;

let
  cfg = config.services.snmpd;
in {
  options.services.snmpd = {
    enable = mkEnableOption "snmpd";

    package = mkPackageOption pkgs "net-snmp" {};

    listenAddress = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = mdDoc ''
        The address to listen on for SNMP and AgentX messages
      '';
      example = "127.0.0.1";
    };

    port = mkOption {
      type = types.port;
      default = 161;
      description = mdDoc ''
        The port to listen on for SNMP and AgentX messages
      '';
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Open port in firewall for snmpd
      '';
    };

    configFile = mkOption {
      type = types.path;
      description = lib.mdDoc ''
        Path to the snmpd.conf file.
      '';
    };

  };

  config = mkIf cfg.enable {
    systemd.services."snmpd" = {
      description = "Simple Network Management Protocol (SNMP) daemon.";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/snmpd -f -Lo -c ${cfg.configFile} ${cfg.listenAddress}:${toString cfg.port}";
      };
    };

    networking.firewall.allowedUDPPorts = mkIf cfg.openFirewall [
      cfg.port
    ];
  };
}

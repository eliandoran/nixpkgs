{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.tuya-mqtt;
  format = pkgs.formats.json { };
  settingsFile = format.generate "config.json" cfg.settings;
  devicesFile = format.generate "devices.conf" cfg.devices;
in {
  options.services.tuya-mqtt = {
    enable = mkEnableOption (mdDoc "tuya-mqtt service");

    package = mkOption {
      description = mdDoc "tuya-mqtt package to use";
      default = pkgs.tuya-mqtt;
      defaultText = literalExpression ''
        pkgs.tuya-mqtt
      '';
      type = types.package;
    };

    dataDir = mkOption {
      description = lib.mdDoc "tuya-mqtt data directory";
      default = "/var/lib/tuya-mqtt";
      type = types.path;
    };

    debug = mkOption {
      type = types.str;
      default = "tuya-mqtt:*";
      defaultText = literalExpression "tuya-mqtt:*";
      example = literalExpression ''*'';
      description = mdDoc ''
        Configures the debug module.

        To log everything (including raw Tuya exchanges), use "*" instead.
        To not display anything, use an empty string.
      '';
    };

    settings = mkOption {
      type = format.type;
      default = { };
      example = literalExpression ''
        {
          host = "127.0.0.1";
          port = 1883;
          topic = "tuya/";
          mqtt_user = "tuya";
          mqtt_pass = "tuya";
        }
      '';
      description = mdDoc ''
        The `config.json` file to be passed to the tuya-mqtt service, as a Nix attribute set.
        Check [config.json.sample](https://github.com/TheAgentK/tuya-mqtt/blob/master/config.json.sample)
        for possible options.
      '';
    };

    devices = mkOption {
      type = format.type;
      default = { };
      description = mdDoc ''
        The `devices.conf` file to be passed to the tuya-mqtt service, as a Nix attribute set.
        Check the [documentation](https://github.com/TheAgentK/tuya-mqtt#setting-up-devicesconf)
        for possible options.
      '';
    };

    openFirewall = mkOption {
      description = mdDoc ''
        Whether to enable the ports needed to communicate with local Tuya devices (UDP / 6666 and 6667).
      '';
      default = false;
      type = types.bool;
    };

  };

  config = mkIf (cfg.enable) {

    systemd.services.tuya-mqtt = {
      description = "Tuya-MQTT Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/tuya-mqtt";
        User = "tuya-mqtt";
        Group = "tuya-mqtt";
        WorkingDirectory = cfg.dataDir;
        Restart = "on-failure";
      };
      environment.DEBUG = cfg.debug;
      preStart = ''
        cp --no-preserve=mode ${settingsFile} "${cfg.dataDir}/config.json"
        cp --no-preserve=mode ${devicesFile} "${cfg.dataDir}/devices.conf"
      '';
    };

    networking.firewall.allowedUDPPorts = optionals cfg.openFirewall [
      6666 6667
    ];

    users.users.tuya-mqtt = {
      home = cfg.dataDir;
      createHome = true;
      group = "tuya-mqtt";
      isSystemUser = true;
    };

    users.groups.tuya-mqtt = {};

  };

}

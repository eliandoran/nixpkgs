{ pkgs, config, lib, ... }:

let
  cfg = config.services.mympd;
in {
  options = {

    services.mympd = {

      enable = lib.mkEnableOption (lib.mdDoc "MyMPD server");

      package = lib.mkPackageOption pkgs "mympd" {};

      port = lib.mkOption {
        type = lib.types.port;
        description = lib.mdDoc ''
          The HTTP port where mympd's web interface will be available.

          The HTTPS/SSL port can be configured via {option}`config`.
        '';
        example = "8080";
      };

      ssl = lib.mkOption {
        type = lib.types.bool;
        description = lib.mdDoc ''
          Whether to enable listening on the SSL port.

          Refer to <https://jcorporation.github.io/myMPD/configuration/configuration-files#ssl-options>
          for more information.
        '';
        default = false;
      };

      config = lib.mkOption {
        type = with lib.types; attrsOf (nullOr (oneOf [ str bool int ]));
        description = lib.mdDoc ''
          Manages the configuration files declaratively. For all the configuration
          options, see <https://jcorporation.github.io/myMPD/configuration/configuration-files>.

          Each key represents the "File" column from the upstream configuration table, and the
          value is the content of that file.

          The configuration is automatically written at service start-up, so it is
          possible to change their values after the first start of the service.
        '';
      };
    };

  };

  config = lib.mkIf cfg.enable {

    services.mympd.config = {
      http_port = cfg.port;
      ssl = cfg.ssl;
    };

    systemd.services.mympd = {
      description = "MyMPD Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      preStart = with lib; ''
        config_dir="/var/lib/mympd/config"
        mkdir -p "$config_dir"

        ${concatStringsSep "\n" (mapAttrsToList (name: value: ''
        echo -n "${if isBool value then boolToString value else toString value}" > "$config_dir/${name}"
        '') cfg.config)}
      '';
      serviceConfig = {
        DynamicUser = true;
        StateDirectory = "mympd";
        CacheDirectory = "mympd";
        ExecStart = lib.getExe cfg.package;
      };
    };

  };

  meta.maintainers = [ lib.maintainers.eliandoran ];

}

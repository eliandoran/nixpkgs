import ./make-test-python.nix ({ pkgs, lib, ... }:
  {
    name = "tuya-mqtt";
    nodes.machine = { pkgs, ... }: {
      services.tuya-mqtt = {
        enable = true;
      };
    };

    testScript = ''
      machine.start();
      machine.wait_for_unit("tuya-mqtt.service");
      machine.wait_until_fails("systemctl status tuya-mqtt.service")
      machine.succeed(
        "journalctl -eu tuya-mqtt | grep \"No devices found in devices file!\""
      )
    '';
  }
)

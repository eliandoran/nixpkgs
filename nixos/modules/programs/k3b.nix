{ config, pkgs, lib, ... }:
with lib;
{
  options.programs.k3b = {
    enable = mkEnableOption ''
      k3b.

      Enable the k3b (KDE disk burning application).

      Adds setuid wrappers in /run/wrappers/bin for cdrdao and cdrecord.

      These must be manually selected in the k3b configurations..programs tab.

    '';
  };
  config.environment.systemPackages = [ pkgs.k3b pkgs.dvdplusrwtools pkgs.cdrdao pkgs.cdrkit ];
  config.security.wrappers = {
    cdrdao = {
      setuid = true;
      owner = "root";
      group = "cdrom";
      permissions = "u+wrx,g+x";
      source = "${pkgs.cdrdao}/bin/cdrdao";
    };
    cdrecord = {
      setuid = true;
      owner = "root";
      group = "cdrom";
      permissions = "u+wrx,g+x";
      source = "${pkgs.cdrkit}/bin/cdrecord";
    };
  };
}

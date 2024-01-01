{ lib
, buildDotnetModule
, dotnetCorePackages
, fetchFromGitHub
, gtk3
, sane-backends
}:

buildDotnetModule rec {
  pname = "naps2";
  version = "7.2.2";

  src = fetchFromGitHub {
    owner = "cyanfish";
    repo = "naps2";
    rev = "v${version}";
    hash = "sha256-ikt0gl/pNjEaENj1WRLdn/Zvx349FAGpzSV62Y2GwXI=";
  };

  projectFile = "NAPS2.App.Gtk/NAPS2.App.Gtk.csproj";
  nugetDeps = ./deps.nix;

  executables = [ "naps2" ];

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;
  selfContainedBuild = true;
  runtimeDeps = [
    gtk3
    sane-backends
  ];

  postInstall = ''
    install -D NAPS2.Setup/config/linux/com.naps2.Naps2.desktop $out/share/applications/com.naps2.Naps2.desktop
    install -D NAPS2.Lib/Icons/scanner-16-rev0.png $out/share/icons/hicolors/16x16/com.naps2.Naps2.png
    install -D NAPS2.Lib/Icons/scanner-32-rev2.png $out/share/icons/hicolors/32x32/com.naps2.Naps2.png
    install -D NAPS2.Lib/Icons/scanner-48-rev2.png $out/share/icons/hicolors/48x48/com.naps2.Naps2.png
    install -D NAPS2.Lib/Icons/scanner-64-rev2.png $out/share/icons/hicolors/64x64/com.naps2.Naps2.png
    install -D NAPS2.Lib/Icons/scanner-72-rev1.png $out/share/icons/hicolors/72x72/com.naps2.Naps2.png
    install -D NAPS2.Lib/Icons/scanner-128.png $out/share/icons/hicolors/128x128/com.naps2.Naps2.png
  '';

  meta = {
    description = "Scan documents to PDF and more, as simply as possible.";
    homepage = "www.naps2.com";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ eliandoran ];
    platforms = lib.platforms.linux;
    mainProgram = "naps2";
  };

}

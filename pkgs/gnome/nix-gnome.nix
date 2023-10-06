{config, lib, pkgs, ...}:
let
    cfg = config.fndx.packages.gnome;
in
with lib;
{
    options = {
        fndx.packages.gnome.enable = mkEnableOption "GNOME for Foundxtion"; 
    };

    config = mkIf cfg.enable {
        services.xserver = {
            displayManager = {
                autoLogin.enable = false;
                gdm = {
                    enable = true;
                };
            };

            desktopManager = {
                gnome.enable = true;
            };
        };
		environment.gnome.excludePackages = (with pkgs; [
			  	gnome-photos
			   	gnome-tour
		]) ++ (with pkgs.gnome; [
			   	cheese # webcam tool
			   	gnome-music
			   	gnome-terminal
			   	gedit # text editor
			   	epiphany # web browser
			   	geary # email reader
			   	evince # document viewer
			   	gnome-characters
			   	totem # video player
			   	tali # poker game
			   	iagno # go game
			   	hitori # sudoku game
			   	atomix # puzzle game
		]);
        programs.dconf.enable = true;
        fndx.packages.alacritty.enable = true;

        nixpkgs.overlays = [
            (final: prev: {
                alacritty = prev.alacritty.overrideAttrs (oldAttrs: {
                    postInstall = (oldAttrs.postInstall or "") + ''
                        substituteInPlace $out/share/applications/Alacritty.desktop \
                            --replace "[Desktop Entry]
                            Type=Application
                            TryExec=alacritty
                            Exec=alacritty" "[Desktop Entry]
                            Type=Application
                            TryExec=alacritty
                            Exec=env WINIT_UNIX_BACKEND=x11 alacritty"
                    '';
                });
            }) 
        ];
    };
}

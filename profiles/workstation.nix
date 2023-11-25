{config, lib, pkgs, ...}:
let
    cfg = config.fndx.workstation;
in
with lib;
{
    options = {
        fndx.workstation.enable = mkEnableOption "Foundxtion workstation Profile";
    };

    config = mkIf cfg.enable {
        fndx.graphical = {
            enable = true;
            type = "plasma";
        };
    };
}

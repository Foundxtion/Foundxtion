{config, pkgs, ...}:
let
  secrets = import ../secrets.nix;
  server = import ../machines/server.nix;
in
{
  services.grafana = {
    enable = false;
    settings = server.grafana.settings;
  };

  services.prometheus = {
    enable = true;
    port = 9001;
  };
}

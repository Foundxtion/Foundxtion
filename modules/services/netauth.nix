{config, lib, pkgs, ...}:
let
  cfg = config.fndx.services.netauth;
  hostName = lib.strings.toLower cfg.realm;
in
with lib;
{
    options = {
        fndx.services.netauth = {
            enable = mkEnableOption "NetAuth server for ctOS";
            realm = mkOption {
                example = "EXAMPLE.ORG";
                type = types.str;
                description = mdDoc "NetAuth realm";
            };

            organisationName = mkOption {
                example = "Example";
                type = types.str;
                description = mdDoc "NetAuth Organisation name";
            };

            adminPassword = mkOption {
                default = "admin";
                type = types.str;
                description = mdDoc "NetAuth admin password";
            };
            
            masterPassword = mkOption {
                default = "master_password";
                type = types.str;
                description = mdDoc "NetAuth master password for Kerberos";
            };

            kdcPassword = mkOption {
                default = "kdc_password";
                type = types.str;
                description = mdDoc "NetAuth kdc service password";
            };

            kadminPassword = mkOption {
                default = "kadmin_password";
                type = types.str;
                description = mdDoc "NetAuth kadmin service password";
            };
        };
    };

    config = mkIf cfg.enable {
        virtualisation.oci-containers.backend = "docker";
        virtualisation.oci-containers.containers = {
            netauth = {
                autoStart = true;
                image = "s3l4h/netauth:latest";
                ports = [ 
                    "636:636"
                    "389:389"
                    "464:464"
                    "88:88"
                    "749:749"
                ];

                environment = {
                    LDAP_ORGANISATION = "${cfg.organisationName}";
                    KRB_REALM = "${cfg.realm}";
                    KRB_ADMIN_PASSWORD = "${cfg.adminPassword}";
                    LDAP_ADMIN_PASSWORD = "${cfg.adminPassword}";
                    KRB_MASTER_PASSWORD = "${cfg.masterPassword}";
                    KDC_PASSWORD = "${cfg.kdcPassword}";
                    KADMIN_PASSWORD = "${cfg.kadminPassword}";
                    SSL_ENABLE = "1";
                };

                volumes = [
                    "/var/lib/acme/${hostName}:/certificates"
                    "netauth-etc:/etc"
                    "netauth-lib:/var/lib"
                    "netauth-sasl:/usr/lib/sasl2"
                    "/etc/localtime:/etc/localtime:ro"
                ];
                extraOptions = [
                    "--hostname=${hostName}"
                ];
            };
        };

        security.acme.certs."${hostName}" = {
            extraDomainNames = [];
        };
    };
}

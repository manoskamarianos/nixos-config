{ lib, ... }:
let
    # Default nixarr ports.
    servicePorts = {
        jellyfin = 8096;
        transmission = 9091;
        sonarr = 8989;
        radarr = 7878;
        prowlarr = 9696;
        bazarr = 6767;
        seerr = 5055;
    };
in
{
    nixarr = {
        enable = true;
        mediaDir = "/mnt/media/Media";
        stateDir = "/mnt/media/.state/nixarr";

        vpn = {
            enable = true;
            wgConf = "/mnt/media/.secrets/wg.conf";
            exposeOnLAN = false;
        };

        jellyfin = {
            enable = true;
        };

        transmission = {
            enable = true;
            vpn.enable = true;
            peerPort = 51413;
        };

        # Enable all Arrs
        bazarr.enable = true;
        # lidarr.enable = true;
        radarr.enable = true;
        # readarr.enable = true;
        sonarr.enable = true;
        seerr.enable = true;

        # --- Declarative Prowlarr Settings ---
        prowlarr = {
            enable = true;

            settings-sync = {
                # Automatically sync all enabled Nixarr apps to Prowlarr.
                # This adds Sonarr, Radarr, Lidarr, and Readarr as applications
                # with the correct URLs and API keys — no manual setup needed.
                enable-nixarr-apps = true;

                # Define tags for organizing indexers
                tags = [ "flaresolverr" ];

                # Define indexers directly in Nix
                indexers = [
                    {
                        sort_name = "yts";
                        name = "YTS";
                        fields = {
                            baseUrl = "https://yts.gg/";
                        };
                    }
                    {
                        sort_name = "1337x";
                        name = "1337x";
                        tags = [ "flaresolverr" ];
                        fields = {
                            baseUrl = "https://1337x.to/";
                        };
                    }
                    {
                        sort_name = "anime tosho";
                        name = "Anime Tosho";
                        fields = {
                            baseUrl = "https://feed.animetosho.net/";
                        };
                    }
                    {
                        sort_name = "kickasstorrents to";
                        name = "Kickass Torrents";
                        tags = [ "flaresolverr" ];
                        fields = {
                            baseUrl = "https://kickass.torrentsbay.org/";
                        };
                    }
                ];
            };
        };

        # --- Declarative Sonarr Download Clients ---
        sonarr.settings-sync = {
            transmission.enable = true;
        };

        # --- Declarative Radarr Download Clients ---
        radarr.settings-sync = {
            transmission.enable = true;
        };

        # --- Declarative Bazarr Connections ---
        bazarr.settings-sync = {
            sonarr.enable = true;
            sonarr.config = {
                sync_only_monitored_series = true;
                sync_only_monitored_episodes = true;
            };

            radarr.enable = true;
            radarr.config = {
                sync_only_monitored_movies = true;
            };
        };
    };

    services.prowlarr.settings.auth = { method = "External"; required = "DisabledForLocalAddresses"; };
    services.sonarr.settings.auth = { method = "External"; required = "DisabledForLocalAddresses"; };
    services.radarr.settings.auth = { method = "External"; required = "DisabledForLocalAddresses"; };

    services.flaresolverr.enable = true;

    # <service>.cyclops -> local nginx (port 80) -> the service's own port.
    # /etc/hosts can only map names to IPs, so nginx does the port routing.
    networking.hosts."127.0.0.1" = map (name: "${name}.cyclops") (builtins.attrNames servicePorts);

    services.nginx = {
        enable = true;
        virtualHosts = lib.mapAttrs' (name: port: lib.nameValuePair "${name}.cyclops" {
            locations."/" = {
                proxyPass = "http://127.0.0.1:${toString port}";
                proxyWebsockets = true;
                # Transmission rejects requests whose Host header isn't on its
                # whitelist, so let nginx send "127.0.0.1:9091" instead of
                # "transmission.cyclops".
                recommendedProxySettings = name != "transmission";
            };
        }) servicePorts;
    };

}

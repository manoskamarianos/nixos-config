{ pkgs, ... }:
let
    drm-connector = pkgs.writeShellScriptBin "drm-connector" ''
        set -eu

        conn=''${1:-}
        action=''${2:-toggle}

        status=$(echo /sys/class/drm/card*-"$conn"/status)
        if [ ! -e "$status" ]; then
            echo "drm-connector: no such connector: $conn" >&2
            exit 1
        fi

        case "$action" in
            on)  echo detect > "$status" ;;
            off) echo off    > "$status" ;;
            toggle)
                if [ "$(cat "$status")" = connected ]; then
                    echo off    > "$status"
                else
                    echo detect > "$status"
                fi
                ;;
            *)
                echo "usage: drm-connector <connector> on|off|toggle" >&2
                exit 1
                ;;
        esac
    '';
in
{
    environment.systemPackages = [ drm-connector ];

    security.sudo.extraRules = [{
        users = [ "manos" ];
        commands = [{
            command = "/run/current-system/sw/bin/drm-connector";
            options = [ "NOPASSWD" ];
        }];
    }];
}

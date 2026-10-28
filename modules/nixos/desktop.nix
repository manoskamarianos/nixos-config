# Form factor module for machines on permanent AC: no battery, no lid.
#
# Empty by design. The split works by laptop.nix *adding* battery and lid
# handling, not by this module switching it back off, so a desktop's config is
# the absence of those. Desktop-only additions belong here as they come up -
# wake-on-LAN, a performance governor, a static time.timeZone if
# automatic-timezoned ever moves out of common.nix.
{ ... }:
{
}

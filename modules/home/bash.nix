{ ... }:
{
    programs.bash = {
        enable = true;
        initExtra = ''
            PS1='[\u@\h \w]\$ '
        '';
    };
}

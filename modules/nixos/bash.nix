{ ... }:
{
    programs.bash = {
        promptInit = ''
            PS1='[\u@\h \w]\$ '
        '';
    };
}

{ ... }:
{
    programs.bash = {
        enable = true;
        initExtra = ''
            PS1='[\u@\h \w]\$ '

            # Appends --color flags to FZF_DEFAULT_OPTS; written by noctalia's
            # fzf template.
            [ -r ~/.config/fzf/themes/noctalia.sh ] && . ~/.config/fzf/themes/noctalia.sh
        '';
    };

}

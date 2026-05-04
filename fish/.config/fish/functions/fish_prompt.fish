function fish_prompt
        # This is a simple prompt. It looks like
        # alfa@nobby /path/to/dir $
        # with the path shortened and colored
        # and a "#" instead of a "$" when run as root.
        set -l symbol ' $ '
        set -l color $fish_color_cwd
        if fish_is_root_user
                set symbol ' # '
                set -q fish_color_cwd_root
                and set color $fish_color_cwd_root
        end
   
        set_color 3e9726 
        echo -n $USER

        set_color 84eaf9 
        echo -n @

        set_color d15100 
        echo -n $hostname
    
        set_color white
        echo -n (prompt_pwd)

        set_color b1190f
        echo -n $symbol
end

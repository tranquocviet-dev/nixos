{
  hjem.users = {
    dice = {
      # enable = true; # This is not necessary, since enable is 'true' by default
      user = "dice"; # this is the name of the user
      directory = "/home/dice"; # where the user's $HOME resides
      files = {
        ".config/helix/config.toml".text = ''
          theme = "nord"
          [editor]
          line-number = "relative"
          [editor.file-picker]
          hidden = true
        '';
        ".config/helix/languages.toml".text = ''
            [language-server.pyright]
            command = "pyright"

            [[language]]
            name = "python"
            language-servers = [ "pyright" ]


            [language-server.nixd]
            command = "nixd"

            [[language]]
            name = "nix"
            language-servers = [ "nixd" ]
          '';
        ".config/noctalia/settings.toml".text = ''
            [bar.default]
            auto_hide = true
            end = [
                "media",
                "tray",
                "notifications",
                "clipboard",
                "network",
                "bluetooth",
                "volume",
                "brightness",
                "battery",
                "control-center",
                "recorder",
                "session"
            ]
            reserve_space = false
            scale = 1.2

            [idle]
            behavior_order = [ "lock", "screen-off", "lock-and-suspend" ]

                [idle.behavior.lock]
                action = "lock"
                enabled = true
                timeout = 300

                [idle.behavior.lock-and-suspend]
                action = "lock_and_suspend"
                enabled = false
                timeout = 900

                [idle.behavior.screen-off]
                action = "screen_off"
                enabled = true
                timeout = 300

            [location]
            address = "Hanoi"

            [lockscreen]
            blur_intensity = 0.0
            tint_intensity = 0.0

            [lockscreen_widgets]
            enabled = true
            schema_version = 2
            widget_order = [ "lockscreen-login-box@eDP-1" ]

                [lockscreen_widgets.grid]
                cell_size = 16
                major_interval = 4
                visible = true

                [lockscreen_widgets.widget."lockscreen-login-box@eDP-1"]
                box_height = 0.0
                box_width = 0.0
                cx = 960.0
                cy = 540.0
                output = "eDP-1"
                rotation = 0.0
                type = "login_box"

            [osd.kinds]
            volume_input = false

            [plugins]
            enabled = [ "noctalia/screen_recorder" ]

            [shell]
            font_family = "Maple Mono NF CN"
            polkit_agent = true
            settings_show_advanced = true
            ui_scale = 1.2

                [shell.panel]
                launcher_show_icons = false

            [theme]
            builtin = "Nord"
            community_palette = "One"

                [theme.templates]
                builtin_ids = [ "alacritty", "emacs", "gtk3", "gtk4", "kitty", "labwc", "niri", "qt" ]
                community_ids = [ "obsidian", "zed", "discord" ]

            [wallpaper]
            directory = "/home/dice/Pictures"

                [wallpaper.default]
                path = "/home/dice/Pictures/Wallpapers/nord/thumb-1920-652708.jpg"

                [wallpaper.last]
                path = "/home/dice/Pictures/Wallpapers/nord/thumb-1920-652708.jpg"

                [wallpaper.monitors.eDP-1]
                path = "/home/dice/Pictures/Wallpapers/nord/thumb-1920-652708.jpg"

            [weather]
            address = "Hanoi"

            [widget.clock]
            format = "{:%D %H:%M}"

            [widget.recorder]
            type = "noctalia/screen_recorder:recorder"

            [widget.workspaces]
            hide_when_empty = true
          minimal = true
          '';
      };
    };
  };
}

{
  hjem.users = {
    dice = {
      # enable = true; # This is not necessary, since enable is 'true' by default
      user = "dice"; # this is the name of the user
      directory = "/home/dice"; # where the user's $HOME resides
      files = {
        ".config/helix/config.toml".text = ''
          theme = "noctalia"
          [editor]
          line-number = "relative"
          [editor.file-picker]
          hidden = true
          [editor.whitespace.render]
          space = "all"
          tab = "all"
          newline = "none"
        '';
        ".config/helix/languages.toml".text = ''
            [language-server.ccls]
            command = "ccls"

            [[language]]
            name = "c"
            language-servers = ["ccls"]

            [language-server.superhtml]
            command = "superhtml"

            [[language]]
            name = "html"
            language-servers = ["superhtml"]
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
     };
    };
  };
}

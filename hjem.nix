{
  hjem.users = {
    dice = {
      # enable = true; # This is not necessary, since enable is 'true' by default
      user = "dice"; # this is the name of the user
      directory = "/home/dice"; # where the user's $HOME resides
      files = {
        ".config/helix/config.toml" = {
          source = ./symlinkfiles/helix/config.toml;
          type = "symlink";
        };
         ".config/helix/languages.toml" = {
           source = ./symlinkfiles/helix/languages.toml;
           type = "symlink";
         };
      };
    };
  };
}

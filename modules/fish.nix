{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    shellAliases = {
      lazerapp = "DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1 ~/appimage/osu.AppImage";
      todo = "~/builds/tuxedo/target/release/tuxedo ~/todo.txt";
    };
  };
  # Set fish as the default shell for your user
  users.users.dice = {
    shell = pkgs.fish;
  };
}

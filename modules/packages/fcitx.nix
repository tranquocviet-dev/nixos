{ pkgs, ... }:
{
	i18n.inputMethod = {
		enable = true;
		type = "fcitx5";
		fcitx5.addons = with pkgs; [
			fcitx5-gtk
			kdePackages.fcitx5-configtool # GUI Config Tool
			# Addons for your specific language:
			# fcitx5-chinese-addons  # For Pinyin/Table input
			# fcitx5-mozc            # For Japanese
			qt6Packages.fcitx5-unikey # For Vietnamese
			# fcitx5-rime            # For Rime
		];
	};
}

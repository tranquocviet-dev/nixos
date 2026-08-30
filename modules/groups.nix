{ self, ... }: {
	flake.nixosModules.group-base = { ... }: {
		imports = (with self.nixosModules; [
			fonts
			fish
			nh
			nix-ld
			nixsettings
			nvf
			polkit
			portal
			networking
		]);
	};
	flake.nixosModules.group-inputs = { ... }: {
		imports = (with self.nixosModules; [
			inputs-noctalia
			inputs-osu
		]);
	};
	flake.nixosModules.group-packages = { ... }: {
		imports = (with self.nixosModules; [
			packages-misc
			packages-fcitx
			packages-general
			packages-file-manager
		]);
	};
	flake.nixosModules.group-services = { ... }: {
		imports = (with self.nixosModules; [
			services-otd
			services-sudo
			services-general
		]);
	};
}

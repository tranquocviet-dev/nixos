{ lib, moduleLocation, ... }:
{
	options.flake.homeManagerModules = lib.mkOption {
		type = lib.types.lazyAttrsOf lib.types.deferredModule;
		default = { };
		description = ''
			Home Manager modules. Each attribute is a module usable in
			`home-manager.sharedModules` or via `imports`.
		'';
	};
}
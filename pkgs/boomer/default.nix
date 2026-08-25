{
	lib,
	stdenv,
	callPackage,
	fetchFromGitHub,
	makeWrapper,
	pkg-config,
	libX11,
	libXrandr,
	libXext,
	libGL,
	libGLU,
	freeglut,
}:
let
	nim_1_0 = callPackage ./overlay/nim_1_0.nix { };

	nimX11 = fetchFromGitHub {
		owner = "nim-lang";
		repo = "x11";
		rev = "master";
		hash = "sha256-jBNsv8meDvF2ySKewbA+rF2XS+gqydZUl1xhEevD15o";
	};

	nimOpengl = fetchFromGitHub {
		owner = "nim-lang";
		repo = "opengl";
		rev = "master";
		hash = "sha256-v3bMDobYQZqX0anBFIUfZx5q5/vxTHO6PDtKQlf5mgU";
	};
in
stdenv.mkDerivation rec {
	pname = "boomer";
	version = "0.0.1";

	src = ./.;

	nativeBuildInputs = [
		pkg-config
		nim_1_0
		makeWrapper
	];

	buildInputs = [
		libX11
		libXrandr
		libXext
		libGL
		libGLU
		freeglut
	];

	buildPhase = ''
				runHook preBuild
				nim c -d:release \
					--path:${nimX11} \
					--path:${nimOpengl}/src \
			--nimcache:$TMPDIR/nimcache \
					--out:boomer \
					src/boomer.nim
				runHook postBuild
			'';

	installPhase = ''
				runHook preInstall
				mkdir -p $out/bin
				cp boomer $out/bin/
				wrapProgram $out/bin/boomer \
					--prefix LD_LIBRARY_PATH : "/run/opengl-driver/lib:${lib.makeLibraryPath buildInputs}"
				runHook postInstall
			'';
}

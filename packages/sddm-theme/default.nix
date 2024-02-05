{ pkgs }:

let
  imgLink = "https://raw.githubusercontent.com/arclight443/dotfiles/main/wallpaper/asian_brown_flycatcher_02.jpg";

  image = pkgs.fetchurl {
    url = imgLink;
    sha256 = "1yjhj7w0rylip5v97vmmyvg04980sjvvzfm92giwn57x0wpqnlmf";
  };

in
pkgs.stdenv.mkDerivation {
  name = "sddm-theme";
  src = pkgs.fetchFromGitHub {
    owner = "MarianArlt";
    repo = "sddm-sugar-dark";
    rev = "ceb2c455663429be03ba62d9f898c571650ef7fe";
    sha256 = "0153z1kylbhc9d12nxy9vpn0spxgrhgy36wy37pk6ysq7akaqlvy";
  };
  installPhase = ''
    mkdir -p $out
    cp -R ./* $out/
    cd $out/
    rm Background.jpg
    cp -r ${image} $out/Background.jpg
   '';
}

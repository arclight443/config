{ lib
, python3Packages
, fetchFromGitLab
}:

python3Packages.buildPythonApplication rec {
  pname = "waybar-battery";
  version = "0.0.1";
  pyproject = false;

  src = fetchFromGitLab {
    domain = "git.revreso.de";
    owner = "gigadoc2";
    repo = "waybar-scripts";
    rev = "c60b1cd02b4887a432cdc826af7cf21ebc5bbfb2";
    hash  = "sha256-oR80lBTPgQT4WVjPCEbsaW4LCKwD3cFmUnr1tGsSGUo=";
  };

  propagatedBuildInputs = with python3Packages; [
    pygobject3 
    pydbus
  ];

  installPhase = ''
    mkdir -p $out/bin;
    cp battery.py $out/bin/waybar-battery;
  '';

}

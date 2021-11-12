{ lib, stdenv, fetchFromGitHub}:

stdenv.mkDerivation {
  pname   = "bqn-fonts";
  version = "0.1";

  src = fetchFromGitHub {
    owner  = "mlochbaum";
    repo   = "BQN";
    rev    = "fffc462cdbac2947cef88e0637d5b50faa1fb041";
    sha256 = "0bkhg6yiqabxgiwhvkawsbgx831qhad31aw02fh2fgf949m3zd9w";
  };

  installPhase = "install -m444 -Dt $out/share/fonts/truetype docs/*.ttf";

  meta = with lib; {
    homepage    = "https://mlochbaum.github.io/BQN/";
    description = "BQN fonts";
    license     = with licenses; [ isc ];
    platforms   = platforms.all;
    maintainers = with maintainers; [ doyougnu ];
  };
}

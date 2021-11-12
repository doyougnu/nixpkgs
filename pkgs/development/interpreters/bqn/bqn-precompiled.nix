{ stdenv, fetchFromGitHub, clang, lib
, avxSupport ? stdenv.hostPlatform.avxSupport
}:
let bqn-bytecode =
stdenv.mkDerivation rec {
  pname = "bqn-bytecode";
  version = "0.1";
  src = fetchFromGitHub {
    owner = "dzaima";
    repo = "CBQN";
    rev = "4d23479cdbd5ac6eb512c376ade58077b814b2b7";
    sha256 = "1il6pxbllf4rs0wf2s6q6h72m3p1d6ymgsllpkmadnw1agif0fri";
    name = "cbqn-bytecode";
  };

  doCheck = false;

  buildPhase = ''
    mkdir -p $out
  '';

  installPhase = ''
    cp -r src/gen/compiler  $out/compiler
    cp -r src/gen/formatter $out/formatter
    cp -r src/gen/runtime0  $out/runtime0
    cp -r src/gen/runtime1  $out/runtime1
    cp -r src/gen/src       $out/src
  '';
};
    in bqn-bytecode

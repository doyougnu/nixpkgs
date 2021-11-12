{ stdenv, fetchFromGitHub, clang, lib, readline, libedit, bc
, avxSupport ? stdenv.hostPlatform.avxSupport, bqn-bytecode
}:

stdenv.mkDerivation rec {
  pname = "bqn";
  version = "0.1";
  src = fetchFromGitHub {
    owner = "dzaima";
    repo = "CBQN";
    rev = "f50b8ab503d05cccb6ff61df52f2625df3292a9e";
    sha256 = "0nyvjbczdrnnndjzam06kqzq16bwi9lk1iirv57jyq8aa9fyh557";
    name = "cbqn";
  };

  buildInputs = [ clang readline libedit bc bqn-bytecode ];
  platform =
    if (stdenv.isAarch32 || stdenv.isAarch64) then "raspberry" else
    if stdenv.isLinux then "linux" else
    if stdenv.isDarwin then "darwin" else
    "unknown";
  variant = if stdenv.isx86_64 && avxSupport then "avx" else "";

  preBuild = ''
    cp -r ${bqn-bytecode}/*  src/gen

    ## remove references to bytecode in installer
    ## these are provided by nix in bqn-bytecode
    sed -i makefile -e "s/.*git.*//"
  '';

  # TODO get tests working
  doCheck = false;

  checkPhase = ''
    sed -i test.bqn - e "1 s/env dbqn/BQN/"
    cat test.bqn
    sed -i precompiled.bqn - e "1 s/env dbqn/BQN/"
    head test.bqn
    ./test.bqn mlochbaum/BQN -s prim > SP; time ./BQN<SP>/dev/null
    ./precompiled.bqn mlochbaum/BQN "$PATH" '2+2'
  '';

  installPhase = ''
    mkdir -p $out/bqn  $out/bin
    mv BQN $out/bqn/BQN
    ln -s $out/bqn/BQN $out/bin/BQN
  '';

  meta = with lib; {
    description = "BQN: finally, an APL for your flying saucer";
    maintainers = with maintainers; [ doyougnu ];
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
    homepage = "https://mlochbaum.github.io/BQN/";
  };
}

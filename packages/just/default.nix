{
  pkgs,
  lib,
  ...
}:
pkgs.stdenv.mkDerivation rec {
  pname = "just-with-deps";
  version = "1.0";

  nativeBuildInputs = [pkgs.makeWrapper pkgs.pkg-config];

  unpackPhase = "true";
  buildPhase = "true";
  postInstall = ''
    mkdir -p $out/bin
    ln -s ${pkgs.just}/bin/just $out/bin/just-with-deps
    wrapProgram $out/bin/just-with-deps \
      --prefix PATH : ${lib.makeBinPath [pkgs.home-manager pkgs.just pkgs.bitwarden-cli pkgs.gh pkgs.git]}
  '';

  meta = with pkgs.lib; {
    description = "just with bitwarden-cli and gh as dependencies";
    license = licenses.mit;
    maintainers = with maintainers; [];
  };
}

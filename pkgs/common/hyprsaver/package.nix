{
  fetchFromGithub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "hyprsaver";
  version = "v0.4.4";
  src = fetchFromGithub {
    owner = "maravexa";
    repo = pname;
    rev = version;
    sha256 = "74b3acd601480a38e7745ac12116581d590bb237";
  };

  cargoSha256 = "AAAAAAAAAAAAA";

}

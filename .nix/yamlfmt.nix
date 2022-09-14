{
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  name = "yamlfmt";
  version = "0.3.0";

  src = fetchFromGitHub {
    name = "${name}-${version}-source";
    owner = "google";
    repo = "yamlfmt";
    rev = "v${version}";
    hash = "sha256-N02xJOMG9rQKBtmVzqykGq+RhVauEBAy2/72xjGN55g=";
  };

  vendorHash = "sha256-z91xL1R7l1o5mHKZtantuLzFi+MZmaOvsYI+//ijJkU=";
}

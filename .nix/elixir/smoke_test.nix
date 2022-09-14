{
  mixRelease,
  self,
  fetchMixDeps,
}:

let inherit  (self.packages.x86_64-linux) elixir erlang; in

(mixRelease.override {inherit  elixir;}) rec {
  pname = "smoke_test";
  version = "0.1.0";

  src = "${self}/elixir/00_smoke_test";

  mixFodDeps = (fetchMixDeps.override {inherit  elixir;}) {
    pname = "mix-deps-${pname}";
    inherit version src;
    sha256 = "sha256-MUd+v3IpQxcxQ32mvqaxSexVorjJzQlLmxozJB3lmtY=";
  };

  preFixup = ''
    # strip debug symbols to avoid hardreferences to "foreign" closures actually
    # not needed at runtime, while at the same time reduce size of BEAM files.
    erl -noinput -eval 'lists:foreach(fun(F) -> io:format("Stripping ~p.~n", [F]), beam_lib:strip(F) end, filelib:wildcard("'"$out"'/**/*.beam"))' -s init stop
  '';

  disallowedReferences = [erlang];
}

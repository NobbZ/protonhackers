pkgs: let
  beamPkgs = with pkgs.beam_minimal; packagesWith interpreters.erlangR25;
  erlang = beamPkgs.erlang;
  elixir = beamPkgs.elixir_1_14;
in {inherit erlang elixir beamPkgs;}

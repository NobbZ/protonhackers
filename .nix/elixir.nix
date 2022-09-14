{
  elixir,
  erlang,
  glibcLocales,
  inotify-tools,
  lib,
  mkShell,
  stdenv,
  self,
}: let
  inherit (lib) optionalAttrs;
  inherit (stdenv) isLinux;
in
  mkShell {
    packages = [elixir inotify-tools];
    inputsFrom = [self.devShells.x86_64-linux.default];

    LANG = "en_US.UTF-8";

    ERL_INCLUDE_PATH = "${erlang}/lib/erlang/usr/include";
  }
  // optionalAttrs isLinux {
    LOCALE_ARCHIVE = "${glibcLocales}/lib/locale/locale-archive";
  }

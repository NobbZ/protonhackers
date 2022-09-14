{
  mkShell,
  nil,
  yamlfmt,
}:
mkShell {
  packages = [nil yamlfmt];
}

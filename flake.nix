{
  description = "Typst flake";


  outputs = { self, nixpkgs }:
    let 
      pkgs = import nixpkgs{system = sys;};
      sys = "x86_64-linux";
      name = "ethics_paper";

    in {
      packages.${sys}.default = pkgs.stdenv.mkDerivation {
        name = "resume";
        src = ./.;
        buildInputs = [
          pkgs.typst
        ];
        installPhase = ''
          mkdir -p $out
          ${pkgs.typst}/bin/typst compile resume.typ
          mv ${name}.pdf $out/
          '';
      };

    devShells.${sys}.default = pkgs.mkShell {
      name = "typst_shell";
      shellHook = ''
      touch ${name}.typ
      sh -c "python -m http.server 2>&1" > /dev/null&
      '';
      buildInputs = [
        pkgs.typst
      ];
      packages = [
      pkgs.typst-lsp
      pkgs.typst-fmt
     ];

    };

 };
}

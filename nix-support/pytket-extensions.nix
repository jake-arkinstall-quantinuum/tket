self: super:
{
  pytket-extensions = {
    qir = let
      sha256 = sha256:FL001l0o6yK062Ei+94Yqoc0TPhuoGC9F+agO2x8Doo=;
    in
      super.python3.pkgs.buildPythonPackage {
        pname = "pytket-qir";
        version = "0.4.0b";
        src = super.fetchFromGitHub rec{
          owner = "CQCL";
          repo = "pytket-qir";
          rev = "6221eccca8bfe511a5e69d893e39c66ba39fbdfe";
          # this revision is not yet tagged, but supports pyqir 0.9.0.
          # The original dependency, pyqir 0.6.2, has proven difficult
          # to build within Nix.
          inherit sha256;
        };
        propagatedBuildInputs = with super.python3Packages; [
          self.pytket
          self.pyqir
        ];
        checkInputs = with super.python3Packages; [
          pytest
        ];
        checkPhase = ''
          export HOME=$TMPDIR;
          cd tests;
          python -m pytest -s .
        '';
      };
    quantinuum = let
      version = "v0.25.0";
      sha256 = sha256:SNz6R+tVNqSbCYqOJKH+xddFYrtYRvJGip6AKc7/LWk=;
    in
      super.python3.pkgs.buildPythonPackage {
      pname = "pytket-quantinuum";
      inherit version;
      src = super.fetchFromGitHub rec{
        owner = "CQCL";
        repo = "pytket-quantinuum";
        rev = version;
        inherit sha256;
      };
      propagatedBuildInputs = with super.python3Packages; [
        msal
        nest-asyncio
        websockets
        types-requests
        setuptools
        self.pytket-extensions.qir
        self.pytket
      ];
      checkInputs = with super.python3Packages; [
        pytest
        requests-mock
        hypothesis
        llvmlite
      ];
      checkPhase = ''
        export HOME=$TMPDIR;
        cd tests;
        python -m pytest -s .
      '';
    };
  };
  pytketWithExtensions = extension-getter:
    super.python3.withPackages(_: [super.pytket] ++ (extension-getter self.pytket-extensions));
}

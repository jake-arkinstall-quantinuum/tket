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
    aqt = let
      version = "v0.29.0";
      sha256 = sha256:e+QlF/fxXpc9fNJ7RiKO9tQtk0nuC6ko7NbuHfo1rno=;
    in
      super.python3.pkgs.buildPythonPackage {
        pname = "pytket-aqt";
        inherit version;
        format = "pyproject";
        src = super.fetchFromGitHub rec{
          owner = "CQCL";
          repo = "pytket-aqt";
          rev = version;
          inherit sha256;
        };
        propagatedBuildInputs = with super.python3Packages; [
          self.pytket
          self.pydantic-2
          requests
          types-requests
          networkx
          sympy
          poetry-core
        ];
        checkInputs = with super.python3Packages; [
          pytest
          pytest-timeout
          hypothesis
          requests-mock
          numpy
        ];
        checkPhase = ''
          export HOME=$TMPDIR;
          cd tests;
          python -m pytest -s .
        '';
      };
    braket = let
      version = "v0.31.1";
      sha256 = sha256:NjkPPMxQ7mPTCPZHO+drvjHGUmziyjvQockOelPAwJk=;
    in
      super.python3.pkgs.buildPythonPackage {
        pname = "pytket-braket";
        inherit version;
        src = super.fetchFromGitHub rec{
          owner = "CQCL";
          repo = "pytket-braket";
          rev = version;
          inherit sha256;
        };
        propagatedBuildInputs = with super.python3Packages; [
          self.pytket
          self.amazon-braket-sdk
          boto3
        ];
        checkInputs = with super.python3Packages; [
          pytest
          hypothesis
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
    cirq = let
      version = "v0.31.0";
      sha256 = sha256:ad3LuaABvmxbqBo/RTKVT1pSgF8jaU555cGtGEFiacM=;
    in
      super.python3.pkgs.buildPythonPackage {
        pname = "pytket-cirq";
        inherit version;
        src = super.fetchFromGitHub rec{
          owner = "CQCL";
          repo = "pytket-cirq";
          rev = version;
          inherit sha256;
        };
        propagatedBuildInputs = with super.python3Packages; [
          self.pytket
          cirq-core
          cirq-google
          protobuf
        ];
        checkInputs = with super.python3Packages; [
          pytest
          pytest-timeout
          hypothesis
          requests-mock
        ];
        checkPhase = ''
          export HOME=$TMPDIR;
          cd tests;
          python -m pytest -s .
        '';
      };
    iqm = let
      version = "v0.8.0";
      sha256 = sha256:lvBV5WaDs8fNOLFUWoOMlBxnVRV6nysGVaPeM1ueSq0=;
    in
      super.python3.pkgs.buildPythonPackage {
        pname = "pytket-iqm";
        inherit version;
        src = super.fetchFromGitHub rec{
          owner = "CQCL";
          repo = "pytket-iqm";
          rev = version;
          inherit sha256;
        };
        propagatedBuildInputs = with super.python3Packages; [
          self.pytket
          self.iqm-client
        ];
        checkInputs = with super.python3Packages; [
          pytest
          pytest-timeout
          hypothesis
          requests-mock
          types-requests
        ];
        checkPhase = ''
          export HOME=$TMPDIR;
          cd tests;
          python -m pytest -s .
        '';
      };
 
    # For Later. See discussion in ./third-party-python-packages.nix
    #
    # cutensornet = let
    #   version = "v0.3.0";
    #   sha256 = sha256:LMBAJkMBiaHTH4T5X7X0qr+Op4ANss6Avg91fvG9XF8=;
    # in
    #   super.python3.pkgs.buildPythonPackage {
    #     pname = "pytket-cutensornet";
    #     inherit version;
    #     src = super.fetchFromGitHub rec{
    #       owner = "CQCL";
    #       repo = "pytket-cutensornet";
    #       rev = version;
    #       inherit sha256;
    #     };
    #     propagatedBuildInputs = with super.python3Packages; [
    #       self.pytket
    #       self.cuquantum
    #     ];
    #     checkInputs = with super.python3Packages; [
    #       pytest
    #       pytest-lazy-fixture
    #       requests-mock
    #       hypothesis
    #       llvmlite
    #     ];
    #     checkPhase = ''
    #       export HOME=$TMPDIR;
    #       cd tests;
    #       python -m pytest -s .
    #     '';
    #   };
  };
  pytketWithExtensions = extension-getter:
  let
    extensions = extension-getter self.pytket-extensions;
  in
    super.python3.withPackages(_: [super.pytket] ++ extensions);
}

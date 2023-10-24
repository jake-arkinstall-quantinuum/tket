self: super: {
  pybind11_json = super.stdenv.mkDerivation {
    name = "pybind11_json";
    src = super.fetchFromGitHub {
      owner = "pybind";
      repo = "pybind11_json";
      rev = "0.2.13";
      sha256 = sha256:Kl/QflV2bBoH72/LW03K8JDlhBF+DYYXL47A5s1nmTw=;
    };
    nativeBuildInputs = [ super.cmake ];
    buildInputs = [ super.python3Packages.pybind11 super.nlohmann_json ];
  };
  qwasm = super.python3.pkgs.buildPythonPackage {
    name = "qwasm";
    src = super.fetchFromGitHub {
      owner = "CQCL";
      repo = "qwasm";
      rev = "35ebe1e2551449d97b9948a600f8d2e4d7474df6";
      sha256 = sha256:g/QA5CpAR3exRDgVQMnXGIH8bEGtwGFBjjSblbdXRkU=;
    };
  };
  lark-parser = super.python3.pkgs.buildPythonPackage {
    pname = "lark-parser";
    version = "0.12.0";
    src = super.fetchFromGitHub {
      owner = "lark-parser";
      repo = "lark";
      rev = "refs/tags/0.12.0";
      hash = sha256:zcMGCn3ixD3dJg3GlC/ijs+U1JN1BodHLTXZc/5UR7Y=;
    };
    doCheck = false;
  };
  types-pkg_resources = let
    pname = "types-pkg_resources";
    version = "0.1.3";
  in super.python3.pkgs.buildPythonPackage {
    inherit pname version;
    src = super.fetchPypi {
      inherit pname version;
      sha256 = sha256:g0qbjT2+o0NWL9mdXTNZpyb2v503M7zNK08wlvurna4=;
    };
    doCheck = false;
  };
  pydantic-2 = super.python3.pkgs.buildPythonPackage rec{
    pname = "pydantic";
    version = "2.1.1";
    format = "wheel";
    src = super.fetchPypi{
      inherit pname version format;
      python = "py3";
      dist = "py3";
      sha256 = sha256:Q72/NZ1jBMV6/aFcK5V5cpW3ApSAgtTCOFHOdS8h2nA=;
    };
    propagatedBuildInputs = with super.python3Packages; [
      pydantic-core
      annotated-types
    ];

  };
  pyqir = super.python3.pkgs.callPackage ./pyqir.nix {
    llvm = super.pkgs.llvm_14;
  };
  antlr4_9_2 = (super.callPackage ./antlr4_9_2.nix {}).antlr4_9_2;
  antlr4_9_2-python3-runtime = super.python3Packages.buildPythonPackage rec {
    pname = "antlr4-python3-runtime";
    inherit (self.antlr4_9_2.runtime.cpp) version src;
    sourceRoot = "source/runtime/Python3";
    checkPhase = ''
      cd test*
      python3 run.py
    '';
  };
  openqasm3 = super.python3.pkgs.buildPythonPackage rec{
    pname = "openqasm3";
    version = "0.5.0";
    format = "wheel";
    src = super.fetchPypi{
      inherit pname version format;
      python = "py3";
      dist = "py3";
      sha256 = sha256:QJkawFe548II0bNCQrCq2KO5hA3wM1plKx5OQkiTexw=;
    };
    extras = ["parser"];
    propagatedBuildInputs = with super.python3Packages; [
      self.antlr4_9_2-python3-runtime
    ];
  };


  openpulse = super.python3.pkgs.buildPythonPackage rec{
    pname = "openpulse";
    version = "0.5.0";
    format = "wheel";
    src = super.fetchPypi{
      inherit pname version format;
      python = "py3";
      dist = "py3";
      sha256 = sha256:yRtpYzNmOB8/28DJvow3wRSy2ORp9mf/mw94Yy4Aw5U=;
    };
    propagatedBuildInputs = with super.python3Packages; [
      self.openqasm3
    ];
  };

  oqpy = super.python3.pkgs.buildPythonPackage rec{
    pname = "oqpy";
    version = "0.3.3";
    format = "wheel";
    src = super.fetchPypi{
      inherit pname version format;
      python = "py3";
      dist = "py3";
      sha256 = sha256:DE9BaJ0qPrTihj7747MmcBPiHVJfEP/TFLin4EylMto=;
    };
    propagatedBuildInputs = with super.python3Packages; [
      self.openpulse
      mypy-extensions
    ];
  };
  amazon-braket-schemas = super.python3.pkgs.buildPythonPackage rec{
    pname = "amazon_braket_schemas";
    version = "1.19.1.post0";
    format = "wheel";
    src = super.fetchPypi {
      inherit pname version format;
      python = "py3";
      dist = "py3";
      sha256 = sha256:idynQDQulZR/GzivaJ/xuk0q1xmmHbl66CcgISNPQYY=;
    };
    propagatedBuildInputs = with super.python3Packages; [
      pydantic
    ];
  };
  amazon-braket-default-simulator = super.python3.pkgs.buildPythonPackage rec{
    pname = "amazon_braket_default_simulator";
    version = "1.20.1";
    format = "wheel";
    src = super.fetchPypi {
      inherit pname version format;
      python = "py3";
      dist = "py3";
      sha256 = sha256:tlRSykjNyO/1jZjiyy/pevQHtcVK5K/l1rIRMkQvpIU=;
    };
    propagatedBuildInputs = with super.python3Packages; [
      opt-einsum
    ];
  };

  amazon-braket-sdk = super.python3.pkgs.buildPythonPackage rec{
    pname = "amazon_braket_sdk";
    version = "1.59.1";
    format = "wheel";
    src = super.fetchPypi {
      inherit pname version format;
      python = "py3";
      dist = "py3";
      sha256 = sha256:y5+bBm0vPlt3uiH7i3HWpWxRkpemcKn9j0w78WtAlZg=;
    };
    propagatedBuildInputs = with super.python3Packages; [
      self.amazon-braket-schemas
      self.amazon-braket-default-simulator
      self.oqpy
      backoff
      boltons
      cloudpickle
    ];
  };

  # ForLater: Figure out cuda support.
  # -----------------------
  # To the best of my knowledge this would require
  # modifying pkgs.config.cudaSupport and pkgs.config.allowUnfree.
  # This seems somewhat invasive and could potentially
  # break builds on non-cuda-enabled devices.
  #
  # As such, this is not supported just yet.
  # -----------------------
  #
  # cuquantum = super.python3.pkgs.buildPythonPackage rec {
  #   pname = "cuquantum";
  #   version = "23.06.0";
  #   format = "pyproject";
  #   src = super.fetchFromGitHub {
  #     owner = "NVIDIA";
  #     repo = pname;
  #     rev = "v${version}";
  #     sha256 = sha256:Rym0d0dFZI+IPOEP4ZQ9kfEdjKtWRzL14R2kqKj02DA=;
  #   };
  #   unpackPhase = ''
  #     ls $src;
  #     cp -r $src/python/* .
  #   '';
  #   propagatedBuildInputs = with super.python3Packages; [
  #     setuptools
  #     packaging
  #   ];
  # };
}

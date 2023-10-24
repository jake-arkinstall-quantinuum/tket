# adapted from
# https://github.com/NixOS/nixpkgs/pull/237604/files
{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, rustPlatform
, libxml2
, llvm # LLVM version provided must strictly match pyqir support list
}:
let
  llvm-v-major = lib.versions.major llvm.version;
  llvm-v-minor = builtins.substring 0 1 (lib.versions.minor llvm.version);
in
buildPythonPackage rec {
  pname = "pyqir";
  version = "0.9.0";
  format = "pyproject";
  disabled = pythonOlder "3.7";
  src = fetchFromGitHub {
    owner = "qir-alliance";
    repo = pname;
    rev = "v${version}";
    sha256 = sha256:oqkv6gOIazwkH81GomCXdmHXlG008KdK3b9+hUGCtmE=;
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = sha256:bTQm8cpvoTfa8+N38UB01AZl1LZMXsMXYbDa6f0Lj9U=;
  };

  buildAndTestSubdir = "pyqir";

  nativeBuildInputs = with rustPlatform; [ cargoSetupHook maturinBuildHook ];

  buildInputs = [ llvm libxml2.dev ];

  maturinBuildFlags = "-F llvm${llvm-v-major}-${llvm-v-minor}";

  preConfigure = ''
    export LLVM_SYS_${llvm-v-major}${llvm-v-minor}_PREFIX=${llvm.dev}
  '';

  pythonImportsCheck = [ "pyqir" ];

  passthru.llvm = llvm;

  meta = with lib; {
    description = "API for parsing and generating Quantum Intermediate Representation (QIR)";
    homepage = "https://github.com/qir-alliance/pyqir";
    license = licenses.mit;
    maintainers = with maintainers; [ evilmav ];
  };
}

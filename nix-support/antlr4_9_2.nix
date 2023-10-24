{ lib, stdenv, fetchurl, jre
, fetchFromGitHub, cmake, ninja, pkg-config

# darwin only
, CoreFoundation ? null

# ANTLR 4.8 & 4.9
, libuuid

# ANTLR 4.9
, utf8cpp }:

let

  mkAntlr = {
    version, sourceSha256, jarSha256,
    extraCppBuildInputs ? [],
    extraCppCmakeFlags ? []
  }: rec {
    source = fetchFromGitHub {
      owner = "antlr";
      repo = "antlr4";
      rev = version;
      sha256 = sourceSha256;
    };

    antlr = stdenv.mkDerivation {
      pname = "antlr";
      inherit version;

      src = fetchurl {
        url = "https://www.antlr.org/download/antlr-${version}-complete.jar";
        sha256 = jarSha256;
      };

      dontUnpack = true;

      installPhase = ''
        mkdir -p "$out"/{share/java,bin}
        cp "$src" "$out/share/java/antlr-${version}-complete.jar"

        echo "#! ${stdenv.shell}" >> "$out/bin/antlr"
        echo "'${jre}/bin/java' -cp '$out/share/java/antlr-${version}-complete.jar:$CLASSPATH' -Xmx500M org.antlr.v4.Tool \"\$@\"" >> "$out/bin/antlr"

        echo "#! ${stdenv.shell}" >> "$out/bin/antlr-parse"
        echo "'${jre}/bin/java' -cp '$out/share/java/antlr-${version}-complete.jar:$CLASSPATH' -Xmx500M org.antlr.v4.gui.Interpreter \"\$@\"" >> "$out/bin/antlr-parse"

        echo "#! ${stdenv.shell}" >> "$out/bin/grun"
        echo "'${jre}/bin/java' -cp '$out/share/java/antlr-${version}-complete.jar:$CLASSPATH' org.antlr.v4.gui.TestRig \"\$@\"" >> "$out/bin/grun"

        chmod a+x "$out/bin/antlr" "$out/bin/antlr-parse" "$out/bin/grun"
        ln -s "$out/bin/antlr"{,4}
        ln -s "$out/bin/antlr"{,4}-parse
      '';

      inherit jre;

      passthru = {
        inherit runtime;
        jarLocation = "${antlr}/share/java/antlr-${version}-complete.jar";
      };

      meta = with lib; {
        description = "Powerful parser generator";
        longDescription = ''
          ANTLR (ANother Tool for Language Recognition) is a powerful parser
          generator for reading, processing, executing, or translating structured
          text or binary files. It's widely used to build languages, tools, and
          frameworks. From a grammar, ANTLR generates a parser that can build and
          walk parse trees.
        '';
        homepage = "https://www.antlr.org/";
        sourceProvenance = with sourceTypes; [ binaryBytecode ];
        license = licenses.bsd3;
        platforms = platforms.unix;
      };
    };

    runtime = {
      cpp = stdenv.mkDerivation {
        pname = "antlr-runtime-cpp";
        inherit version;
        src = source;
        sourceRoot = "source/runtime/Cpp";

        outputs = [ "out" "dev" "doc" ];

        nativeBuildInputs = [ cmake ninja pkg-config ];
        buildInputs =
          lib.optional stdenv.isDarwin CoreFoundation ++
          extraCppBuildInputs;

        cmakeFlags = extraCppCmakeFlags;

        meta = with lib; {
          description = "C++ target for ANTLR 4";
          homepage = "https://www.antlr.org/";
          license = licenses.bsd3;
          platforms = platforms.unix;
        };
      };
    };
  };

in {
  antlr4_9_2 = (mkAntlr {
    version = "4.9.2";
    sourceSha256 = sha256:t9QFvIkqmiNPcMwEDJwPgvTzhI9eIi/I8zEK4QV9+GY=;
    jarSha256 = "";
    extraCppBuildInputs = [ utf8cpp ]
      ++ lib.optional stdenv.isLinux libuuid;
  }).antlr;
}

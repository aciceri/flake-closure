{
  lib,
  stdenv,
  writeTextFile,
  writeReferencesToFile,
  ...
}: {
  flake,
  system ? stdenv.system,
  buildtime ? false,
  outputs ? [
    "packages"
  ],
  ...
}: let
  drvsFromOutput = outputName: builtins.attrValues flake.outputs.${outputName}.${system};
  drvsFileFromOutput = outputName: writeTextFile {
    name = "flake-drvs-${outputName}-${system}";
    text = lib.concatMapStringsSep "\n" (drv: "${drv}") (drvsFromOutput outputName);
  };
  finalDrv = lib.concatMapStringsSep "\n" (outputName:
     "${drvsFileFromOutput outputName}"
  ) outputs;
in writeReferencesToFile (if buildtime then finalDrv.drvPath else finalDrv)

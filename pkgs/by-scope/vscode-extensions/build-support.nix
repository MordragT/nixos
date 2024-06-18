{
  lib,
  vscode-utils,
}: {
  mkVsixPkgsFromList = list: lib.mergeAttrsList (builtins.map (ext: {"${ext.publisher}"."${ext.name}" = vscode-utils.extensionFromVscodeMarketplace ext;}) list);
}

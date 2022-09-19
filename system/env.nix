{ ... }:
{
  environment = {
    variables = {
      EDITOR = "hx";
    };
    interactiveShellInit = ''
      alias comojit='comoji commit'
    '';
  };
}

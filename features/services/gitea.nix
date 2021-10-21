{ pkgs, config, lib, ... }:
{
  services.gitea = {
    enable = true;
    database.type = "sqlite3";
    domain = "localhost";
    rootUrl = "http://localhost:3000/";
    httpAddress = "0.0.0.0";
    httpPort = 3000;      
  };
}

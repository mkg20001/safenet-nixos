{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.SAC;
  sc = text: let
    sc = pkgs.writeShellScriptBin "sac-srv-helper" text;
  in
    "${sc}/bin/sac-srv-helper";
in
{
  options = {
    services.SAC = {
      enable = mkEnableOption "Safenet Authentication Client";
    };
  };
  
  config = mkIf (cfg.enable) {
    services.pcscd = {
      enable = true;
      plugins = with pkgs; [ safenetauthenticationclient ];
    };

    services.udev.packages = [
      pkgs.safenetauthenticationclient
    ];
    
    systemd.services.pcscd.environment.LD_LIBRARY_PATH = "${lib.makeLibraryPath [ pkgs.openssl.out ]}";

   systemd.services.sacsrv = {
     enable = true;
     description = "Safenet Authentication Client";
     serviceConfig = {
       Type = "forking";
       ExecStart = sc ''
         ${pkgs.safenetauthenticationclient}/bin/SACSrv --background &
         echo $! > /var/run/SACSrv.pid
       '';
       ExecStop = sc ''
         kill -9 $(cat /var/run/SACSrv.pid)
         rm -f /var/run/SACSrv.pid
         rm -f /tmp/SACSrv
       '';
       Restart = "on-failure";
       PIDFile = "/var/run/SACSrv.pid";
     };
     requires = [ "pcscd.service" ];
     wantedBy = [ "multi-user.target" ];
   };
   
   
   
   environment.systemPackages = with pkgs; [
     safenetauthenticationclient
   ];
  };
}

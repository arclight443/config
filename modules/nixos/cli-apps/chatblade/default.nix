inputs@{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.cli-apps.chatblade;
  sopsFile = lib.snowfall.fs.get-snowfall-file "secrets/azure-openai.yaml";
  owner = config.users.users.${config.arclight.user.name}.name;
  group = config.users.users.${config.arclight.user.name}.group;

  chatblade-launch = pkgs.writeShellApplication {
    name = "chatblade-launch";
    checkPhase = "";
    runtimeInputs = [];
    text = ''
      export AZURE_OPENAI_ENDPOINT=$(cat /run/user/1000/secrets/azure-openai-endpoint)
      export OPENAI_API_TYPE=azure; export OPENAI_API_BASE=$(cat /run/user/1000/secrets/azure-openai-endpoint)
      export OPENAI_API_KEY=$(cat /run/user/1000/secrets/openai-api-key)
      export OPENAI_API_AZURE_ENGINE=$1

      ${pkgs.kitty}/bin/kitty --class "chatblade-$OPENAI_API_AZURE_ENGINE" -e chatblade -i
    '';
  };

in
{
  options.arclight.cli-apps.chatblade = with types; {
    enable = mkBoolOpt false "Whether or not to enable chatblade.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      chatblade
    ] ++ chatblade-launch;

    sops.secrets = mkIf config.arclight.security.yubikey.enable {
      "azure-openai-endpoint" = { inherit sopsFile owner group; };
      "openai-api-azure-engine" = { inherit sopsFile owner group; };
      "openai-api-key" = { inherit sopsFile owner group; };
    };

  };
}

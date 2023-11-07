inputs@{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.cli-apps.chatblade;
  sopsFile = lib.snowfall.fs.get-snowfall-file "secrets/azure-openai.yaml";
  owner = config.users.users.${config.arclight.user.name}.name;
  group = config.users.users.${config.arclight.user.name}.group;

in
{
  options.arclight.cli-apps.chatblade = with types; {
    enable = mkBoolOpt false "Whether or not to enable chatblade.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      chatblade
    ];
    
    sops.secrets = mkIf config.arclight.security.yubikey.enable {
      "openai-api-base" = { inherit sopsFile owner group; };
      "openai-api-azure-engine" = { inherit sopsFile owner group; };
      "openai-api-key" = { inherit sopsFile owner group; };
    };

    arclight.home.extraOptions = {

      programs.zsh.initExtra = mkIf config.arclight.security.yubikey.enable ''
        if [[ -o interactive ]]; then
          export OPENAI_API_TYPE=azure;
          export OPENAI_API_BASE=$(cat /run/secrets/openai-api-base)
          export OPENAI_API_AZURE_ENGINE=$(cat /run/secrets/openai-api-azure-engine)
          export OPENAI_API_KEY=$(cat /run/secrets/openai-api-key)
        fi
      '';
    };

  };
}

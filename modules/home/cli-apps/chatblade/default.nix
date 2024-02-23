inputs@{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.cli-apps.chatblade;
  sopsFile = lib.snowfall.fs.get-snowfall-file "secrets/azure-openai.yaml";

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
    home.packages = with pkgs;[
      chatblade
    ];

    sops.gnupg.home = "~/.gnupg";
    sops.gnupg.sshKeyPaths = [];

    sops.defaultSymlinkPath = "/run/user/1000/secrets";
    sops.defaultSecretsMountPoint = "/run/user/1000/secrets.d";

    sops.secrets = {
      "azure-openai-endpoint" = { inherit sopsFile owner group; };
      "openai-api-azure-engine" = { inherit sopsFile owner group; };
      "openai-api-key" = { inherit sopsFile owner group; };
    };

    programs.zsh.initExtra = ''
      if [[ -o interactive ]]; then
        export OPENAI_API_TYPE=azure;
        export OPENAI_API_BASE=$(cat /run/secrets/azure-openai-endpoint)
        export OPENAI_API_AZURE_ENGINE=$(cat /run/secrets/openai-api-azure-engine)
        export OPENAI_API_KEY=$(cat /run/secrets/openai-api-key)
      fi
    '';

  };
}

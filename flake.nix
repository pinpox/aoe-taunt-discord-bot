{
  description = "Discord bot for Age of Empires II taunts";

  # Nixpkgs / NixOS version to use.
  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let

      # System types to support.
      supportedSystems =
        [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system:
        import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
        });
    in
    {

      # A Nixpkgs overlay.
      overlays.default = final: prev: {
        aoe-taunt-discord-bot = with final;
          buildGoModule {

            pname = "aoe-taunt-discord-bot";
            version = "v1.0";
            src = ./.;
            vendorSha256 = "sha256-XfFuOCT2BSEXSjPA1yxWSC2qSS58f8F59hqI9vId66w=";

            installPhase = ''
              mkdir -p $out/bin
              cp $GOPATH/bin/aoe-taunt-discord-bot $out/bin/aoe-taunt-discord-bot
              cp -r taunts $out/bin/taunts
            '';

            meta = with lib; {
              description = "Discord bot for Age of Empires II taunts";
              homepage = "https://github.com/pinpox/aoe-taunt-discord-bot";
              license = licenses.gpl3;
              maintainers = with maintainers; [ pinpox ];
            };
          };
      };

      # Package
      packages = forAllSystems (system: {
        inherit (nixpkgsFor.${system}) aoe-taunt-discord-bot;
        default = self.packages.${system}.aoe-taunt-discord-bot;
      });

      # Nixos module
      nixosModules.aoe-taunt-discord-bot = { pkgs, lib, config, ... }:
        with lib;
        let cfg = config.services.aoe-taunt-discord-bot;
        in {

          options.services.aoe-taunt-discord-bot = {
            # Optios for configuration
            enable = mkEnableOption "AoE II Taunt Bot";
            discordTokenFile = mkOption {
              type = types.path;
              default = null;
              example = "/path/to/token";
              description = ''File containing Discord token with appropiate permissions'';
            };
          };

          config = mkIf cfg.enable {

            nixpkgs.overlays = [ self.overlays.default ];

            # Service
            systemd.services.aoe-taunt-discord-bot = {

              # environment.DISCORD_TOKEN = "$(cat %d/discord_token)";

              wantedBy = [ "multi-user.target" ];
              after = [ "network.target" ];
              description = "Start the AoE II taunt bot";
              serviceConfig = {
                LoadCredential = [ "discord_token:${cfg.discordTokenFile}" ];

                ExecStartPre = "export DISCORD_TOKEN=$(cat $${CREDENTIALS_DIRECTORY}/discord_token)";



                WorkingDirectory = pkgs.aoe-taunt-discord-bot;
                User = "aoe-taunt-discord-bot";
                Group = "aoe-taunt-discord-bot";
                DynamicUser = true;
                ExecStart = "${pkgs.aoe-taunt-discord-bot}/bin/aoe-taunt-discord-bot";
              };
            };

          };
        };
    };
}

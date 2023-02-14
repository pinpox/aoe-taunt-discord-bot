# Age of Empires II taunts Discord Bot

[![status-badge](https://build.lounge.rocks/api/badges/pinpox/aoe-taunt-discord-bot/status.svg)](https://build.lounge.rocks/pinpox/aoe-taunt-discord-bot)

Write taunt number in chat. Get aoe2 taunt

## Usage

Bot expects `DISCORD_TOKEN` environment variable to be set.

```
export DISCORD_TOKEN=XXXXXX
```

The token needs the appropiate permissions, specifically "message content" must
be enabled in the developer console. See [this
issue](https://github.com/bwmarrin/discordgo/issues/1270) for more information.

## NixOS

If you are using NixOS just use the included module.

```nix
services.aoe-taunt-discord-bot = {
  discordTokenFile = "/path/to/your/token";
  enable = true;
}
```

## Credits

Code mostly copied from the [airhorn dicordgo
example](https://github.com/bwmarrin/discordgo/tree/master/examples/airhorn)

Converted using:
https://github.com/bwmarrin/dca

```
curl https://static.wikia.nocookie.net/ageofempires/images/e/e1/Yes.ogg/revision/latest?cb=20170605130608 -o 1.ogg
ffmpeg -i 1.ogg -f s16le -ar 48000 -ac 2 pipe:1 | ~/.go/bin/dca > 1.dca
```

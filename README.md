# Age of Empires II taunts Discord Bot

Write taunt number in chat. Get aoe2 taunt



## Credits

Code mosty copied from the [airhorn dicordgo
example](https://github.com/bwmarrin/discordgo/tree/master/examples/airhorn)

Converted using:
https://github.com/bwmarrin/dca

```
curl https://static.wikia.nocookie.net/ageofempires/images/e/e1/Yes.ogg/revision/latest?cb=20170605130608 -o 1.ogg
ffmpeg -i 1.ogg -f s16le -ar 48000 -ac 2 pipe:1 | ~/.go/bin/dca > 1.dca
```

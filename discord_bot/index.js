import { Client } from "discord.js"
import { MsgHandler } from './util.js'

const client = new Client()
const clientSecret = "<REDACTED>"

client.on("message", msg => {

    MsgHandler(msg);

});

client.login(clientSecret);
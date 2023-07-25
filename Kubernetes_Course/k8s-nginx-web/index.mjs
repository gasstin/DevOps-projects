import express from 'express'
import fetch from 'node-fetch'
import os from 'os'

const app = express()
const Port = 3000

app.get("/", (req, res) => {
    const HiMessage = `Hello from ${os.hostname()}`
    res.send(HiMessage)
})

app.get("/nginx", async (req, res) => {
    const url = 'http://nginx';
    const response = await fetch(url);
    const body = await response.text();
    res.send(body)
})

app.listen(Port, () => {
    console.log(`Web Server is listening at port ${Port}`)
})
import express from 'express'
import os from 'os'

const app = express()
const Port = 3000

app.get("/", (req, res) => {
    const HiMessage = `Hello from ${os.hostname()}`
    res.send(HiMessage)
})

app.listen(Port, () => {
    console.log(`Web Server is listening at port ${Port}`)
})
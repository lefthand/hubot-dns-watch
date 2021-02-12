# hubot-dns-watch

Hubot will watch for DNS changes of specified domains

See [`src/dns-watch.coffee`](src/dns-watch.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-dns-watch --save`

Then add **hubot-dns-watch** to your `external-scripts.json`:

```json
["hubot-dns-watch"]
```

## Sample Interaction

```
user1>> hubot dns watch for example.com
hubot>> I'll post to #your-chat-room when DNS for example.com changes from <address>

user1>> hubot dns watches
hubot>> example.com: <address> 

TIME PASSES...

hubot>> DNS for example.com changed to <new-address>! See global propagation https://www.nslookup.io/example.com

user1>> hubot dns watch for something.example.com
hubot>> I'll post to #current-chat-room when DNS for something.example.com changes from <address>
user1>> hubot end dns watch for somethingexample.com
hubot>> Ending DNS watch for something.example.com 
```

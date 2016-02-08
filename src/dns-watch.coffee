# Description:
#   Upon request, watch domain for DNS changes
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
# dns watch for <domain> 
# dns watches - Returns a list of current watches
# end/stop/cancel dns watch for <domain>
#
# Author:
#   lefthand

schedule = require('node-schedule');
dns = require('dns');

removeWatch = (robot, domain) ->
  delete robot.brain.data.dns_watches[domain];

checkDomain = (robot, domain, watcher) -> 
  dns.lookup domain, (err, addresses, family) -> 
    if addresses != watcher.address
      envelope = user: watcher.user_id, room: watcher.room
      robot.send envelope, "@#{watcher.user_name} DNS for #{domain} changed to #{addresses}! See global propagation: https://www.whatsmydns.net/#A/#{domain}"
      removeWatch robot, domain

module.exports = (robot) ->
  robot.brain.data.dns_watches or= {}

  regex = /dns.+(watch|change|update).* (http(s)?:\/\/)?([^\s/$.?#].[^\s^\/]*)/i
  robot.respond regex, (res) ->
    domain = res.match[4]
    dns.lookup domain, (err, addresses, family) -> 
      watch =
        address: addresses
        user_id: res.message.user.id
        user_name: res.message.user.name
        room: res.message.user.room
      robot.brain.data.dns_watches[domain] = watch
      res.send "I'll post to ##{res.message.user.room} when DNS for #{domain} changes from #{addresses}"
      return

  regex = /dns watches/i
  robot.respond regex, (res) ->
    report = for domain, details of robot.brain.data.dns_watches
      "#{domain}: #{details.address}"
    if report.length > 0
      res.send "```#{report.join("\n")}```"
    else
      res.send "No DNS watches are active."

  regex = /(cancel|stop|end) dns watch.* (http(s)?:\/\/)?([^\s/$.?#].[^\s^\/]*)/i
  robot.respond regex, (res) ->
    domain = res.match[4]
    removeWatch robot, domain
    res.send "Ending DNS watch for #{domain}."

  schedule.scheduleJob '* * * * *', () ->
    for domain, details of robot.brain.data.dns_watches
      checkDomain robot, domain, details
    return


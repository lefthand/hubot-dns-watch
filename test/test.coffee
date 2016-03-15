Helper = require('hubot-test-helper')
chai = require 'chai'

expect = chai.expect

helper = new Helper('../src/*.coffee')

describe 'dns watch', ->
  beforeEach ->
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()

  it 'will watch domain', ->
    @room.user.say('alice', 'dns watch example.com').then =>
      expect(@room.messages).to.eql [
        ['alice', 'dns watch example.com']
        ['hubot', 'I'll post to #room when DNS for example.com changes from 93.184.216.34']
      ]


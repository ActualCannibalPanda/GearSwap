return function(sets)
  sets.idle = require('PLD/Idle.lua')
  sets.tp = require('PLD/TP.lua')
  sets.precast = require('PLD/Precast.lua')
  sets.midcast = require('PLD/Midcast.lua')
  sets.ws = require('PLD/WS.lua')
  sets.ja = require('PLD/JA.lua')
  sets.subjob = require('PLD/Subjob.lua')
  return sets
end

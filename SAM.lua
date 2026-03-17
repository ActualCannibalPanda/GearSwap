return function(sets)
  sets.idle = require('SAM/Idle.lua')
  sets.tp = require('SAM/TP.lua')
  sets.precast = require('SAM/Precast.lua')
  sets.midcast = require('SAM/Midcast.lua')
  sets.ws = require('SAM/WS.lua')
  sets.ja = require('SAM/JA.lua')
  sets.subjob = require('SAM/Subjob.lua')
  return sets
end

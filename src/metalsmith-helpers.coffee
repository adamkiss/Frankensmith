marked = require 'marked'

module.exports = (g, gp, MS, msp, cfg) ->

  helpers =
    md: (string)->
      marked string

  return helpers
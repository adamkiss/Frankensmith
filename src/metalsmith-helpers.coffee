marked = require 'marked'

module.exports = (g, gp, MS, msp, cfg) ->

  helpers =
    md: (string)->
      marked string
    css: (string)->
      "<link rel=stylesheet href=/assets/#{string} />"
    js:  (string)->
      "<script src=/assets/#{string}></script>"


  return helpers
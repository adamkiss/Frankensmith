_      = require 'lodash'
marked = require 'marked'

module.exports = (g, gp, MS, msp, cfg) ->

  html = {
    css: (file)->
      "<link rel=stylesheet href=/assets/#{file} />"
    js : (file)->
      "<script src=/assets/#{file}></script>"
  }

  helpers =
    md: (string)->
      marked string

    assets: (file)->
      if cfg.runtime.build && cfg.runtime.assets
        file = cfg.runtime.assets[file]

      if _(file).endsWith('.css') then html.css file else html.js file

  return helpers
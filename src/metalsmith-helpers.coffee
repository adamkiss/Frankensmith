_      = require 'lodash'
fsmarkdown = require('jstransformer')(require('jstransformer-fsmarkdown'))

module.exports = (g, gp, MS, msp, cfg) ->

  html = {
    css: (file)->
      "<link rel=stylesheet href=/assets/#{file} />"
    js : (file)->
      "<script src=/assets/#{file}></script>"
  }

  helpers =
    md: (renderString)->
      fsmarkdown.render(renderString).body if renderString?
    fsmarkdown: (renderString)->
      fsmarkdown.render(renderString).body if renderString?

    phpEcho: (renderString)->
      "<?= #{renderString} ?>" if renderString?
    php: (renderString)->
      "<?php #{renderString} ?>" if renderString?

    assets: (file)->
      if cfg.runtime.build && cfg.runtime.assets
        file = cfg.runtime.assets[file]

      if _(file).endsWith('.css') then html.css file else html.js file

  # aliases
  helpers.phpecho = helpers.phpEcho

  return helpers
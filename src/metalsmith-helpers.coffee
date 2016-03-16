_      = require 'lodash'
glob   = require 'glob'
path   = require 'path'
fsmarkdown = require('jstransformer')(require('jstransformer-fsmarkdown'))

module.exports = (g, gp, MS, msp, cfg) ->

  vendorJsCache = {
    found: {}
    missing: []
  }

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

    vendorJs: (file)->
      if vendorJsCache.found[file]?
        found = vendorJsCache.found[file]

      unless found?
        filePath = cfg.site.path "/public/assets/vendor/#{file}-*.js"
        found = glob.sync(filePath)[0]

        if found?
          found = path.parse(found).base
          vendorJsCache.found[file] = found

      if found?
        html.js path.join('vendor/', found)
      else
        unless vendorJsCache.missing[file]?
          vendorJsCache.missing.push(file)
          throw new gp.util.PluginError(
            'vendorJs'
            gp.util.colors.red("No file for '#{file}'")
          )
        null
  # aliases
  helpers.phpecho = helpers.phpEcho

  return helpers
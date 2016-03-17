# Jade helpers

These helpers get added to `metalsmith-in-place` to import to Jade when rendering.

## PHP

    class HelperPhp
      constructor: ()-> @

      echo: (renderString)->
        "<?= #{renderString} ?>" if renderString?
      e: (renderString)-> @echo renderString

      inline: (renderString)->
        "<?php #{renderString} ?>" if renderString?
      i: (renderString)-> @inline renderString

      omitted: (renderString)->
        "<?php #{renderString}" if renderString?

      redirect: (location = '/')->
        @omitted "header('Location: #{location}');"

## Markdown

It's Frankensmith—specific instance with few defaults turned on & footnote plugin used.

    fsmarkdown = require('jstransformer')(
      require 'jstransformer-fsmarkdown'
    )
    markdownRender = (renderString)->
      fsmarkdown.render(renderString).body if renderString?

## Assets

Includes automatic vendor globbing (so you don't have to remeber used version) and switch of dev/hashed version of css/js based on `Frankensmith.env.build`

    class HelperAssets
      constructor: (FS)->
        @FS = FS
        @cache = {found: {}, notfound: []}

      glob: require 'glob'
      path: require 'path'

      cssTag: (path)->
        "<link rel=stylesheet href=/assets/#{path} />"
      jsTag: (path)->
        "<script src=/assets/#{path}></script>"

      get: (file)=>
        build = @FS.cfg.runtime.build if @FS?.cfg?.runtime?.build?
        assets = @FS.cfg.runtime.assets if @FS?.cfg?.runtime?.assets?
        file = assets[file] if build? and assets?
        if file[-3..] is 'css'
          @cssTag file
        else
          @jsTag file

This vendor function is a little mind-bending I feel, but in reality, it isn't. Just isn't very nice.

      vendorGlob: (file)=>
        @FS.cfg.site.path "public/assets/vendor/#{file}-*.js"
      vendorCache: (key, file)=>
        @cache.found[key] = @path.parse(file).base

      vendor: (file)=>
        # find
        unless @cache.found[file]?
          found = @glob.sync(@vendorGlob file)[0]
          @vendorCache(file, found) if found?
        # output
        if @cache.found[file]?
          @jsTag "vendor/#{@cache.found[file]}"
        # fail
        else
          if @cache.notfound.indexOf(file) is -1
            @cache.notfound.push file
            throw new @FS.gp.util.PluginError(
              'Jade Helpers'
              @FS.gp.util.colors.red "No file for '#{file}'"
            )
          false

And away we go, We package stuff for extraction into Jade.

    module.exports = (FS)->
      assetHelper = new HelperAssets(FS)
      {
        php: new HelperPhp()
        md : markdownRender
        assets: assetHelper.get
        vendor: assetHelper.vendor
      }
module.exports = (g, gp, cfg)->

  _   = require 'lodash'
  MS  = require 'metalsmith'
  msp = require('load-metalsmith-plugins')()
  msh = require('./metalsmith-helpers')(g, gp, MS, msp, cfg)
  msp = require('./metalsmith-plugins')(g, gp, MS, msp, cfg)

  renameMap = [
    [/\.php\.jade$/, '.php'],
    [/\.jade$/     , '.htm']
  ]

  Metalsmith = (opts, callback)->
    buildMode = opts.build || false

    MS cfg.site.path()
      .source      'source'
      .destination 'public'
      .clean        false
      .frontmatter  false

      .use msp.matters()
      .use msp.ignore(cfg.mp.ignore)
      .use msp.define({
        assets: require cfg.site.path 'data/assets-manifest.json'
      })
      .use msp.filenames()
      .use msp.pathForJade()
      .use msp.inPlace(_.extend(cfg.mp.inPlace, msh))
      .use msp.rename(renameMap)

      .build (error)->
        if (error)
          callback(error)
        else
          gp.browserSync.reload()
          callback()
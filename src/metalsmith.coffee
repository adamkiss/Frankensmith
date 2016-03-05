module.exports = (g, gp, cfg)->

  MS  =  require 'metalsmith'
  msp =  require('load-metalsmith-plugins')()
  msh =  require('./metalsmith-helpers')(g, gp, MS, msp, cfg)
  msp =  require('./metalsmith-plugins')(g, gp, MS, msp, cfg)

  renameMap = [
    [/\.php\.jade$/, '.php'],
    [/\.jade$/     , '.htm']
  ]

  Metalsmith = (gulpCallback)->
    MS cfg.site.path()
      .source      'source'
      .destination 'public'
      .clean        false

      .use msp.ignore cfg.mp.ignore
      .use msp.filenames()
      .use msp.pathForJade()
      .use msp.inPlace cfg.mp.inPlace
      .use msp.rename renameMap

      .build (error)->
        if (error)
          gulpCallback(error)
        else
          gp.browserSync.reload()
          gulpCallback()
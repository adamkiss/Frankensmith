module.exports = (g, gp, cfg)->

  MS  =  require 'metalsmith'
  msp =  require('load-metalsmith-plugins')()
  msh =  require('./metalsmith-helpers')(g, gp, MS, msp, cfg)
  msp =  require('./metalsmith-plugins')(g, gp, MS, msp, cfg)

  renameMap = [
    [/\.php\.jade$/, '.php'],
    [/\.jade$/     , '.htm']
  ]

  Metalsmith = ()->
    MS cfg.site.to cfg.self.path()
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
          msp.notifier.notify {
            title: 'Metalsmith error'
            message: error
          }
        else
          gp.browserSync.reload()
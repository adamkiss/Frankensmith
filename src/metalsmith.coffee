module.exports = (g, gp, cfg)->

  MS:   require 'metalsmith'
  msp:  require('load-metalsmith-plugins')()
  msh:  require('./metalsmith-helpers')()
  msm:  require('./metalsmith-modules')()

  renameMap = [
    [/\.php\.jade$/, '.php'],
    [/\.jade$/     , '.htm']
  ]

  Metalsmith = (done)->
    MS cfg.site.to cfg.self.path()
      .source      'site'
      .destination 'public'
      .clean        false

      .use msp.ignore cfg.mp.ignore
      .use msp.filenames()
      .use msp.pathForJade()
      .use msp.inPlace cfg.mp.inPlace
      .use msp.rename renameMap

      .build (error)->
        if (error)
          gp.notify.error error
        else
          gp.browserSync.reload()
          done()
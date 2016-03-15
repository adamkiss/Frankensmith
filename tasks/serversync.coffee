module.exports = (gulp, gp, cfg)->
  gp.browserSync = require 'browser-sync'

  gulp.task 'connect-sync', ()->
    bs = null
    gp.connectPhp.server {
      port:      1110
      ini:       cfg.self.path 'php/server.ini'
      stdio:     [0,1,'ignore']
      keepalive: true
      base:      cfg.site.path('public')
    }, ()->
      bs = gp.browserSync({
        proxy:  'localhost:1110'
        port:   '1111'
        open:   false
        notify: false
        ghostMode:
          forms: false
      }) unless bs?
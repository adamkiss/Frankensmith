module.exports = (gulp, gp, cfg)->
  gp.browserSync = require 'browser-sync'

  gulp.task 'connect-sync', ()->
    gp.connectPhp.server {
      port:      1110
      ini:       cfg.self.path 'php/server.ini'
      router:    cfg.self.path 'php/router.php'
      stdio:     [0, 'ignore', 'pipe']
      keepalive: true
      base:      cfg.site.path('public')
    }, ()->
      gp.browserSync {
        proxy:  'localhost:1110'
        port:   '1111'
        open:   false
        notify: false
        ghostMode:
          forms: false
      }
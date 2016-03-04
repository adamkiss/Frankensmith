module.exports = (gulp, plugins, config)->
  plugins.browserSync = require 'browser-sync'

  gulp.task 'connect-sync', ()->
    plugins.connectPhp.server {
      port:      1110
      ini:       config.paths.self 'php/server.ini'
      router:    config.paths.self 'php/router.php'
      stdio:     [0, 'ignore', 'pipe']
      keepalive: true
      base:      config.paths.site()
    }, ()->
      plugins.browserSync {
        proxy:  '127.0.0.1'
        port:   '1111'
        open:   true
        notify: false
        ghostMode:
          forms: false
      }
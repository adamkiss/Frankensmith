module.exports = (g, gp, cfg)->
  Msfile = require('../src/metalsmith')(g, gp, cfg)
  Metalsmith = Msfile.Metalsmith

  g.task 'metalsmith:clean', (callback)->
    gp.del [
      'public/**/*'
      '!public/assets'
      '!public/assets/**/*'
      '!public/galleries'
      '!public/galleries/**/*'
    ], { cwd: cfg.site.path(), dot: true }

  g.task 'metalsmith:serve', (callback)->
    Metalsmith {}, callback

  g.task 'metalsmith:build', ['metalsmith:clean'], (callback)->
    Metalsmith {
      build: true
    }, callback
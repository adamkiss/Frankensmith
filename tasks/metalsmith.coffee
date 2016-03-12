module.exports = (g, gp, cfg)->
  # Metalsmith = require('../src/metalsmith')(g, gp, cfg)
  Msfile = require('../src/metalsmith')(g, gp, cfg)
  Metalsmith = Msfile.Metalsmith
  testGrayMatter = Msfile.testGrayMatter

  g.task 'metalsmith:serve', (callback)->
    Metalsmith {}, callback

  g.task 'metalsmith:build', (callback)->
    Metalsmith {
      build: true
    }, callback
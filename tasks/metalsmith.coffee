module.exports = (gulp, plugins, config)->
  Metalsmith = require('../src/metalsmith')(gulp, plugins, config)

  gulp.task 'metalsmith:serve', (callback)->
    Metalsmith callback
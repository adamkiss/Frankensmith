##
# STYLES
##

gu = require 'gulp-util'

module.exports = (g, gp, config)->

  taskStyles = (build = false)->
    cssSource = if !build && gu.env.css? then gu.env.css else '*'
    gp.remoteSrc "source/assets/styles/#{cssSource}.scss"
      .pipe gp.plumber()
      .pipe(
        gp.sass(config.gp.sass[if build then 'build' else 'serve'])
          .on 'error', (err)-> console.error err.formatted; this.emit 'end'
      )
      .pipe gp.autoprefixer ['last 2 versions', 'ie 9', 'ios 7', 'android 4']
      .pipe gp.remoteDest 'public/assets'

  g.task 'styles:clean', ()->
    gp.remoteSrc 'public/assets/*.css', {read: false}
      .pipe gp.clean()

  g.task 'styles:build', ['styles:clean'], ()->
    taskStyles(true)

  g.task 'styles:serve', ()->
    taskStyles()
      .pipe gp.browserSync.stream()
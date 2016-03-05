# Metalsmith plugins (doh)

module.exports = (g, gp, ms, msp, cfg) ->
  ###
    Prepend path for jade

    JADE works with root from metalsmith, so it ignores the 'source dir'. We need to set virtual filename of JADE-parsed files to __ROOT__/site/xxx.jade, so we can include and extend files with root of ./site/***
  ###
  p.pathForJade = ()->
    setPath = (name, files)->
      if name.indexOf('.jade') != -1
        files[name].filename = config.site.path "site/#{name.split('/').pop()}"

    (files, metalsmith, done)->
      setPath name, files for name, file of files
      done()

  p.whatsWithMD = ()->
    (files, metalsmith, done)->
      for name, file of files
        console.log name, file.contents
      done()

  return p
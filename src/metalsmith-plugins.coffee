# Metalsmith plugins (doh)

module.exports = (g, gp, ms, msp, cfg) ->
  ###
    Prepend path for jade

    JADE works with root from metalsmith, so it ignores the 'source dir'. We need to set virtual filename of JADE-parsed files to __ROOT__/site/xxx.jade, so we can include and extend files with root of ./site/***
  ###
  msp.pathForJade = ()->
    setPath = (name, files)->
      if name.indexOf('.jade') != -1
        files[name].filename = cfg.site.path "source/#{name.split('/').pop()}"

    (files, metalsmith, done)->
      setPath name, files for name, file of files
      done()

  return msp
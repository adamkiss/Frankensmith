// Require modules & config
var gulp = require('gulp'),
    // utils
    plumber = require('gulp-plumber'),
    shell = require('gulp-shell'),
    rename = require('gulp-rename'),
    fs = require('fs'),
    moment = require('moment'),
    // images
    changed = require('gulp-changed'),
    imagemin = require('gulp-imagemin'),
    // styles
    sass = require('gulp-sass'),
    autoprefixer = require('gulp-autoprefixer'),
    minify_css = require('gulp-minify-css'),
    // scripts
    include = require('gulp-include'),
    uglify = require('gulp-uglify'),
    jshint = require('gulp-jshint'),
    jshint_stylish = require('jshint-stylish'),
    // browser sync
    browser_sync = require('browser-sync'),
    reload = browser_sync.reload,

    // config: version file, paths, jshint
    cfg = {
      project: {
        assets_build_output : [
          './site/templates/_web-head.php',
          './site/templates/_wine-head.php',
          './site/templates/_admin-head.php'],
        browser_sync_proxy : 'lbestshot.kmd',
        autoprefixer: ['last 2 versions', 'ie 8', 'ios 7', 'android 4'],
        jshint: {
          "node": true, "esnext": true, "bitwise": true, "curly": true,
          "immed": true, "newcap": true, "noarg": true, "undef": true, "unused": "vars"
        },
        imagemin: { progressive: true }
      },
      dist: {
        root :   './site/assets/static',
        images : './site/assets/static/images',
        fonts :  './site/assets/static/fonts'
      },
      src: {
        images: './_devfiles/images/**/*.?(jpg|jpeg|png|gif|svg)',
        // styles: './_devfiles/styles/*.?(scss|css)',
        styles: './_devfiles/styles/wine-shop.scss',
        scripts_lint: ['./_devfiles/scripts/*.js', './_devfiles/scripts/libs/*.js'], // lint all scripts
        scripts_vendor: './_devfiles/scripts/vendor/*.js', // minified 'copy only' vendor files
        scripts_build: ['./_devfiles/scripts/*.js', '!./_devfiles/scripts/_*.js'], // exclude _*.js files
        fonts: './_devfiles/styles/fonts/*.*'
      },
      watch: {
        images: './_devfiles/images/**/*.?(jpg|jpeg|png|gif|svg)',
        styles: './_devfiles/styles/**/*.?(scss|css)',
        scripts: './_devfiles/scripts/**/*.js',
        content: [
          './site/templates/**/*.?(php|htm|html)',
          './site/modules/**/*.?(php|htm|html)',
          './site/classes/**/*.?(php|htm|html)'
        ]
      }
    };
});

// images optimizing
gulp.task('images', function () {
  return gulp.src( cfg.src.images )
    .pipe( plumber() )
    .pipe( changed( cfg.dist.images ))
      .pipe( imagemin( cfg.project.imagemin ))
    .pipe( gulp.dest( cfg.dist.images ));
});

// watch the files
gulp.task('watch', function () {
  gulp.watch(cfg.watch.styles,  ['styles', 'bs:reload']);
  gulp.watch(cfg.watch.scripts, ['scripts:lint', 'scripts:build', 'bs:reload']);
  gulp.watch(cfg.watch.images,  ['images', 'bs:reload']);
  gulp.watch(cfg.watch.content, ['bs:reload']);
});

//groups
gulp.task('all', [ 'styles', 'utils:fonts', 'scripts:build', 'images' ]);
gulp.task('build', [ 'all', 'utils:build:version' ]);
gulp.task('serve', [ 'all', 'utils:server', 'bs:start', 'watch' ]);

//default
gulp.task('default', ['serve']);

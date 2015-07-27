gulp = require 'gulp'
gutil = require 'gulp-util'
sass = require 'gulp-sass'
icedCmp = require 'gulp-coffee'
del = require 'del'
browserSync = require('browser-sync').create()

gulp.task 'sass', ->
  gutil.log 'Compiling', gutil.colors.green('sass'), 'files to', gutil.colors.green('css')
  await del 'public/css/', defer err
  gulp.src('src/sass/*.sass')
    .pipe sass().on 'error', sass.logError
    .pipe gulp.dest('./public/css')
    .pipe browserSync.stream()

gulp.task 'js', ->
  gutil.log 'Compiling', gutil.colors.green('coffee'), 'files to', gutil.colors.green('js')
  await del 'public/js/', defer err
  gulp.src('src/coffee/*.coffee')
    .pipe icedCmp().on 'error', gutil.log
    .pipe gulp.dest('./public/js')
    .pipe browserSync.reload()

gulp.task 'watch', ->
  gulp.watch 'src/sass/*.sass', ['sass']
  gulp.watch 'src/iced/*.iced', ['js']

gulp.task 'browser-sync', ->
  browserSync.init
    server:
      baseDir: './'

gulp.task 'dev', ['sass', 'js', 'watch', 'browser-sync']

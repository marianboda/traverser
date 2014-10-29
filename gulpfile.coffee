gulp = require 'gulp'
shell = require 'gulp-shell'
coffee = require 'gulp-coffee'
mainBowerFiles = require 'main-bower-files'
coffeelint = require 'gulp-coffeelint'
builder = require 'node-webkit-builder'

gulp.task 'bowerFiles', ->
  gulp.src(mainBowerFiles()).pipe(gulp.dest('app/libs'))

gulp.task 'lint', ->
  gulp.src('./src/*.coffee').pipe(coffeelint()).pipe(coffeelint.reporter())

gulp.task 'coffee', ->
  gulp.src('./src/*.coffee').pipe(coffee({bare: true}).on('error', (a,b) -> console.log a,b)).pipe(gulp.dest('./app/'))

gulp.task 'build', ->


gulp.task 'default', ['coffee']

gulp = require 'gulp'
shell = require 'gulp-shell'
coffee = require 'gulp-coffee'
mainBowerFiles = require 'main-bower-files'
coffeelint = require 'gulp-coffeelint'
Builder = require 'node-webkit-builder'
async = require 'async'

gulp.task 'bowerFiles', ->
  gulp.src(mainBowerFiles()).pipe(gulp.dest('app/libs'))

gulp.task 'lint', ->
  gulp.src('./src/*.coffee').pipe(coffeelint()).pipe(coffeelint.reporter())

gulp.task 'coffee', ->
  return gulp.src('./src/*.coffee').pipe(coffee({bare: true}).on('error', (a,b) -> console.log a,b)).pipe(gulp.dest('./app/'))

gulp.task 'build', ['coffee'], ->
  nw = new Builder
    files: ['./app/**/*', './package.json', './index.html']
    platforms: ['osx']
    appName: 'Traverser'
    appVersion: '0.0.1'
    buildDir: './build'

  nw.build().then ->
    console.log 'all Done :)'
  .catch (err) -> console.error err

  nw.build (err) -> console.log err if err?

gulp.task 'run', ['build'], shell.task('open ./build/traverser/osx/Traverser.app')


gulp.task 'default', ['run'], ->

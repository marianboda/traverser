gulp = require 'gulp'
shell = require 'gulp-shell'
coffee = require 'gulp-coffee'
mainBowerFiles = require 'main-bower-files'
coffeelint = require 'gulp-coffeelint'
Builder = require 'node-webkit-builder'
changed = require 'gulp-changed'
async = require 'async'

srcDirs =
  js: 'src'
destDirs =
  js: 'app'
  lib: 'app/lib'

paths =
  csFiles: ["#{srcDirs.js}/**/*.coffee"]

gulp.task 'bowerFiles', ->
  gulp.src(mainBowerFiles()).pipe(gulp.dest('app/libs'))

gulp.task 'lint', ->
  gulp.src('./src/*.coffee').pipe(coffeelint()).pipe(coffeelint.reporter())

gulp.task 'coffee', ->
  gulp.src(paths.csFiles)
  .pipe(changed(destDirs.js, {extension: '.js'}))
  .pipe(coffee({bare: true}).on("error", (e) -> console.log(e); @end()))
  .pipe(gulp.dest(destDirs.js))

gulp.task 'watch', ->
  return gulp.watch [paths.csFiles], ['coffee']

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


gulp.task 'default', ['coffee'], ->

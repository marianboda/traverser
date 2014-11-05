gulp = require 'gulp'
shell = require 'gulp-shell'
coffee = require 'gulp-coffee'
jade = require 'gulp-jade'
mainBowerFiles = require 'main-bower-files'
coffeelint = require 'gulp-coffeelint'
Builder = require 'node-webkit-builder'
changed = require 'gulp-changed'
async = require 'async'
inject = require 'gulp-inject'

srcDirs =
  js: 'src'
  jade: 'src'
destDirs =
  js: 'app'
  lib: 'app/lib'
  templates:'app'

paths =
  csFiles: ["#{srcDirs.js}/**/*.coffee"]
  jadeFiles: ["#{srcDirs.jade}/**/*.jade"]

gulp.task 'bowerFiles', ->
  gulp.src(mainBowerFiles()).pipe(gulp.dest('app/libs'))

gulp.task 'inject', ->
  gulp.src('./app/index.html')
  .pipe(inject(gulp.src('./app/libs/**/*.js', read: false), name: 'libs'))
  .pipe(inject(gulp.src(['./app/js/**/*.js','!./app/js/app.js', './app/directives/**.*.js'], read: false), name: 'scripts'))
  .pipe(gulp.dest './app')
  

gulp.task 'lint', ->
  gulp.src('./src/*.coffee').pipe(coffeelint()).pipe(coffeelint.reporter())

gulp.task 'coffee', ->
  gulp.src(paths.csFiles)
  .pipe(changed(destDirs.js, {extension: '.js'}))
  .pipe(coffee({bare: true}).on("error", (e) -> console.log(e); @end()))
  .pipe(gulp.dest(destDirs.js))

gulp.task 'jade', ->
  gulp.src(paths.jadeFiles).pipe(jade({pretty: true})).pipe(gulp.dest(destDirs.templates))


gulp.task 'watch', ->
  gulp.watch [paths.csFiles], ['coffee']
  gulp.watch [paths.jadeFiles], ['jade']

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


gulp.task 'default', ['coffee', 'jade', 'inject'], ->

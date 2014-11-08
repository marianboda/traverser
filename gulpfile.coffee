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
ignore = require 'gulp-ignore'
flatten = require 'gulp-flatten'
runSequence = require 'run-sequence'
sass = require 'gulp-ruby-sass'

srcDirs =
  js: 'src'
  jade: 'src'
  sass: 'src/styles'
destDirs =
  js: 'app'
  lib: 'app/lib'
  templates:'app'
  styles:'app/css'

paths =
  csFiles: ["#{srcDirs.js}/**/*.coffee"]
  jadeFiles: ["#{srcDirs.jade}/**/*.jade"]
  sassFiles: ["#{srcDirs.sass}/**/*.sass"]

gulp.task 'bowerFiles', ->
  gulp.src(mainBowerFiles()).pipe(gulp.dest('app/libs'))

gulp.task 'inject', ->
  libs = mainBowerFiles().map((a) -> 'app/libs/'+a.substr(a.lastIndexOf('/')+1))
  libs.push 'app/libs/pure.base.css'
  gulp.src('./app/index.html')
  .pipe(inject(gulp.src(libs, {read: false}),
    {name: 'libs', relative: true}))  
  # .pipe(inject(gulp.src('app/libs/**/*', read: false), {name: 'libs', relative: true}))
  .pipe(inject(gulp.src(['app/js/**/*.js','!app/js/app.js', 'app/directives/**.*.js'],
    read: false), {name: 'scripts', relative: true}))
  .pipe(inject(gulp.src(['app/css/**/*.css'],
    read: false), {name: 'styles', relative: true}))
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

gulp.task 'jadeAndInject', ->
  runSequence 'jade', 'inject'

gulp.task 'sass', ->
  gulp.src(paths.sassFiles).pipe(sass()).on('error', (e) -> console.log e).pipe(gulp.dest(destDirs.styles))


gulp.task 'watch', ->
  gulp.watch [paths.csFiles], ['coffee']
  gulp.watch [paths.jadeFiles], ['jadeAndInject']
  gulp.watch [paths.sassFiles], ['sass']

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

gulp.task 'default', ->
  runSequence ['coffee', 'jade', 'sass'], 'inject'

fs = require 'fs'
file = require 'file'
gui = require 'nw.gui'
menu = new gui.Menu {type: 'menubar'}
async = require 'async'
exec = (require "child_process").exec
DB_PATH = process.env.HOME + '/Documents'

menu.append new gui.MenuItem({label: 'App', submenu: new gui.Menu()})
menu.append new gui.MenuItem({label: 'File',submenu: new gui.Menu()})
menu.items[0].submenu.append new gui.MenuItem({label: 'New'})
menu.items[1].submenu.append new gui.MenuItem({label: 'New2'})
menu.items[1].submenu.append new gui.MenuItem({label: 'Old2'})
gui.Window.get().menu = menu
gui.Window.get().showDevTools()

dir = '/Users/marianboda/temp/raw'
# dir = '/Volumes/HardDrive/Foto/FOTO process'
previewSize = 2048
thumbSize = 600
collectionName = 'photo'
acceptedFormats = ['jpg','jpe','jpeg','tif','tiff','cr2', 'mov']

getExt = (str) -> str.split('.').pop().toLowerCase()

getThumbPath = (filename) -> "thumbs/#{filename}.jpg"
getOrientCommand = (num) ->
    ['','','-flop','-rotate 180','-flip','-flip -rotate 90',
    	'-rotate 90','-flop -rotate 90','-rotate 270'][num]

shouldProcessFilter = (task, callback) ->
  console.log "#{task} is gonna be processed"
  if getExt(task) not in acceptedFormats
    console.log "#{task} not recognized"
    return callback false
  callback true

app = angular.module('app',["ngRoute"])
app.config ($routeProvider) ->
  $routeProvider.when('/home', {templateUrl: 'src/templates/home.html', controller: 'HomeScreenCtrl'})
  $routeProvider.when('/stats', {templateUrl: 'src/templates/stats.html', controller: 'StatsScreenCtrl'})
  $routeProvider.when('/scan', {templateUrl: 'src/templates/scan.html', controller: 'ScanScreenCtrl'})
  .otherwise('/', {templateUrl: 'src/templates/home.html'})


app.controller 'AppController',
  class AppController
    requestedCounter: 0
    doneCounter: 0
    constructor: ($scope, DbService, ProcessService) ->
      $scope.model =
        text: '--not loaded yet--'
        files: []
        errorFiles: []
        requestedCount: 0
        errorCount: 0
        doneCount: 0

      DbService.getDirs().then (data) ->
        $scope.model.text = data.join()

      return null

      searchDir = (wha, dirname, dirs, files) ->
        dir =
          path: dirname
          filesCount: files.length
          dirsCount: dirs.length
        console.log('dir: '+dir.path)
        DbService.addDir dir

        async.filter files, shouldProcessFilter, (r) ->
          $scope.$apply ->
            for photo in r
              $scope.model.requestedCount++
              # console.log 'process result: ',
              console.log '%c processing '+photo, 'color: blue'
              do (photo) ->
                ProcessService.queue(photo).then (data) ->
                  # console.log 'looks done to me ', data
                  $scope.model.files.push(data.path)
                  $scope.model.doneCount++
                , (err) ->
                  console.error 'got error here', err
                  $scope.model.errorFiles.push(photo)

                  $scope.model.errorCount++
                , (notify) -> console.info 'notify on the app level'


      # mongo.connect mongoUrl, (err, db) ->
      # 	return console.log "could not connect #{err}".red if err?
      # 	collection = db.collection collectionName
      # 	dirCollection = db.collection 'directories'
      # 	file.walk dir, searchDir

      file.walk dir, searchDir

      # fs.readdir path, (err, list) ->
      #   $scope.$apply( -> $scope.model.files = list )

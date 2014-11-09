SOURCE_PATH = "#{process.env.HOME}/temp/raw"
USER_PATH = "#{process.env.HOME}/Documents/Photon"
DB_PATH = "#{process.env.HOME}/Documents/Photon/db"
THUMB_PATH = "#{process.env.HOME}/Documents/Photon/thumbs"
PREVIEW_PATH = "#{process.env.HOME}/Documents/Photon/previews"

previewSize = 2048
thumbSize = 600
collectionName = 'photo'
acceptedFormats = ['jpg','jpe','jpeg','tif','tiff','cr2', 'mov']

fs = require 'fs'
file = require 'file'
gui = require 'nw.gui'
menu = new gui.Menu {type: 'menubar'}
async = require 'async'
exec = (require "child_process").exec

fs.mkdir USER_PATH, 0o755, ->
  fs.mkdir DB_PATH, 0o755, ->
  fs.mkdir THUMB_PATH, 0o755, ->
  fs.mkdir PREVIEW_PATH, 0o755, ->

menu.append new gui.MenuItem({label: 'App', submenu: new gui.Menu()})
menu.append new gui.MenuItem({label: 'File',submenu: new gui.Menu()})
menu.items[0].submenu.append new gui.MenuItem({label: 'New'})
menu.items[1].submenu.append new gui.MenuItem({label: 'New2'})
menu.items[1].submenu.append new gui.MenuItem({label: 'Old2'})
gui.Window.get().menu = menu
gui.Window.get().showDevTools()
menu.createMacBuiltin("traverser");

getExt = (str) -> str.split('.').pop().toLowerCase()

getThumbPath = (filename) -> "thumbs/#{filename}.jpg"
getOrientCommand = (num) ->
    ['','','-flop','-rotate 180','-flip','-flip -rotate 90',
    	'-rotate 90','-flop -rotate 90','-rotate 270'][num]

shouldProcessFilter = (task, callback) ->
  # console.log "#{task} is gonna be processed"
  if getExt(task) not in acceptedFormats
    # console.log "#{task} not recognized"
    return callback false
  callback true

app = angular.module('app',['ngRoute'])
app.config ($routeProvider) ->
  $routeProvider.when('/home', {templateUrl: 'templates/home.html', controller: 'HomeScreenCtrl'})
  $routeProvider.when('/stats', {templateUrl: 'templates/stats.html', controller: 'StatsScreenCtrl'})
  $routeProvider.when('/scan', {templateUrl: 'templates/scan.html', controller: 'ScanScreenCtrl'})
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
      null

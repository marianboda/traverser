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
# gui.Window.get().showDevTools()

dir = '/Users/marianboda/temp/raw'
previewSize = 2048
thumbSize = 600
collectionName = 'photo'
acceptedFormats = ['jpg','jpe','jpeg','tif','tiff','cr2']

getExt = (str) -> str.split('.').pop().toLowerCase()
getPrevPath = (filename) -> "prevs/#{filename}.jpg"
getThumbPath = (filename) -> "thumbs/#{filename}.jpg"
getOrientCommand = (num) ->
    ['','','-flop','-rotate 180','-flip','-flip -rotate 90',
    	'-rotate 90','-flop -rotate 90','-rotate 270'][num]

shouldProcessFilter = (task, callback) ->
  return callback true
  console.log "#{task} is gonna be processed"
  if getExt(task) not in acceptedFormats
    console.log "#{task} not recognized"
    return callback false
  callback true

app = angular.module('app',[])
app.controller 'AppController',
  class AppController
    constructor: ($scope, DbService, ProcessService) ->
      $scope.model =
        text: '--not loaded yet--'
        files: []

      DbService.getDirs().then (data) ->
        $scope.model.text = data.join()



      searchDir = (wha, dirname, dirs, files) ->
        console.log('dir: '+dirname)
        DbService.addDir dirname

        async.filter files, shouldProcessFilter, (r) ->
          DbService.addPhoto photo for photo in r
          ProcessService.process photo for photo in r
          $scope.$apply( -> $scope.model.files = $scope.model.files.concat(r) )

      # mongo.connect mongoUrl, (err, db) ->
      # 	return console.log "could not connect #{err}".red if err?
      # 	collection = db.collection collectionName
      # 	dirCollection = db.collection 'directories'
      # 	file.walk dir, searchDir

      file.walk dir, searchDir

      # fs.readdir path, (err, list) ->
      #   $scope.$apply( -> $scope.model.files = list )

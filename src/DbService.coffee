DB = require 'nedb'
db =
  dir: new DB {filename: "#{DB_PATH}/dirs.nedb", autoload: true}
  photo: new DB {filename: "#{DB_PATH}/photos.nedb", autoload: true}

# db.loadDatabase((err) -> console.error('db error', err) if err?)

app.service 'DbService',
  class DbService
    constructor: ($q) ->
      console.log 'DbService started'
      @$q = $q
    getSome: ->
      console.log 'gettin some'
    addDir: (path) ->
      db.dir.insert {path: path, status: 0}, (err, newdoc) ->
        console.error err if err?
        console.log newdoc

    addPhoto: (path) ->
      db.photo.insert {path: path}, (err, newdoc) ->
        console.error err if err?
        console.log newdoc

    getDirs: () ->
      defer = @$q.defer()
      db.dir.find {}, (err, docs) ->
        if err? then defer.reject err else defer.resolve docs
      defer.promise

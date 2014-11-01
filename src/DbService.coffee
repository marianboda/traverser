DB = require 'nedb'
db =
  dir: new DB {filename: "#{DB_PATH}/dirs.nedb", autoload: true}
  photo: new DB {filename: "#{DB_PATH}/photos.nedb", autoload: true}

# db.loadDatabase((err) -> console.error('db error', err) if err?)

app.service 'DbService', ($q) ->
  class DbService
    constructor: ->
      console.log 'DbService started'
    getSome: ->
      console.log 'gettin some'
    addDir: (path) ->
      db.dir.insert {path: path, status: 0}, (err, newdoc) ->
        console.error err if err?
        # console.log newdoc

    getPhoto: (path) ->
      defer = $q.defer()
      db.photo.findOne {path:path}, (err, doc) ->
        defer.resolve(doc)
      defer.promise

    addPhoto: (photo) ->
      defer = $q.defer()
      db.photo.insert photo, (err, newdoc) ->
        if err?
          console.error err
          return defer.reject err
        defer.resolve newdoc
      defer.promise

    getDirs: () ->
      defer = $q.defer()
      db.dir.find {}, (err, docs) ->
        if err? then defer.reject err else defer.resolve docs
      defer.promise

  new DbService()

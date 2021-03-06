app.controller 'ScanScreenCtrl', ($scope, DbService, ProcessService) ->
  class ScanScreenCtrl
    constructor: ->
      console.log 'ScanScreenCtrl constructor'
      $scope.model =
        text: '--not loaded yet--'
        files: []
        errorFiles: []
        requestedCount: 0
        errorCount: 0
        doneCount: 0
        path: SOURCE_PATH
      $scope.scan = => @runScan()
      $scope.scam = -> $scope.model.doneCount++

    runScan: ->
      console.log 'ScanScreenCtrl runner'
      DbService.getDirs().then (data) ->
        $scope.model.text = data.join()

      # return null

      searchDir = (wha, dirname, dirs, files) ->
        dir =
          path: dirname
          fileCount: files.length
          dirCount: dirs.length
        # console.log('dir: '+dir.path)
        

        async.filter files, shouldProcessFilter, (r) ->
          dir.catalogFileCount = r.length
          DbService.addDir dir
          $scope.$apply ->
            for photo in r
              $scope.model.requestedCount++
              # console.log 'process result: ',
              # console.log '%c processing '+photo, 'color: blue'
              # do (photo) ->
              #   ProcessService.queue(photo).then (data) ->
              #     $scope.model.files.push(data.path)
              #     $scope.model.doneCount++
              #   , (err) ->
              #     console.error 'got error here', err
              #     $scope.model.errorFiles.push(photo)

              #     $scope.model.errorCount++
              #   , (notify) -> console.info 'notify on the app level'


      # mongo.connect mongoUrl, (err, db) ->
      # 	return console.log "could not connect #{err}".red if err?
      # 	collection = db.collection collectionName
      # 	dirCollection = db.collection 'directories'
      # 	file.walk dir, searchDir

      file.walk $scope.model.path, searchDir

      # fs.readdir path, (err, list) ->
      #   $scope.$apply( -> $scope.model.files = list )
  new ScanScreenCtrl()

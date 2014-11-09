app.controller 'StatsScreenCtrl', ($scope, DbService) ->
  class StatsScreenCtrl
    constructor: ->
      $scope.model =
        dirs : []
      $scope.clean = ->
        DbService.cleanAll().then (data) ->
          null# console.log data
        , (err) -> console.error err

      $scope.model.tree =
        name: 'root'
        items: []

      DbService.photoCount().then (data) ->
        $scope.model.photoCount = data
      DbService.recordCount('dir').then (data) ->
        $scope.model.dirCount = data

      DbService.getDirs().then (data) =>
        $scope.model.dirs = data

        tree = $scope.model.tree

        getSubtree = (path) ->
          parts = dir.path.split('/')
          parts.shift() if parts[0] is ''
          current = tree
          for p in parts
            found = -1
            for item, i in current.items
              # console.log item.name, p
              if item.name is p
                found = i
                break
            if found is -1
              current.items.push {name: p, items: []}
              found = current.items.length-1
            current = current.items[found]
          current

        for dir in data
          current = getSubtree(dir.path)

          current.fileCount = dir.fileCount
          current.dirCount = dir.dirCount
          current._id = dir._id
          current.catalogFileCount = dir.catalogFileCount

        @countSubFiles()
        # console.log 'DIRS', data
        # console.log 'DIRS', tree

    countSubFiles: () ->
      count = (subtree) ->
        counter = subtree.catalogFileCount ? 0
        for i in subtree.items
          
          counter += count(i)
        subtree.catalogSubFileCount = counter
        # console.log counter
        counter
      count($scope.model.tree)
      # console.log $scope.model.tree


  new StatsScreenCtrl()

app.directive "tree", ($compile) ->
  restrict: "E"
  terminal: true
  scope:
    treeData: "="
    parentData: "="

  link: (scope, element, attrs) ->
    # console.log 'linking tree'
    # console.log 'treeData', scope.treeData unless scope.parentData?
    template = '<div>' +
    ' <span>{{treeData.name}} | </span>' +
    ' <span ng-if="treeData.catalogFileCount > 0" class="ui blue circular label">{{treeData.catalogFileCount}}</span>' + 
    ' <span ng-if="treeData.fileCount - treeData.catalogFileCount > 0" class="ui red circular label">{{treeData.fileCount - treeData.catalogFileCount}}</span>' + 
    ' <span ng-if="treeData.catalogSubFileCount > 0 && treeData.catalogSubFileCount != treeData.catalogFileCount" class="ui circular label">{{treeData.catalogSubFileCount}}</span>' + 
    '</div>'

    if scope.treeData? and angular.isArray(scope.treeData.items)
      template += "<ul class=\"indent\"><li ng-repeat=\"item in treeData.items\"><tree tree-data=\"item\" parent-data=\"treeData.items\"></tree></li></ul>"

    newElement = angular.element(template)
    $compile(newElement) scope
    element.replaceWith newElement

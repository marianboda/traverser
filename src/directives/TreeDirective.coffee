# app.directive 'tree', ->
  # template: '<h1>Tree++</h1><ul><li ng-repeat="dir in data">{{dir}}</li></ul>'
  # scope:
  #   data: '='
app.directive "tree", ($compile) ->
  restrict: "E"
  terminal: true
  scope:
    treeData: "="
    parentData: "="

  link: (scope, element, attrs) ->
    # console.log 'treeData', scope.treeData unless scope.parentData?


    template = "<span>{{treeData.name}}</span>"
    template += "<ul class=\"indent\"><li ng-repeat=\"item in treeData.items\"><tree tree-data=\"item\" parent-data=\"treeData.items\"></tree></li></ul>"  if scope.treeData? and angular.isArray(scope.treeData.items)

    newElement = angular.element(template)
    $compile(newElement) scope
    element.replaceWith newElement

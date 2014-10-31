app.service 'ProcessService', ($q) ->
  class ProcessService
    constructor: -> console.info "starting ProcessService"
    process: (filePath) ->
      console.log 'processing file: ', filePath
  new ProcessService()

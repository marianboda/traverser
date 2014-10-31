app.service 'ProcessService', ($q) ->
  class ProcessService
    constructor: -> console.info "starting ProcessService"
    process: (filePath) ->
      console.log 'processing file: ', filePath
      @md5 {path: filePath}

    md5: (photo) ->
      fs = require('fs')
      crypto = require('crypto')

      fd = fs.createReadStream(photo.path);
      hash = crypto.createHash('md5');
      hash.setEncoding('hex');
      defer = $q.defer()

      fd.on 'end', ->
        hash.end()
        hashString = hash.read()
        console.log hashString

        defer.resolve hashString

      fd.pipe(hash);

      defer.promise





  new ProcessService()

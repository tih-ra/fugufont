fs = require('fs')

Font::files = ["archive"]

Font::file_path = (object) ->
  _this = @
  "/#{object}s/" + eval("_this.#{object}")

Font::file_name = (origin_name) ->
  "#{@title.split(' ').join('_').toLowerCase()}.#{origin_name.split('.').pop()}"

Font::upload_files = (files, cb) ->
  _this = @
  @files.forEach (object) ->
    _this.upload_file(object, files[object], cb)
    
Font::upload_file = (object, file, cb) ->
  _name = @file_name(file.name)
  _this = @
  eval("_this.#{object} = _name")
  
  fs.readFile file.path, (err, cb) ->
    req = app.aws.put(_this.file_path(object),
      "Content-Length": cb.length
      "Content-Type": file.type
    )
    req.on "response", (res) ->
      console.log "saved to %s", req.url  if 200 is res.statusCode

    req.end cb


Font::remove_files = (cb) ->
  _this = @
  @files.forEach (object) ->
    _this.remove_file(_this.file_path(object), cb)
  
Font::remove_file = (file, cb) ->
    app.aws.del(file).on("response", (res) ->
      console.log res.statusCode
      console.log res.headers
    ).end()

Font::update_files = (files, cb) ->
  _this = @
  @files.forEach (object) ->
    _this.update_file(object, files[object], cb)

Font::update_file = (object, file, cb) ->
    unless file.name is ''
      @remove_file(@file_path(object), cb)    
      @upload_file(object, file, cb)
    @.save()

Font::rename_files = (cb) ->
  _this = @
  @files.forEach (object) ->
    _this.rename_file(object, _this.file_path(object), cb)
  
Font::rename_file = (object, old_file, cb) ->
  _this = @
  _name = @file_name(eval("_this.#{object}"))
  eval("_this.#{object} = _name")
  new_file = @file_path(object)
  
  req = app.aws.put(new_file,
    "Content-Length": "0"
    "x-amz-copy-source": old_file
    "x-amz-metadata-directive": "REPLACE"
  )

  req.on "response", (res) ->
    console.log res.statusCode
    console.log res.headers

  req.end()

Font::update_all = (font, cb) ->
  _this = @
  @.updateAttributes font, (err) =>
    if err
      cb(new Error('Validation error'))
    else
      #_this.rename_files(cb)
      cb()
  


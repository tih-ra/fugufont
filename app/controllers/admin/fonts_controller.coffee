load 'admin'

before 'load font', ->
    Font.find params.id, (err, font) =>
        if err
            redirect path_to.admin_fonts
        else
            @font = font
            next()
, only: ['show', 'edit', 'update', 'destroy']

action 'new', ->
    @font = new Font
    @title = 'New font'
    render()

action 'create', ->
    @font = new Font(body.Font)
    @font.upload_files req.files.Font, (err) ->
      if err
        console.log err
    
    @font.save (err) ->
        if err
            flash 'error', 'Font can not be created'
            @font = font
            @title = 'New font'
            render 'new'
        else
            flash 'info', 'Font created'
            redirect path_to.admin_fonts

action 'index', ->
    Font.all (err, fonts) =>
        @fonts = fonts
        @title = 'Fonts index'
        render()

action 'show', ->
    @title = 'Font show'
    render()

action 'edit', ->
    @title = 'Font edit'
    render()

action 'update', ->
    
    @font.update_files req.files.Font, (err) ->
      if err then console.log err
    @font.update_all body.Font, (err) =>
        console.log err
        if !err
            flash 'info', 'Font updated'
            redirect path_to.admin_font(@font)
        else
            flash 'error', 'Font can not be updated'
            @title = 'Edit font details'
            render 'edit'

action 'destroy', ->
    font = @font
    @font.destroy (error) ->
        if error
            flash 'error', 'Can not destroy font'
        else
            font.remove_files (err) ->
                console.log err
            flash 'info', 'Font successfully removed'
        send "'" + path_to.admin_fonts + "'"

uploadArchive: ->
  font = new Font()
  @form_params = body.Font
  tmpFile = body.Font.archive
  font.archive_upload tmpFile.name, tmpFile.path, (err) ->
    if err
      console.log err

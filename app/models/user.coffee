User.findOrCreate = (source, sourceUser, cb) ->
  switch source
    when 'twitter'
      User.findOrCreateTwitter sourceUser, (user) ->
        cb(user)
    when 'google'
      console.log sourceUser
      cb(user)

User.findOrCreateTwitter = (sourceUser, cb) ->
  User.all
    source: 'twitter'
    source_id: sourceUser.id
    , (err, tw_user) ->
      if tw_user.length
        cb(tw_user[0])
      else
        tw_user = new User({source: 'twitter', username: sourceUser.name, source_id: sourceUser.id})
        tw_user.save (err) ->
          if err then console.log err
        cb(tw_user)
          
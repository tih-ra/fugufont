apis = require('./apis')
module.exports = (everyauth) ->

  everyauth.everymodule.findUserById (id, callback) ->
    User.find id, (err, user) ->
      callback null, user

  everyauth.twitter
    .consumerKey(apis.twit.consumerKey)
    .consumerSecret(apis.twit.consumerSecret)
    .findOrCreateUser((sess, accessToken, accessSecret, twitUser) ->
      promise = @Promise()

      User.findOrCreate 'twitter', twitUser, (user) ->
        promise.fulfill(user)

      
      return promise
          
    )
    .redirectPath "/"

    everyauth.google
      .appId(apis.google.clientId)
      .appSecret(apis.google.clientSecret)
      .scope("https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email")
      .findOrCreateUser((sess, accessToken, extra, googleUser) ->
        promise = @Promise()

        googleUser.refreshToken = extra.refresh_token
        googleUser.expiresIn = extra.expires_in
        
        User.findOrCreate 'google', googleUser, (user) ->
          promise.fulfill(user)
        
        return promise

    )
    .redirectPath "/"
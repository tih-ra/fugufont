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
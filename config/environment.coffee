express = require 'express'
stylus = require 'stylus'
nib = require 'nib'
form = require('connect-form')
everyauth = require('everyauth')


require('./auth')(everyauth)


app.configure ->
    cwd = process.cwd()
    app.set 'views', cwd + '/app/views'
    app.set 'view engine', 'jade'
    app.set 'view options', complexNames: true
    app.enable 'coffee'
    app.use(form({ keepExtensions: true }))

    app.use stylus.middleware(
      src: cwd + "/app/assets"
      dest: cwd + "/public"
      debug: true
      compile: (str, path) ->
        stylus(str).set("filename", path).set("compress", true).use(nib())
      
    )

	
    app.use express.static(cwd + '/public', maxAge: 86400000)
    app.use express.bodyParser()
    app.use express.cookieParser()
    app.use express.session secret: '9c9c69c415f0e8a4d860d6ba97a42847'
    app.use express.methodOverride()
    app.use everyauth.middleware()

    
    app.use app.router
everyauth.helpExpress(app)



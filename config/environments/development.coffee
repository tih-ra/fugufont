knox = require 'knox'

app.configure 'development', ->
    app.enable 'log actions'
    app.enable 'env info'
    app.disable 'view cache'
    app.disable 'model cache'
    app.disable 'eval cache'
    app.use require('express').errorHandler dumpExceptions: true, showStack: true
	app.aws = knox.createClient(
	  key: "AKIAJEWPDNJCMR3Y3ARA"
	  secret: "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"
	  bucket: "pukybox"
	)


define 'User', ->
    property 'email', String, index: true
    property 'password', String
    property 'activated', Boolean, default: true
    property 'username', String
    property 'source', String
    property 'role', String
    property 'source_id', Number

    

Font = describe 'Font', () ->
    property 'title', String
    property 'description', String
    property 'archive', String
    property 'price', Number
    property 'createdAt', Date, default: Date.now
    property 'image', String

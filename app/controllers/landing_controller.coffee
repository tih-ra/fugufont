load 'application'

action 'index', ->
  console.log req.user
  render({title: "Posts index"})
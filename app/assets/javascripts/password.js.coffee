window.Password or= {}

Password.validate = ($password) ->
  return !! $password.val()

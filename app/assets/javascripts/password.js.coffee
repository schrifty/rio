window.Password or= {}

Password.validate = ($password) ->
  return !! $password.val() && $password.val().length > 7

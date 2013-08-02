window.Tenant or= {}

Tenant.emailPattern = /// ^ #begin of line
             ([\w.-]+)         #one or more letters, numbers, _ . or -
             @                 #followed by an @ sign
             ([\w.-]+)         #then one or more letters, numbers, _ . or -
             \.                #followed by a period
             ([a-zA-Z.]{2,6})  #followed by 2 to 6 letters or periods
             $ ///i #end of line and ignore case

Tenant.validatePasswords = ->
  return Password.validate(Tenant.$password1) and (Tenant.$password1.val() == Tenant.$password2.val())

Tenant.signup = ->
  if Tenant.validatePasswords()
    $('#signup-spinner').slideDown('slow')
    agent = API.createTenantAndAgent(Tenant.$email.val(), "abcdefg", Tenant.$password1.val())
    $('#signup-spinner').slideUp('slow')
  else
    Tenant.$signupButton.slideUp()
    Tenant.$passwords.slideDown()

$(document).ready ->
  Tenant.$signupButton = $('#signup-button')
  Tenant.$passwords = $('.passwords')
  Tenant.$password1 = $('#password1')
  Tenant.$password2 = $('#password2')
  Tenant.$email = $('#email')

  Tenant.$email.on 'keypress', (event) ->
    if Tenant.$email.val().match Tenant.emailPattern
      Tenant.$signupButton.css("display", "block")
  Tenant.$signupButton.on 'click', (event) ->
    Tenant.signup()
  Tenant.$password1.on 'keyup', (event) ->
    Tenant.$signupButton.css("display", if Tenant.validatePasswords() then "block" else "hidden")
  Tenant.$password2.on 'keyup', (event) ->
    Tenant.$signupButton.css("display", if Tenant.validatePasswords() then "block" else "hidden")

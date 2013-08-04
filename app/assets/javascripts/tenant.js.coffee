window.Tenant or= {}

Tenant.emailPattern = /// ^ #begin of line
             ([\w.-]+)         #one or more letters, numbers, _ . or -
             @                 #followed by an @ sign
             ([\w.-]+)         #then one or more letters, numbers, _ . or -
             \.                #followed by a period
             ([a-zA-Z.]{2,6})  #followed by 2 to 6 letters or periods
             $ ///i #end of line and ignore case

Tenant.validatePasswordConfirmation = ->
  return Password.validate(Tenant.$password1) and (Tenant.$password1.val() == Tenant.$password2.val())

Tenant.register = ->
  if Tenant.validatePasswordConfirmation()
    $('#signup-spinner').slideDown('slow')
    agent = API.createAgent(null, Tenant.$email.val(), "abcdefg", Tenant.$password1.val())
    $('#signup-spinner').slideUp('slow')
  else
    Tenant.$signupButton.slideUp()
    Tenant.$passwords.slideDown()

Tenant.emailKeyPress = ->
  if Tenant.$email.val().match Tenant.emailPattern
    $('#email-spinner').slideDown('fast')
    API.headAgentByEmail(Tenant.$email.val(), ((found) ->
      console.log "callback called: " + found
      if found
        $('#password-div').slideDown()
      else
        $('#password-confirm-div').slideDown()
    ))
    $('#email-spinner').slideUp('fast')

Tenant.passwordConfirmKeyUp = ->
  Tenant.$signupButton.css("display", if Tenant.validatePasswordConfirmation() then "block" else "hidden")

$(document).ready ->
  Tenant.$signupButton = $('#signup-button')
  Tenant.$passwords = $('.passwords')
  Tenant.$password1 = $('#password1')
  Tenant.$password2 = $('#password2')
  Tenant.$email = $('#email')

  Tenant.$email.on 'keypress', (event) -> Tenant.emailKeyPress()
  Tenant.$signupButton.on 'click', (event) -> Tenant.register()
  Tenant.$password1.on 'keyup', (event) -> Tenant.passwordConfirmKeyUp()
  Tenant.$password2.on 'keyup', (event) -> Tenant.passwordConfirmKeyUp()

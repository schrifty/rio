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

Tenant.signIn = ->
  API.createAgentSession(Tenant.$email.val(), Tenant.$password.val(), ((authed) ->
    $('#signup-spinner').slideUp('fast')
    if authed
      console.log "Signed In"
    else
      console.log "Not Signed In"
  ))
  $('#signup-spinner').slideDown('fast')

Tenant.register = ->
  Tenant.$signupButton.slideUp()
  API.createAgent(null, Tenant.$email.val(), "abcdefg", Tenant.$password1.val(), ((agent) ->
    $('#signup-spinner').slideUp('slow')
    if agent
      console.log "Registered: " + agent
    else
      console.log "Not registered: " + agent
  ))
  $('#signup-spinner').slideDown('slow')


Tenant.emailKeyUp = ->
  if Tenant.$email.val().match Tenant.emailPattern
    $('#email-spinner').slideDown('fast')
    API.headAgentByEmail(Tenant.$email.val(), ((found) ->
      $('#email-spinner').slideUp('fast')
      if found

        $('#password-confirm-div').slideUp()
        Tenant.$signupButton.slideUp()
        $('#password-div').slideDown()
        Tenant.$signinButton.slideDown()
      else
        $('#password-div').slideUp()
        Tenant.$signinButton.slideUp()
        $('#password-confirm-div').slideDown()
        Tenant.$signupButton.slideDown()
    ))

Tenant.passwordConfirmKeyUp = ->
  Tenant.$signupButton.css("disabled", if Tenant.validatePasswordConfirmation() then "" else "disabled")

$(document).ready ->
  Tenant.$signinButton = $('#signin-button')
  Tenant.$signupButton = $('#signup-button')
  Tenant.$passwords = $('.passwords')
  Tenant.$password = $('#password')
  Tenant.$password1 = $('#password1')
  Tenant.$password2 = $('#password2')
  Tenant.$email = $('#email')

  Tenant.$email.on 'keyup', (event) -> Tenant.emailKeyUp()
  Tenant.$signinButton.on 'click', (event) -> Tenant.signIn()
  Tenant.$signupButton.on 'click', (event) -> Tenant.register()
  Tenant.$password1.on 'keyup', (event) -> Tenant.passwordConfirmKeyUp()
  Tenant.$password2.on 'keyup', (event) -> Tenant.passwordConfirmKeyUp()

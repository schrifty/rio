window.Tenant or= {}

Tenant.emailPattern = /// ^ #begin of line
             ([\w.-]+)         #one or more letters, numbers, _ . or -
             @                 #followed by an @ sign
             ([\w.-]+)         #then one or more letters, numbers, _ . or -
             \.                #followed by a period
             ([a-zA-Z.]{2,6})  #followed by 2 to 6 letters or periods
             $ ///i #end of line and ignore case

Tenant.checkSignInState = ->
  if !Tenant.$email.val() || !Tenant.$password.val()
    Tenant.$signinButton.attr('disabled', 'disabled')
  else
    Tenant.$signinButton.removeAttr('disabled')

Tenant.checkSignUpState = ->
  if Tenant.emailValidation() && Tenant.validatePasswordConfirmation()
    Tenant.$signupButton.removeAttr('disabled')
  else
    Tenant.$signupButton.attr('disabled', 'disabled')

Tenant.emailValidation = ->
  b = Tenant.emailPattern.test Tenant.$emailNew.val()
  console.log b + " : " + Tenant.$emailNew.val()
  return b

Tenant.validatePasswordConfirmation = ->
  return Password.validate(Tenant.$passwordNew) and (Tenant.$passwordNew.val() == Tenant.$passwordConfirm.val())

Tenant.signIn = (onsuccess, onfail) ->
  console.log "signing in!"
  API.createAgentSession(Tenant.$email.val(), Tenant.$password.val(), ((authed) ->
    $('#signin-spinner').slideUp('fast')
    if authed
      onsuccess()
    else
      onfail()
  ))
  $('#signin-spinner').slideDown('fast')

Tenant.signUp = ->
  console.log "signing up! " + Tenant.$emailNew.val()
  API.createAgent(null, Tenant.$emailNew.val(), "abcdefg", Tenant.$passwordNew.val(), ((agent) ->
    $('#signup-spinner').slideUp('fast')
    if agent
      console.log "Registered: " + agent
    else
      console.log "Not registered: " + agent
  ))
  $('#signup-spinner').slideDown('fast')

$(document).ready ->
  Tenant.$email = $('#email')
  Tenant.$password = $('#password')
  Tenant.$signinButton = $('#signin-button')
  Tenant.$emailNew = $('#email-new')
  Tenant.$passwordNew = $('#password-new')
  Tenant.$passwordConfirm = $('#password-confirm')
  Tenant.$signupButton = $('#signup-button')

  Tenant.$email.on 'keyup', (event) ->
    Tenant.checkSignInState()
  Tenant.$password.on 'keyup', (event) ->
    Tenant.checkSignInState()
  Tenant.$signinButton.on 'click', (event) ->
    Tenant.signIn(
      (->
        $('#signin').slideUp()
        $('#menu').slideDown()
      ),
      (->
        console.log("Auth Fail Callback")
      )
    )
  Tenant.$emailNew.on 'keyup', (event) ->
    Tenant.checkSignUpState()
  Tenant.$passwordNew.on 'keyup', (event) ->
    Tenant.checkSignUpState()
  Tenant.$passwordConfirm.on 'keyup', (event) ->
    Tenant.checkSignUpState()
  Tenant.$signupButton.on 'click', (event) ->
    Tenant.signUp()

  # make sure the correct panel is displayed when the page is first loaded
  API.isAuthenticated(
    ( ->
      console.log("User is authenticated")
      $('#menu').slideDown()
    ),
    ( ->
      console.log("User is not authenticated")
      $('#signin').slideDown()
    )
  )

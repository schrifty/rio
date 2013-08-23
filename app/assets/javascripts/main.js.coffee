window.Main or= {}

$(document).ready ->
  Main.$email = $('#email')
  Main.$email.on 'keyup', (event) -> Main.checkSignInState()

  Main.$password = $('#password')
  Main.$password.on 'keyup', (event) -> Main.checkSignInState()

  Main.$signoutLink = $('#signout-link')
  Main.$signoutLink.on 'click', (event) -> Main.signOut(
    (->
      console.log "signed out!"
      Main.$signoutLink.hide()
      Menu.hide()
      $('#signin').slideDown()
    ),
    ((msg) -> console.log("Failed to sign out: " + msg))
  )

  Main.$signinButton = $('#signin-button')
  Main.$signinButton.on 'click', (event) -> Main.signIn(
    (->
      console.log "signed in!"
      Main.$signoutLink.show()
      Menu.show()
      $('#signin').slideUp()
    ),
    ((msg) -> console.log("Failed to sign in: " + msg))
  )

  Main.$showSignupButton = $('#show-signup-button')
  Main.$showSignupButton.on 'click', (event) ->
    $('#signin').slideUp()
    $('#signup').slideDown()

  Main.$showSigninButton = $('#show-signin-button')
  Main.$showSigninButton.on 'click', (event) ->
    $('#signup').slideUp()
    $('#signin').slideDown()

  Main.$emailNew = $('#email-new')
  Main.$emailNew.on 'keyup', (event) -> Main.checkSignUpState()

  Main.$passwordNew = $('#password-new')
  Main.$passwordNew.on 'keyup', (event) -> Main.checkSignUpState()

  Main.$passwordConfirm = $('#password-confirm')
  Main.$passwordConfirm.on 'keyup', (event) -> Main.checkSignUpState()

  Main.$signupButton = $('#signup-button')
  Main.$signupButton.on 'click', (event) -> Main.signUp()

  $('#menu li').on 'click', (event) ->
    $(event.currentTarget).addClass('active').siblings().removeClass('active')
    objStr = event.currentTarget.id.match(/pill-(.*)/)[1]
    classname = "Panel" + objStr.capitalize()
    panelName = "panel-" + objStr
    $('.menu-panel').slideUp()
    $('#' + panelName).slideDown()
    window[classname].init();

  # make sure the correct panel is displayed when the page is first loaded
  AgentAPI.getCurrentAgent(
    ( (agent) ->
      console.log("User is authenticated: " + agent.display_name)
      sessionStorage.setItem('current_user', JSON.stringify(agent))
      console.log JSON.parse(sessionStorage.getItem('current_user')).id
      $('#menu').slideDown()
      $('#signout-link').show()
    ),
    ( ->
      console.log("User is not authenticated")
      $('#signin').slideDown()
      $('#signout-link').hide()
    )
  )

Main.emailPattern = /// ^ #begin of line
             ([\w.-]+)         #one or more letters, numbers, _ . or -
             @                 #followed by an @ sign
             ([\w.-]+)         #then one or more letters, numbers, _ . or -
             \.                #followed by a period
             ([a-zA-Z.]{2,6})  #followed by 2 to 6 letters or periods
             $ ///i #end of line and ignore case

Main.checkSignInState = ->
  if !Main.$email.val() || !Main.$password.val()
    Main.$signinButton.attr('disabled', 'disabled')
  else
    Main.$signinButton.removeAttr('disabled')

Main.checkSignUpState = ->
  if Main.emailValidation() && Main.validatePasswordConfirmation()
    Main.$signupButton.removeAttr('disabled')
  else
    Main.$signupButton.attr('disabled', 'disabled')

Main.emailValidation = ->
  b = Main.emailPattern.test Main.$emailNew.val()
  console.log b + " : " + Main.$emailNew.val()
  return b

Main.validatePasswordConfirmation = ->
  return Password.validate(Main.$passwordNew) and (Main.$passwordNew.val() == Main.$passwordConfirm.val())

Main.signIn = (onsuccess, onfail) ->
  console.log "signing in!"
  AuthAPI.createAgentSession(Main.$email.val(), Main.$password.val(), ((authed) ->
    $('#signin-spinner').slideUp('fast')
    if authed
      onsuccess()
    else
      onfail()
  ))
  $('#signin-spinner').slideDown('fast')

Main.signOut = (onsuccess, onfail) ->
  AuthAPI.destroyAgentSession(onsuccess, onfail)

Main.signUp = ->
  AgentAPI.createAgent(null, Main.$emailNew.val(), "abcdefg", Main.$passwordNew.val(), ((agent) ->
    $('#signup-spinner').slideUp('fast')
    if agent
      console.log "Registered: " + agent
    else
      console.log "Not registered: " + agent
  ))
  $('#signup-spinner').slideDown('fast')



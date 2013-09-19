window.Main or= {}

$(document).ready ->
  Main.$email = $('#email')
  Main.$email.on 'keyup', (event) -> Main.checkSignInState()

  Main.$password = $('#password')
  Main.$password.on 'keyup', (event) -> Main.checkSignInState()

  Main.$signinButton = $('#signin-button')
  Main.$signinButton.on 'click', (event) -> Main.signIn(
    (->
      AvailabilityWidget.show()
      DemoWidget.show()
      MenuMain.show()
      $('#signin').slideUp()
    )
  )

  Main.$signupButton = $('#signup-button')
  Main.$signupButton.on 'click', (event) -> Main.signUp(
    (->
      AvailabilityWidget.show()
      DemoWidget.show()
      MenuMain.show()
      $('#signup').slideUp()
    )
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

  $('#menu-main li').on 'click', (event) -> MenuMain.switchMenuContext(event)
  $('#menu-dashboard li').on 'click', (event) -> MenuDashboard.switchMenuContext(event)

  Main.search = $('#search-submit')
  Main.search.on 'click', (event) -> SearchAPI.query($('#search-text').val(),
    ( (data) ->
      $('#panel-results').html(data)
      Main.switchPanel('results')
    ),
    ( (message) -> console.log "Search failed: " + message )
  )

  Main.cacheAgentInfo(
    ( ->
      AvailabilityWidget.show()
      DemoWidget.show()
      MenuMain.show()
    ),
    ( ->
      AvailabilityWidget.hide()
      DemoWidget.hide()
      MenuMain.hide()
      $('#signin').slideDown()
    )
  )

Main.cacheAgentInfo = (onsuccess, onfail) ->
  AgentAPI.getCurrentAgent(
    ( (agent) ->
      demo_mode = if agent.demo_mode == 1 then 'On' else 'Off'
      sessionStorage.setItem('demo_mode', demo_mode)
      sessionStorage.setItem('current_user', JSON.stringify(agent))
      sessionStorage.setItem('availability', agent.available)
      sessionStorage.setItem('tenant', agent.tenant_id)
      onsuccess()
    ),
    onfail
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
  return b

Main.validatePasswordConfirmation = ->
  return Password.validate(Main.$passwordNew) and (Main.$passwordNew.val() == Main.$passwordConfirm.val())

Main.signIn = (onsuccess, onfail) ->
  AuthAPI.createAgentSession(Main.$email.val(), Main.$password.val(), ((authed) ->
    $('#signin-spinner').slideUp('fast')
    if authed
      Main.cacheAgentInfo(
        ( -> onsuccess() ),
        ( ->
          console.log "Agent was logged in but no agent info was returned"
          onfail()
        )
      )
    else
      console.log "Agent could not be logged in"
      onfail()
  ))
  $('#signin-spinner').slideDown('fast')

Main.signUp = (onsuccess, onfail) ->
  AgentAPI.createAgent(null, Main.$emailNew.val(), "abcdefg", Main.$passwordNew.val(), ((agent) ->
    $('#signup-spinner').slideUp('fast')
    if agent
      Main.cacheAgentInfo(
        ( -> onsuccess() ),
        ( ->
          console.log "Agent was registered but no agent info was returned"
          onfail()
        )
      )
    else
      console.log "Agent could not be registered"
      onfail()
  ))
  $('#signup-spinner').slideDown('fast')

Main.signOut = ->
  AuthAPI.destroyAgentSession(
    ( ->
      AvailabilityWidget.hide()
      MenuMain.hide()
      $('#signin').slideDown()
    ),
    ( (errorThrown) ->
      console.log "Failed to sign out: " + errorThrown
    )
  )

Main.switchPanel = (objStr) ->
  panelName = "panel-" + objStr
  $('.menu-panel').slideUp()
  $('#' + panelName).slideDown()
  window["Panel" + objStr.capitalize()].init()
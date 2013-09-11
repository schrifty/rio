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
      MenuMain.show()
      $('#signin').slideUp()
    )
  )

  Main.$signupButton = $('#signup-button')
  Main.$signupButton.on 'click', (event) -> Main.signUp(
    (->
      AvailabilityWidget.show()
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

  Main.$demoButton = $('#demo-button')
  Main.$demoButton.on 'click', (event) -> Main.toggleDemo()

  Main.cacheAgentInfo(
    ( ->
      AvailabilityWidget.show()
      MenuMain.show()
    ),
    ( ->
      AvailabilityWidget.hide()
      MenuMain.hide()
      $('#signin').slideDown()
    )
  )

Main.cacheAgentInfo = (onsuccess, onfail) ->
  AgentAPI.getCurrentAgent(
    ( (agent) ->
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
  console.log b + " : " + Main.$emailNew.val()
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

Main.toggleDemo = ->
  console.log "before " + sessionStorage.getItem('demo_mode')
  demoEnabled = if sessionStorage.getItem('demo_mode') == '1' then 0 else 1
  console.log "demoEnabled: " + demoEnabled

  current_user = JSON.parse(sessionStorage.getItem('current_user'))
  tenant_id = current_user['tenant_id']
  TenantAPI.updateTenant(tenant_id, { demo_mode: demoEnabled },
    ( (data) ->
      sessionStorage.setItem('demo_mode', demoEnabled )
      strDemoEnabled = if demoEnabled = 0 then "no" else "yes"
      $('#demo-button').text('Demo Mode: ' + strDemoEnabled)
    ),
    ( (msg) -> console.log "unable to update tenant table: " + msg )
  )
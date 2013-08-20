window.Tenant or= {}

$(document).ready ->
  Tenant.$email = $('#email')
  Tenant.$email.on 'keyup', (event) -> Tenant.checkSignInState()

  Tenant.$password = $('#password')
  Tenant.$password.on 'keyup', (event) -> Tenant.checkSignInState()

  Tenant.$signinButton = $('#signin-button')
  Tenant.$signinButton.on 'click', (event) -> Tenant.signIn(
    (-> $('#signin').slideUp(); Menu.init),
    (-> console.log("Auth Fail Callback"))
  )

  Tenant.$emailNew = $('#email-new')
  Tenant.$emailNew.on 'keyup', (event) -> Tenant.checkSignUpState()

  Tenant.$passwordNew = $('#password-new')
  Tenant.$passwordNew.on 'keyup', (event) -> Tenant.checkSignUpState()

  Tenant.$passwordConfirm = $('#password-confirm')
  Tenant.$passwordConfirm.on 'keyup', (event) -> Tenant.checkSignUpState()

  Tenant.$signupButton = $('#signup-button')
  Tenant.$signupButton.on 'click', (event) -> Tenant.signUp()

  Tenant.$pillQuestions = $('#pill-questions')
  Tenant.$panelQuestions = $('#panel-questions')
  Tenant.$pillProfile = $('#pill-profile')
  Tenant.$panelProfile = $('#panel-profile')
  Tenant.$pillUsers = $('#pill-users')
  Tenant.$panelUsers = $('#panel-users')
  Tenant.$pillDashboard = $('#pill-dashboard')
  Tenant.$panelDashboard = $('#panel-dashboard')
  Tenant.$pillSettings = $('#pill-settings')
  Tenant.$panelSettings = $('#panel-settings')

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
    ),
    ( ->
      console.log("User is not authenticated")
      $('#signin').slideDown()
    )
  )

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



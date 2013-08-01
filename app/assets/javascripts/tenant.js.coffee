window.Tenant or= {}

Tenant.emailPattern = /// ^ #begin of line
             ([\w.-]+)         #one or more letters, numbers, _ . or -
             @                 #followed by an @ sign
             ([\w.-]+)         #then one or more letters, numbers, _ . or -
             \.                #followed by a period
             ([a-zA-Z.]{2,6})  #followed by 2 to 6 letters or periods
             $ ///i #end of line and ignore case

Tenant.checkPasswords = ->
  return if Password.validate(Tenant.$password1) and (Tenant.$password1.val() == Tenant.$password2.val())
    Tenant.$signupdiv.css("display", "block")

$(document).ready ->
  Tenant.$signupdiv = $('#signup-button-div')
  Tenant.$passwords = $('.passwords')
  Tenant.$password1 = $('#password1')
  Tenant.$password2 = $('#password2')
  Tenant.$email = $('#email')

  Tenant.$email.on 'keypress', (event) ->
    if Tenant.$email.val().match Tenant.emailPattern
      Tenant.$signupdiv.css("display", "block")

  Tenant.$signupdiv.on 'click', (event) ->
    unless Tenant.checkPasswords()
      Tenant.$signupdiv.slideUp()
      Tenant.$passwords.slideDown()
    else
      $('#signup-spinner').slideDown('slow')
      tenant = API.createTenant = (Tenant.$email)
      agent = API.createAgent(tenant, Tenant.$email, "abcdefg", Tenant.$password1)
      $('#signup-spinner').slideUp('slow')

  Tenant.$password1.on 'keyup', (event) ->
    Tenant.checkPasswords()
  Tenant.$password2.on 'keyup', (event) ->
    Tenant.checkPasswords()

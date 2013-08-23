window.AuthAPI or= {}

AuthAPI.destroyAgentSession = (onsuccess, onfail) ->
  $.ajax '/agents/sign_out',
    type: 'DELETE'
    error: (jqXHR, textStatus, errorThrown) ->
      onfail(textStatus)
    success: ->
      onsuccess()

AuthAPI.createAgentSession = (email, password, oncomplete) ->
  agent = {"email" : email, "password" : password }
  $.ajax '/agents/sign_in',
    data: { "agent" : agent }
    type: 'POST'
    dataType: 'json'
    error: (jqXHR, textStatus, errorThrown) ->
      oncomplete(false)
    success: (data) ->
      oncomplete(true)


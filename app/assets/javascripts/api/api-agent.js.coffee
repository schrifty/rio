window.AgentAPI or= {}

AgentAPI.createAgent = (tenant, email, displayName, password, oncomplete) ->
  agent = {"tenant" : tenant, "email" : email, "display_name" : displayName, "password" : password }
  $.ajax '/agents',
    data: { "agent" : agent }
    type: 'POST'
    dataType: 'json'
    error: (jqXHR, textStatus, errorThrown) ->
      console.log(textStatus)
      oncomplete(null)
    success: (data) ->
      oncomplete(data)

# Validates whether the current user is authenticated or not
AgentAPI.getCurrentAgent = (onsuccess, onfail) ->
  $.ajax '/current_agent',
    dataType: 'json'
    error: (jqXHR, textStatus, errorThrown) ->
      console.log(errorThrown)
      onfail(errorThrown)
    success: (data, textStatus, jqXHR) ->
      onsuccess(data)

AgentAPI.getAgents = (onsuccess, onfail) ->
  $.ajax '/agents',
    dataType: 'json'
    error: (jqXHR, textStatus, errorThrown) ->
      onfail(errorThrown)
    success: (data) ->
      onsuccess(data)

AgentAPI.headAgentByEmail = (email, callback) ->
  $.ajax '/agents',
    data: { "email" : email }
    type: 'HEAD'
    dataType: 'json'
    error: (jqXHR, textStatus, errorThrown) ->
      console.log(textStatus)
      callback(false)
    success: (data, textStatus, jqXHR) ->
      callback(true)

AgentAPI.updateAgent = (id, data, onsuccess, onfail) ->
  $.ajax '/agents/' + id,
    type: 'PUT',
    dataType: 'json',
    data: data,
    error: (jqXHR, textStatus, errorThrown) ->
      onfail(errorThrown)
    success: (data) ->
      onsuccess(data)

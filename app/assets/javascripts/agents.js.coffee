window.AgentAPI or= {}

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

AgentAPI.updateAgent = (id, data, onsuccess, onfail) ->
  $.ajax '/agents/' + id,
    type: 'PUT',
    dataType: 'json',
    data: data,
    error: (jqXHR, textStatus, errorThrown) ->
      onfail(errorThrown)
    success: (data) ->
      onsuccess(data)

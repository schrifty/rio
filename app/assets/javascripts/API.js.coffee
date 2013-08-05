window.API or= {}

API.conversation_id = null
API.since = null

API.createTenant = (email, display_name) ->
  tenant = { "email" : email, "display_name" : display_name }
  $.ajax '/tenants',
    data: { "tenant" : tenant }
    type: 'POST'
    dataType: 'json'
    error: (jqXHR, textStatus, errorThrown) ->
      console.log(textStatus)
      return false
    success: (data) ->
      return true

API.createAgent = (tenant, email, displayName, password, oncomplete) ->
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

API.createAgentSession = (email, password, oncomplete) ->
  agent = {"email" : email, "password" : password }
  $.ajax '/agents/sign_in',
    data: { "agent" : agent }
    type: 'POST'
    dataType: 'json'
    error: (jqXHR, textStatus, errorThrown) ->
      console.log(textStatus)
      oncomplete(false)
    success: (data) ->
      oncomplete(true)

API.headAgentByEmail = (email, callback) ->
  $.ajax '/agents',
    data: { "email" : email }
    type: 'HEAD'
    dataType: 'json'
    error: (jqXHR, textStatus, errorThrown) ->
      console.log(textStatus)
      callback(false)
    success: (data, textStatus, jqXHR) ->
      callback(true)

API.getUpdates = ->
  if (API.conversation_id)
    $.ajax '/updates',
      data: {
        since: API.since,
        conversation: API.conversation_id
      }
      dataType: 'json'
      error: (jqXHR, textStatus, errorThrown) ->
        console.log(textStatus)
      success: (data) ->
        Display.update(data)
  setTimeout(API.getUpdates, 2000)

# sendMessage just returns the messages array - use g
API.sendMessage = (text_selector) ->
  conversation_id = $('#conversation-id').val() || API.conversation_id
  agent_id = $('#agent-id').val()
  username = $('#username').val()
  text = $(text_selector).val()
  message = {"since": API.since, "tenant_id": "1", "text": text, "conversation_id": conversation_id, "agent_id": agent_id, "display_name": username, "referer_url": "http://blah.com", "location": "Mozarts"};
  $.ajax '/messages',
    data: {message: message},
    type: 'POST',
    dataType: 'json',
    error: (jqXHR, textStatus, errorThrown) ->
      console.log(textStatus)
    success: (data) ->
      console.log data
      Display.update({messages: data})

$(document).ready ->
  API.getUpdates();
  $('#chat-table-div textarea').on 'keypress', (event) ->
    if event.keyCode == 13
      API.sendMessage('#chat-table-div textarea')
      $('#chat-table-div textarea').val("")

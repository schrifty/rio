window.MessageAPI ||= {}

# sendMessage just returns the messages array - use g
MessageAPI.sendMessage = (text_selector) ->
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
      console.log(errorThrown)
    success: (data) ->
      console.log data
      Display.update({messages: data})

MessageAPI.getMessages = (conversation_id, limit, onsuccess, onfail) ->
  $.ajax '/messages',
    data: {conversation: conversation_id, limit: limit},
    dataType: 'json',
    error: (jqXHR, textStatus, errorThrown) ->
      onfail(errorThrown)
    success: (data) ->
      onsuccess(data)

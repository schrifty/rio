window.MessageAPI ||= {}

# sendMessage just returns the messages array - use g
MessageAPI.sendMessage = (message) ->
  $.ajax '/messages',
    data: {message: message},
    type: 'POST',
    dataType: 'json',
    error: (jqXHR, textStatus, errorThrown) ->
      console.log(errorThrown)
    success: (data) ->
      console.log data

MessageAPI.getMessages = (conversation_id, limit, onsuccess, onfail) ->
  $.ajax '/messages',
    data: {conversation: conversation_id, limit: limit},
    dataType: 'json',
    error: (jqXHR, textStatus, errorThrown) ->
      onfail(errorThrown)
    success: (data) ->
      onsuccess(data)

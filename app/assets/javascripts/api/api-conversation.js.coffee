window.ConversationAPI ||= {}

ConversationAPI.getConversations = (onsuccess, onfail) ->
  $.ajax '/conversations', # active, pending or dropped
    dataType: 'json'
    error: (jqXHR, textStatus, errorThrown) ->
      onfail(errorThrown)
    success: (data) ->
      onsuccess(data)

ConversationAPI.createConversation = (conversation, onsuccess, onfail) ->
  $.ajax '/conversations',
    dataType: 'json',
    type: 'POST',
    data: {conversation: conversation},
    error: (jqXHR, textStatus, errorThrown) ->
      onfail(errorThrown)
    success: (data) ->
      onsuccess(data)

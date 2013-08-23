window.API or= {}

API.conversation_id = null
API.since = null

$(document).ready ->
  API.getUpdates();
  $('#chat-table-div textarea').on 'keypress', (event) ->
    if event.keyCode == 13
      MessageAPI.sendMessage('#chat-table-div textarea')
      $('#chat-table-div textarea').val("")

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
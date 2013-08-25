window.PollerAPI ||= {}

PollerAPI.conversation_id = null
PollerAPI.since = null

$(document).ready ->
  PollerAPI.getUpdates();
  $('#chat-table-div textarea').on 'keypress', (event) ->
    if event.keyCode == 13
      MessageAPI.sendMessage('#chat-table-div textarea')
      $('#chat-table-div textarea').val("")

PollerAPI.getUpdates = ->
  if (PollerAPI.conversation_id)
    $.ajax '/updates',
      data: {
        since: PollerAPI.since,
        conversation: PollerAPI.conversation_id
      }
      dataType: 'json'
      error: (jqXHR, textStatus, errorThrown) ->
        console.log(textStatus)
      success: (data) ->
        Display.update(data)
  setTimeout(PollerAPI.getUpdates, 2000)
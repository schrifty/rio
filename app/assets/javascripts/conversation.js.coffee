# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.Chat or= {}

Chat.sendMessage = () ->
  conversation_id = Chat.conversation_id || $('#conversation-id').val();
  message = {"since": Chat.since, "tenant_id": "1", "text": $('#new-message').val(), "conversation_id": conversation_id, "agent_id": $('#agent-id').val(), "display_name": $('#username').val(), "referer_url": "http://blah.com", "location": "Mozarts"};
  $.ajax "/messages",
    data: {message: message},
    type: 'POST',
    dataType: "json",
    error: (jqXHR, textStatus, errorThrown) ->
      console.log(textStatus)
    success: (data) ->
      Chat.insertMessages(data);

Chat.insertMessages = (data) ->
  console.log data;
  for message in data
    html = "<tr><td class=\"author-block\"><p>" + message["display_name"] + "</p></td><td class=\"message-block\"><p>" + message["text"] + "</p></td></tr>";
    $('#chat-table tbody').append(html);
    Chat.since = message["created_at"];
    Chat.conversation_id = message["conversation_id"];
    $('#conversation-id').val(message["conversation_id"]);




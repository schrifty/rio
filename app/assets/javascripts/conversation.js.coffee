window.Chat or= {}

Chat.getNewMessages = ->
  if (Chat.conversation_id)
    $.ajax '/updates',
      data: {
        since: Chat.since,
        conversation: Chat.conversation_id
      }
      dataType: 'json'
      error: (jqXHR, textStatus, errorThrown) ->
        console.log(textStatus)
      success: (data) ->
        Chat.updateDisplay(data)
  setTimeout(Chat.getNewMessages, 1000)

Chat.sendMessage = () ->
  conversation_id = $('#conversation-id').val() || Chat.conversation_id
  message = {"since": Chat.since, "tenant_id": "1", "text": $('#message-textarea').val(), "conversation_id": conversation_id, "agent_id": $('#agent-id').val(), "display_name": $('#username').val(), "referer_url": "http://blah.com", "location": "Mozarts"};
  $.ajax '/messages',
    data: {message: message},
    type: 'POST',
    dataType: 'json',
    error: (jqXHR, textStatus, errorThrown) ->
      console.log(textStatus)
    success: (data) ->
      Chat.updateDisplay( {messages: data} )

Chat.updateDisplay = (data) ->
  console.log data
  if data['messages'].length > 0
    last_message = data['messages'][data['messages'].length - 1]
    Chat.since = last_message['created_at'];
    Chat.conversation_id = last_message['conversation_id']
    $('#conversation-id').val(Chat.conversation_id);
    for message in data['messages']
      html = '<tr><td class="author-block"><p>' + message['display_name'] + '</p></td><td class="message-block"><p>' + message['text'] + '</p></td></tr>';
      $('#chat-table tbody').append(html);

  if data['agents']
    engaged_agent_id = data['conversation']['engaged_agent_id']
    target_agent_id = data['conversation']['target_agent_id']
    html = ""
    for agent in data['agents']
      console.log "agent_id: " + agent['id'] + "   engaged_agent_id: " + engaged_agent_id + "   target_agent_id: " + target_agent_id
      if (agent['id'] == engaged_agent_id)
        agent_class = 'engaged-agent-block'
      else if agent['id'] == target_agent_id
        agent_class = 'targeted-agent-block'
      else
        agent_class = 'agent-block'
      html = html + "<li id=\"" + agent['id'] + "\" class=\"" + agent_class + "\">" + agent['display_name'] + '</li>';
    $('#agent-list').html(html)

$(document).ready ->
  Chat.getNewMessages();




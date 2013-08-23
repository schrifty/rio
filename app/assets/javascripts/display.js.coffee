window.Display or= {}

Display.update = (data) ->
  console.log data
  if data['messages'].length > 0
    last_message = data['messages'][data['messages'].length - 1]
    API.since = last_message['created_at']
    API.conversation_id = last_message['conversation_id']
    $('#conversation-id').val(API.conversation_id)
    for message in data['messages']
      html = '<tr><td class="author-block"><p>' + message['display_name'] + '</p></td><td class="message-block"><p>' + message['text'] + '</p></td></tr>';
      $('#chat-table tbody').append(html)
      objDiv = $("#chat-table-div")
      objDiv.scrollTop(objDiv[0].scrollHeight);

  if data['agents']
    engaged_agent_id = data['conversation']['engaged_agent_id']
    target_agent_id = data['conversation']['target_agent_id']
    html = ""
    for agent in data['agents']
      console.log "agent_id: " + agent['id'] + "   engaged_agent_id: " + engaged_agent_id + "   target_agent_id: " + target_agent_id
      if (agent['id'] == engaged_agent_id)
        button_class = 'btn-danger'
        button_icon = 'icon-mobile'
      else if agent['id'] == target_agent_id
        button_class = 'btn-primary'
        button_icon = 'icon-phone'
      else
        button_class = 'btn-success'
        button_icon = ''
      html = html + "<li id=\"" + agent['id'] + "\"><a class=\"btn btn-large\ " + button_class + "\" onclick=\"MessageAPI.sendMessage\"><i class=\"" + button_icon + "\"></i> " + agent['display_name'] + '</a></li>';
    $('#agent-list').html(html)

  $('#chat-table-div').css("display", "block")
  $('#submit-button-div').slideUp()





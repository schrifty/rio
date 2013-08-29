window.PanelQuestions or= {}

PanelQuestions.initted = false

$(document).ready ->
  $('#panel-questions > table > tbody').on 'click', (event) ->
    $row = $(event.target).closest('.conversation')
    convId = $row.data("conv-id")
    if $row.hasClass("expanded")
      PanelQuestions.loadMessages(convId, 3)
      $row.removeClass("expanded")
    else
      PanelQuestions.loadMessages(convId, -1)
      $row.addClass("expanded")

PanelQuestions.init = () ->
  unless PanelQuestions.initted
    ConversationAPI.getConversations(
      ( (data) ->
        PanelQuestions.loadConversations(data)
        PanelQuestions.initted = true
      ),
      ( (msg) -> console.log 'Failed to get conversations [' + msg + ']' )
    )

PanelQuestions.loadConversations = (data) ->
  $body = $('#panel-questions tbody')
  $body.empty()
  for conversation in data
    html = '<tr class="conversation" data-conv-id="' + conversation.id + '"">
        <td class="conversation-summary">
          <span class="agent">' + conversation.engaged_agent_name + '</span> is assisting
          <span class="customer">' + conversation.customer_display_name + '</span></td>
      </tr>
      <tr class="conversation" data-conv-id="' + conversation.id + '">
        <td>
          <table id="message-table">
            <colgroup>
              <col class="message-author" span="1">
              <col class="message-text" span="1">
              <col class="message-created-at" span="1">
            </colgroup>
            <tbody id="conversation-' + conversation.id + '">
            </tbody>
          </table>
        </td>
      </tr>'
    $body.append(html)
    $('.prettydate').prettyDate(5)
    PanelQuestions.loadMessages(conversation.id, 3)

PanelQuestions.loadMessages = (convId, limit) ->
  console.log "Got called with convId[" + convId + "] and limit [" + limit + "]"
  MessageAPI.getMessages(convId, limit,
    ( (data) ->
      $body = $('#conversation-' + convId)
      $body.empty()
      html = ""
      for message in data
        html += PanelQuestions.getMessageHTML(message.author_role, message.display_name, message.text, message.created_at)
      $body.append(html)
    ),
    ( (msg) -> console.log "Failed to get messages: " + msg )
  )

PanelQuestions.getMessageHTML = (author_role, author_display_name, text, created_at) ->
  return '
    <tr>
      <td class="message-author-' + author_role + '">' + author_display_name + ':</td>
      <td>' + text + '</td>
      <td>' + $.formatDateTime('g:ii a', new Date(created_at)) + '</td>
    </tr>'

PanelQuestions.messageNotificationHandler = (message) ->
  console.log "Questions Panel received a new message"
  role = if message.agent_id == null then "customer" else "agent"
  html = PanelQuestions.getMessageHTML(role, message.display_name, message.text, message.created_at)
  $body = $('#conversation-' + message.conversation_id)
  $body.append(html)

PanelQuestions.conversationNotificationHandler = (conversation) ->
  console.log "Questions Panel received a new conversation"

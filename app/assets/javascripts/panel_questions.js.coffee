window.PanelQuestions or= {}

$(document).ready ->
  $('#panel-questions > table > tbody').on 'click', (event) ->
    $row = $(event.target).closest('.conversation')
    convId = $row.data("conv-id")
    if $row.hasClass("expanded")
      PanelQuestions.loadMessages(convId, 1)
      $row.removeClass("expanded")
    else
      PanelQuestions.loadMessages(convId, -1)
      $row.addClass("expanded")

PanelQuestions.init = () ->
  ConversationAPI.getConversations(
    ( (data) -> PanelQuestions.loadConversations(data) ),
    ( (msg) -> console.log 'Failed to get conversations [' + msg + ']' )
  )

PanelQuestions.loadConversations = (data) ->
  $body = $('#panel-questions tbody')
  $body.empty()
  for conversation in data
    html = '<tr class="conversation" data-conv-id="' + conversation.id + '"">
        <td>' + conversation.customer_display_name + '</td>
        <td>' + conversation.engaged_agent_name + '</td>
      </tr>
      <tr class="conversation" data-conv-id="' + conversation.id + '">
        <td colspan="3">
          <table>
            <colgroup>
              <col class="message-author" span="1">
              <col class="message-text" span="1">
              <col class="message-created-at" span="1">
            </colgroup>
            <tbody id="conversation-' + conversation.id + '">
              ' + PanelQuestions.getMessageRow(conversation.last_message_author_role, conversation.last_message_author_display_name,
                  conversation.last_message_text, conversation.last_message_created_at) + '
            </tbody>
          </table>
        </td>
      </tr>'
    $body.append(html)
    $('.prettydate').prettyDate(5)

PanelQuestions.loadMessages = (convId, limit) ->
  MessageAPI.getMessages(convId, Math.min(limit, 5),
    ( (data) ->
      $body = $('#conversation-' + convId)
      $body.empty()
      html = ""
      for message in data
        console.log "adding a message!"
        html += PanelQuestions.getMessageRow(message.author_role, message.display_name, message.text, message.created_at)
      $body.append(html)
    ),
    ( (msg) -> console.log "Failed to get messages: " + msg )
  )

PanelQuestions.getMessageRow = (author_role, author_display_name, text, created_at) ->
  return '
    <tr>
      <td class="message-author-' + author_role + '">' + author_display_name + ':</td>
      <td>' + text + '</td>
      <td>' + $.formatDateTime('g:ii a', new Date(created_at)) + '</td>
    </tr>'


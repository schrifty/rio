window.PanelQuestions or= {}

$(document).ready ->
  row = $(event.target).closest('tr')
  PanelQuestions.loadMessages(row, 1)

  $('#panel-questions').on 'click', (event) ->
    row = $(event.target).closest('tr')
    if row.hasClass("expanded")
      PanelQuestions.loadMessages(row, 1)
      row.removeClass("expanded")
    else
      PanelQuestions.loadMessages(row, -1)
      row.addClass("expanded")

PanelQuestions.init = () ->
  ConversationAPI.getConversations(
    ( (data) -> PanelQuestions.loadConversations(data) ),
    ( (msg) -> console.log 'Failed to get conversations [' + msg + ']' )
  )

PanelQuestions.loadConversations = (data) ->
  $body = $('#panel-questions tbody')
  $body.empty()
  for conversation in data
    $newrow = $('<tr conv-id="' + conversation.id + '" message-count="' + conversation.message_count + '">')
    $newrow.append($('<td>').text(conversation.customer_display_name))

    col = $('<td>')
    col.append('Last message by: ')
    col.append('<span class="author-display-name">' + conversation.last_message_author_display_name + '</span>')
    col.append(', ')
    col.append('<span class="prettydate" title="' + conversation.last_message_created_at + '">')
    if conversation.message_count > 1
      col.append(', ')
      col.append('<span class="message-count">' + conversation.message_count + '</span>')
      col.append(' messages')
    col.append('<table id="' + conversation.id + '" message-count="' + conversation.message_count + '" class="details"><tbody></tbody></table>')
    $newrow.append(col)
    $body.append($newrow)
    $('.prettydate').prettyDate(5)

PanelQuestions.loadMessages = ($row, limit) ->
  MessageAPI.getMessages($row.attr('conv-id'), limit,
    ( (data) ->
      $details = $($row.find('table.details'))
      $details.empty()

      for message in data
        $newrow = $('<tr>')
        col = $('<td>')
        col.append('<span class="' + message.author_class + '">' + message.display_name + '</span>' + ': ')
        $newrow .append(col)
        col = $('<td>')
        col.append(message.text)
        $newrow .append(col)
        col = $('<td>')
        col.append('<span class="created_at">' + message.created_at+ '</span>')
        col.formatDateTime('d-M g:ii a')
        $newrow .append(col)
        $details.append($newrow)
        $('#example').formatDateTime('mm/dd/y g:ii a');
    ),
    ( (msg) -> console.log "Failed to get messages: " + msg )
  )




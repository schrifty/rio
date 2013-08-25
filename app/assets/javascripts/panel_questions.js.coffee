window.PanelQuestions or= {}

$(document).ready ->
  $('#panel-questions').on 'click', (event) ->
    details = $(event.target).find('table.details')[0]
    if $(details).is(':visible')
      $(details).hide()
    else
      MessageAPI.getMessages(details.id,
        ( (data) ->
          PanelQuestions.paintConversation($(details), data)
          $(details).show()
        ),
        ( (msg) -> console.log msg )
      )

PanelQuestions.init = () ->
  ConversationAPI.getConversations(
    ( (data) -> PanelQuestions.populate(data) ),
    ( (msg) -> console.log 'Failed to get conversations [' + msg + ']' )
  )

PanelQuestions.paintConversation = ($details_div, data) ->
  $body = $($details_div.find('tbody')[0])
  $body.empty()
  for message in data
    $newrow = $('<tr>')
    $newrow.append($('<td>').text(message.text))
    $body.append($newrow)

PanelQuestions.populate = (data) ->
  $body = $('#panel-questions tbody')
  $body.empty()
  for conversation in data
    $newrow = $('<tr>')
    $newrow.append($('<td>').text(conversation.customer_display_name))

    col = $('<td>')
    col.append(conversation.last_message.text)
    col.append('<br>')
    col.append('<span class="author-display-name">' + conversation.last_message_author_display_name + '</span>')
    col.append(', ')
    col.append('<span class="prettydate" title="' + conversation.last_message_created_at + '">')
    col.append(', ')
    col.append('<span class="message-count">' + conversation.message_count + '</span>')
    col.append(' messages')
    col.append('<table id="' + conversation.id + '" class="details"><tbody></tbody></table>')
    $newrow.append(col)

    $body.append($newrow)
    $('.prettydate').prettyDate(5)




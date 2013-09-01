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
  $('.prettydate').prettyDate(5)

PanelQuestions.init = () ->
  unless PanelQuestions.initted
    PanelQuestions.initted = true

PanelQuestions.conversationNotificationHandler = (conversation) ->
  conversationJSON = JSON.parse(conversation)
  newConvRow = $('#conversation-template').clone()
  newConvRow.attr('id', 'conversation-' + conversationJSON.id)
  newConvHTML = newConvRow.get(0).outerHTML.
    replace(/XCONVID/g, conversationJSON.id).
    replace(/XCONVENGAGEDNAME/g, conversationJSON.engaged_agent_name).
    replace(/XCONVCUSTOMERDISPLAYNAME/g, conversationJSON.customer_display_name)
  $('#conversations-body').prepend(newConvHTML)

PanelQuestions.messageNotificationHandler = (message) ->
  messageJSON = JSON.parse(message)

  # build the HTML for the new message, starting with the template we get from the server so we don't have to keep the
  # server and the client in sync on the correct DOM structure
  newMessageRow = $('#message-template').clone()
#  newMessageRow.hide()
  newMessageRow.removeAttr('id')
  newMessageHTML = newMessageRow.get(0).outerHTML.
    replace(/MESSAGEAUTHORROLE/g, messageJSON.author_role).
    replace(/MESSAGEAUTHORDISPLAYNAME/g, messageJSON.author_display_name).
    replace(/MESSAGETEXT/g, messageJSON.text).
    replace(/MESSAGECREATEDAT/g, $.formatDateTime('g:ii a', new Date(messageJSON.created_at)))
  newMessageRow.remove()

  # figure out if the conversation needs to be moved to the top of the table
  $row = $('#conversation-' + messageJSON.conversation_id)
  $messageBody = $('#messages-body-' + messageJSON.conversation_id)
  index = $('#conversations-body').children().index($row)
  console.log "Looking for: " + $row.get()
  console.log index
  if index > 0
    $row.hide()
    $newMessage = $(newMessageHTML).appendTo($messageBody)
    $firstRow = $row.parent().find("tr:first")
    $row.insertBefore($firstRow)
    $row.slideDown('slow')
  else
    $newMessage = $(newMessageHTML).appendTo($messageBody)
    $newMessage.show()
  $newMessage.delay( 400 ).addClass('complete')


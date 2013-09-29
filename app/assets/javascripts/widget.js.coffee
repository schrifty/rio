window.Widget or= {}

Widget.initted = false
Widget.conversation_id = null

$(document).ready ->
  Widget.$sendMessageButton = $('#send-message-button')
  Widget.$sendMessageButton.on 'click', (event) ->
    # display spinner
    Widget.createMessage()

  if $("body").data("page") == "conversations#new"
    Widget.init()

Widget.createConversation = (onsuccess, onfail) ->
  # this call will implicitly create a customer
  # TODO: pass in a customer display name if we have one - it will be used to seed the customer object
  sessionStorage.setItem('tenant', 1) unless sessionStorage.getItem('tenant')
  data = { tenant_id: sessionStorage.getItem('tenant') }
  ConversationAPI.createConversation(data,
    ((conv) ->
      # clear spinner
      sessionStorage.setItem("conversation", conv[0]["id"])
      console.log "New Conversation [" + conv[0]["id"] + "]"
      onsuccess()
    ),
    ((error) ->
      # clear spinner
      console.log "Unable to create conversation: " + error
      onfail()
    )
  )

Widget.createMessage = () ->
  console.log "HERE: " +  $(".textwrapper textarea")[0].value
  data = {tenant_id: sessionStorage.getItem('tenant'), conversation_id: sessionStorage.getItem('conversation'), text: $(".textwrapper textarea")[0].value }
  MessageAPI.sendMessage(data,
    ( (message) ->
      console.log "New Message [" + message[0]["id"] + "]"
    ),
    ( (error) ->
      console.log "Unable to create message: " + error
    )
  )

Widget.displayMessage = (message) ->
  newMessageRow = $('#message-template').clone()
  newMessageRow.removeAttr('id')
  newMessageHTML = newMessageRow.get(0).outerHTML.
    replace(/MESSAGEAUTHORROLE/g, message.author_role).
    replace(/MESSAGEAUTHORDISPLAYNAME/g, message.author_display_name).
    replace(/MESSAGETEXT/g, message.text).
    replace(/MESSAGECREATEDAT/g, $.formatDateTime('g:ii a', new Date(message.created_at)))
  newMessageRow.remove()
  $newMessage = $(newMessageHTML).appendTo($('#messages-body'))
  $newMessage.show()
  $newMessage.delay( 400 ).addClass('complete')

Widget.init = ->
  unless PanelUsers.initted
    # the widget comes with a hardcoded tenant which gets embedded into the partial when we load the iframe - put it into
    # session storage
    Widget.createConversation(
      ( ->
        message = {
          conversation_id: sessionStorage.getItem("conversation"),
          author_role: 'system',
          author_display_name: 'ReplyStyle',
          created_at: new Date(),
          text: 'Hold on while I find an agent to speak with you!'
        }
        Widget.displayMessage(message)
      )
    )
    PanelUsers.initted = true

Widget.messageNotificationHandler = (message) ->
  Widget.displayMessage(JSON.parse(message))
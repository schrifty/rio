$(document).ready ->
  tenant_id = sessionStorage.getItem('tenant')
  dispatcher = new WebSocketRails('localhost:3001/websocket')

  # Subscribe to conversations
  channel_name = 'conversations-tenant-' + tenant_id
  channel = dispatcher.subscribe(channel_name)
  channel.bind('new', (conversation) ->
    console.log 'a new conversation has arrived! ' + JSON.stringify(conversation)
    for element in $('.menu-panel')
      classname = "Panel" + element.id.match(/panel-(.*)/)[1].capitalize()
      window[classname].conversationNotificationHandler(conversation)
  )

  # Subscribe to messages
  channel_name = 'messages-tenant-' + tenant_id
  channel = dispatcher.subscribe(channel_name)
  channel.bind('new', (message) ->
    console.log 'a new message has arrived! ' + JSON.stringify(message)
    for element in $('.menu-panel')
      classname = "Panel" + element.id.match(/panel-(.*)/)[1].capitalize()
      window[classname].messageNotificationHandler(message)
  )
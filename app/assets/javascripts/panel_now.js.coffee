window.PanelNow ||= {}

PanelNow.initted = false

PanelNow.init = ->
  console.log "initting PanelNow"
  unless PanelNow.initted
    PanelNow.initted = true

PanelNow.messageNotificationHandler = (message) ->
PanelNow.conversationNotificationHandler = (conversation) ->

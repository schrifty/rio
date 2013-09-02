window.PanelTrends ||= {}

PanelTrends.initted = false

PanelTrends.init = ->
  console.log "initting panelTrends"
  unless PanelTrends.initted
    PanelTrends.initted = true

PanelTrends.messageNotificationHandler = (message) ->
PanelTrends.conversationNotificationHandler = (conversation) ->

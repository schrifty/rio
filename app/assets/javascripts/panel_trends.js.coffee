window.PanelTrends ||= {}

PanelTrends.initted = false

PanelTrends.init = ->
  console.log "initting panelTrends"
  unless PanelTrends.initted
    PanelTrends.initted = true

PanelTrends.messageNotificationHandler = (message) -> # noop
PanelTrends.conversationNotificationHandler = (conversation) -> # noop
PanelTrends.agentNotificationHandler = (agent) -> # noop
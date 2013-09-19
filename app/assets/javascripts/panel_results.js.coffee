window.PanelResults or= {}

PanelResults.initted = false

PanelResults.init = ->
  unless PanelProfile.initted
    PanelResults.initted = true

PanelResults.messageNotificationHandler = (message) -> # noop
PanelResults.conversationNotificationHandler = (conversation) -> # noop
PanelResults.agentNotificationHandler = (agent) -> # noop

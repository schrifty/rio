window.PanelSettings ||= {}

PanelSettings.initted = false

PanelSettings.init = ->
  unless PanelSettings.initted
    PanelSettings.initted = true

PanelSettings.messageNotificationHandler = (message) -> # noop
PanelSettings.conversationNotificationHandler = (conversation) -> # noop
PanelSettings.agentNotificationHandler = (agent) -> # noop

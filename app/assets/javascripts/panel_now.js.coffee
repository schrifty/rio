window.PanelNow ||= {}

PanelNow.initted = false

PanelNow.init = ->
  unless PanelNow.initted
    PanelNow.initted = true

PanelNow.messageNotificationHandler = (message) -> # noop
PanelNow.conversationNotificationHandler = (conversation) -> # noop
PanelNow.agentNotificationHandler = (agent) -> # noop
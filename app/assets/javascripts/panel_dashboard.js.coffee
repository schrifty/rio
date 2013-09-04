window.PanelDashboard ||= {}

PanelDashboard.initted = false

PanelDashboard.init = ->
  unless PanelDashboard.initted
    PanelDashboard.initted = true

PanelDashboard.messageNotificationHandler = (message) -> # noop
PanelDashboard.conversationNotificationHandler = (conversation) -> # noop
PanelDashboard.agentNotificationHandler = (agent) -> # noop

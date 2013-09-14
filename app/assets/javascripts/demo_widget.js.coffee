window.DemoWidget ||= {}

$(document).ready ->
  # start demo
  DemoWidget.$on = $('#demo-on')
  DemoWidget.$on.on 'click', (event) -> DemoWidget.updateTenant('On')

  # pause demo
  DemoWidget.$pause = $('#demo-pause')
  DemoWidget.$pause.on 'click', (event) -> DemoWidget.updateTenant('Paused')

  # stop demo - deletes all demo data
  DemoWidget.$off = $('#demo-off')
  DemoWidget.$off.on 'click', (event) -> DemoWidget.updateTenant('Off')

  DemoWidget.$button = $('#demo-button')
  DemoWidget.$label = $('#demo-button-label')
  DemoWidget.$widget = $('#demo-widget')

DemoWidget.updateTenant = (status) ->
  # make demo mode a string in the db
  intStatus = if status == 'On' then 1 else 0
  tenant_id = sessionStorage.getItem('tenant')
  TenantAPI.updateTenant(tenant_id, { demo_mode: intStatus },
    ( (data) ->
      sessionStorage.setItem('demo', status)
      DemoWidget.$button.removeClass('btn-default').removeClass('btn-info').removeClass('btn-warning')
      DemoWidget.show()
    ),
    ( (msg) -> console.log "unable to update tenant table: " + msg )
  )

DemoWidget.show = () ->
  demo_status = sessionStorage.getItem('demo')
  DemoWidget.$label.text("Demo " + demo_status)
  DemoWidget.$on.show()
  DemoWidget.$pause.show()
  DemoWidget.$off.show()
  if demo_status == "On"
    DemoWidget.$button.removeClass('btn-info').addClass('btn-warning')
    DemoWidget.$on.hide()
  else if demo_status == "Paused"
    DemoWidget.$button.removeClass('btn-warning').addClass('btn-info')
    DemoWidget.$pause.hide()
  else
    DemoWidget.$button.removeClass('btn-warning').addClass('btn-info')
    DemoWidget.$off.hide()
  DemoWidget.$widget.slideDown()

DemoWidget.hide = () ->
  DemoWidget.$widget.slideUp()

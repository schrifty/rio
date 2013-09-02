window.MenuDashboard or= {}

MenuDashboard.switchMenuContext = (event) ->
  $(event.currentTarget).addClass('active').siblings().removeClass('active')
  objStr = event.currentTarget.id.match(/pill-(.*)/)[1]
  classname = "Panel" + objStr.capitalize()
  panelName = "panel-" + objStr
  $('.dashboard-menu-panel').slideUp()
  $('#' + panelName).slideDown()
  window[classname].init();
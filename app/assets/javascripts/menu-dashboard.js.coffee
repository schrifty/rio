window.MenuDashboard or= {}

MenuDashboard.switchMenuContext = (event) ->
  $(event.currentTarget).addClass('active').siblings().removeClass('active')
  objStr = event.currentTarget.id.match(/pill-(.*)/)[1]
  classname = "Panel" + objStr.capitalize()
  panelName = "panel-" + objStr
  $('.dashboard-menu-panel').slideUp()
  $('#' + panelName).slideDown()
  window[classname].init();

MenuDashboard.show = ->
  $('#menu-dashboard').slideDown()
  # make sure the correct panel is displayed when the page is first loaded
  # TODO pull up the most recent panel
  $('#pill-now').click()

MenuDashboard.hide = ->
  $('#menu-dashboard').slideUp()
  $('.dashboard-menu-panel').slideUp()

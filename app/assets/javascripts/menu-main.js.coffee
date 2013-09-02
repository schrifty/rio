window.MenuMain or= {}

MenuMain.switchMenuContext = (event) ->
  $(event.currentTarget).addClass('active').siblings().removeClass('active')
  objStr = event.currentTarget.id.match(/pill-(.*)/)[1]
  classname = "Panel" + objStr.capitalize()
  panelName = "panel-" + objStr
  $('.menu-panel').slideUp()
  $('#' + panelName).slideDown()
  window[classname].init();

MenuMain.show = ->
  $('#menu-main').slideDown()

  # make sure the correct panel is displayed when the page is first loaded
  # TODO pull up the most recent panel
  $('#pill-questions').click()

MenuMain.hide = ->
  $('#menu-main').slideUp()
  $('.menu-panel').slideUp()

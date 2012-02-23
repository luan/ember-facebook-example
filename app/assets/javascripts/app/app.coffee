App = Em.Namespace.create(Em.Facebook)
App.set 'appId', '249511985086492'

App.NavState = Em.LayoutState.extend
  navSelector: '.navbar .nav'
  enter: (stateManager, transition) ->
    @_super stateManager, transition
    $nav = $(@get 'navSelector')
    $nav.children().removeClass('active')
    selector = @get('selector') or ".#{@get('path')}"
    $nav.find(selector).addClass('active')

App.main = Em.LayoutView.create
    templateName: 'app/templates/layouts/main'

App.routeManager = Em.RouteManager.create
    rootLayout: App.main
    home: App.NavState.create
      selector: '.home'
      path: ''
      viewClass: Em.View.extend
        templateName: 'app/templates/home/index'
        test: 'home'
    layoutNesting: App.NavState.create
      selector: '.layout-nesting'
      path: 'layout-nesting'
      viewClass: Em.View.extend
        templateName: 'app/templates/home/index'
        test: 'nest'

App.main.appendTo('body');

@App = App
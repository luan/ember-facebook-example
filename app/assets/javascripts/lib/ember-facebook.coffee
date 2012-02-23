Ember.Facebook = Ember.Mixin.create
  FBUser: undefined
  appId: undefined
  fetchPicture: true

  appIdChanged: (->
    @removeObserver('appId')
    window.fbAsyncInit = => @fbAsyncInit()
  
    $ ->
      js = document.createElement 'script'

      $(js).attr
        id: 'facebook-jssdk'
        async: true
        src: "//connect.facebook.net/en_US/all.js"

      $('head').append js
  ).observes('appId')

  fbAsyncInit: ->
    FB.init
      appId:  @get 'appId'
      status: true
      cookie: true
      xfbml:  true

    @set 'FBloading', true
    FB.getLoginStatus (response) => @updateFBUser(response)

  updateFBUser: (response) ->
    if response.status is 'connected'
        FB.api '/me', (user) =>
          FBUser = user
          FBUser.accessToken = response.authResponse.accessToken

          if @get 'fetchPicture'
            FB.api '/me/picture', (path) =>
              FBUser.picture = path
              @set 'FBUser', FBUser
              @set 'FBloading', false
          else
            @set 'FBUser', FBUser
            @set 'FBloading', false
    else
      @set 'FBUser', false
      @set 'FBloading', false

Ember.FacebookView = Ember.View.extend
  classNameBindings: ['className']
  
  init: ->
    @_super()
    @set 'className', "fb-#{@type}"

    @attributeBindings.pushObjects attr for attr of this when attr.match(/^data-/)?
    window.f = this

  didInsertElement: ->
    FB.XFBML.parse @$().parent()[0].context if FB?
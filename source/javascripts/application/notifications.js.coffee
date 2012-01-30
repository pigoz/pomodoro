@Pomodoro.Notification = Em.Object.extend
  canShow: ->
    !@showed and (window.webkitNotifications.checkPermission()== 0)

  nativeNotification: ->
    window.webkitNotifications.createNotification(
      @icon, @title, @text)

  show: ->
    if @canShow()
      @nativeNotification().show()
      @showed = true

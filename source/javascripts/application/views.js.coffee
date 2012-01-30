@Pomodoro.ToggleButton = Em.View.extend
  tagName: "a"
  click: ->
    window.Pomodoro.currentTimer.toggle()

@Pomodoro.NotificationsButton = Em.View.extend
  tagName: "a"
  click: ->
    window.webkitNotifications.requestPermission()

@Pomodoro.timerController = Em.Object.create
  timer: @Pomodoro.Pomodoro.create()

@Pomodoro.ToggleButton = Em.View.extend
  tagName: "a"
  timerBinding: "Pomodoro.timerController.timer"
  click: =>
    @Pomodoro.timerController.timer.toggle()

@Pomodoro.NotificationsButton = Em.View.extend
  tagName: "a"
  click: ->
    window.webkitNotifications.requestPermission()

@Pomodoro.AppView = Em.View.extend
  templateName: "appView"
  timerBinding: "Pomodoro.timerController.timer"


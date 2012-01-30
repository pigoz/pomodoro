@Pomodoro = Ember.Application.create()

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

@Pomodoro.Timer = Em.Object.extend
  time: ( ->
    sl = @get 'secondsLeft'
    sign = if sl > 0 then "" else "-"
    sl = Math.abs(sl)
    minutes = "00#{Math.floor(sl / 60)}".slice(-2)
    seconds = "00#{sl % 60}".slice(-2)
    "#{sign}#{minutes}:#{seconds}").property('secondsLeft')

  isRunning: ( ->
    @get("iid")? ).property("iid")

  status: (->
    if @get "isRunning" then "running" else "stopped").property("isRunning")

  # actions
  down: (amount)->
    amount ||= 1
    newsl = @get('secondsLeft') - amount
    if newsl < 1 then 0 else newsl
    @set 'secondsLeft', newsl
    if newsl < 1
      @n ||= Pomodoro.Notification.create
        icon: "/images/pomodoro-icon.png"
        title: @doneNotificationTitle
        text:  @doneNotificationText
      @n.show()

  toggle: ->
    if @get "isRunning" then @stop() else @start()

  stop: ->
    clearTimeout @get "iid"
    @set "iid", undefined

  start: ->
    @set "iid", (setInterval (
      -> @Pomodoro.currentTimer.down() ), 1000)

@Pomodoro.Pomodoro = @Pomodoro.Timer.extend
  secondsLeft: 25*60
  doneNotificationTitle: "Pomodoro ended!"
  doneNotificationText: "You worked hard, time to slack off :)"

@Pomodoro.SmallPause = @Pomodoro.Timer.extend
  secondsLeft: 5*60
  doneNotificationTitle: "Pause ended!"
  doneNotificationText: "I know you want more time, but it's time to work."

@Pomodoro.BigPause = @Pomodoro.Timer.extend
  secondsLeft: 5*60
  doneNotificationTitle: "Pause ended!"
  doneNotificationText: "It's time to go back to work."

@Pomodoro.currentTimer = @Pomodoro.Pomodoro.create()

@Pomodoro.ToggleButton = Em.View.extend
  tagName: "a"
  click: ->
    window.Pomodoro.currentTimer.toggle()

@Pomodoro.NotificationsButton = Em.View.extend
  tagName: "a"
  click: ->
    window.webkitNotifications.requestPermission()


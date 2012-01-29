@Pomodoro = Ember.Application.create()

@Pomodoro.Pomodoro = Em.Object.extend
  secondsLeft: 25*60

  time: ( ->
    sl = @get 'secondsLeft'
    minutes = "00#{Math.floor(sl / 60)}".slice(-2)
    seconds = "00#{sl % 60}".slice(-2)
    "#{minutes}:#{seconds}").property('secondsLeft')

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
    @stop() if @get('secondsLeft') < 1

  toggle: ->
    if @get "isRunning" then @stop() else @start()

  stop: ->
    clearTimeout @get "iid"
    @set "iid", undefined

  start: ->
    @set "iid", (setInterval (
      -> @Pomodoro.currentPomodoro.down() ), 1000)

@Pomodoro.currentPomodoro = @Pomodoro.Pomodoro.create()

@Pomodoro.ToggleButton = Em.View.extend
  tagName: "a"
  click: ->
    window.Pomodoro.currentPomodoro.toggle()

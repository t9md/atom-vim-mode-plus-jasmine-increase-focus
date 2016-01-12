{CompositeDisposable} = require 'atom'

Config =
  focusTexts:
    description: 'comma separated focus text which is prefixed to `it` and `describe`'
    type: 'array'
    items:
      type: 'string'
    default: ['f', 'x']

module.exports =
  config: Config

  activate: ->
    @subscriptions = new CompositeDisposable

  deactivate: ->
    @subscriptions?.dispose()
    @subscriptions = {}
    cachedTags = null

  subscribe: (args...) ->
    @subscriptions.add args...

  consumeVim: ->
    {JasmineIncreaseFocus, JasmineDecreaseFocus} = require "./jasmine-increase-focus"
    @subscribe(
      JasmineIncreaseFocus.registerCommand(),
      JasmineDecreaseFocus.registerCommand()
    )

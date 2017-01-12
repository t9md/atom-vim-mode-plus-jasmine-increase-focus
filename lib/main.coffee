{CompositeDisposable} = require 'atom'

Config =
  autoSave:
    description: 'save buffer when increased/decreased'
    type: 'boolean'
    default: false
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

  consumeVim: ->
    {JasmineIncreaseFocus, JasmineDecreaseFocus} = require "./jasmine-increase-focus"
    @subscriptions.add(
      JasmineIncreaseFocus.registerCommand()
      JasmineDecreaseFocus.registerCommand()
    )

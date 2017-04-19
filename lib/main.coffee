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

  consumeVim: ({registerCommandFromSpec}) ->
    registries = null
    getClass = (name) ->
      registries ?= require "./jasmine-increase-focus"
      registries[name]

    commandPrefix = 'vim-mode-plus-user'
    @subscriptions.add(
      registerCommandFromSpec('JasmineIncreaseFocus', {commandPrefix, getClass})
      registerCommandFromSpec('JasmineDecreaseFocus', {commandPrefix, getClass})
    )

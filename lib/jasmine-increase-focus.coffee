{Range} = require 'atom'

requireFrom = (pack, path) ->
  packPath = atom.packages.resolvePackagePath(pack)
  require "#{packPath}/lib/#{path}"

Operator = requireFrom('vim-mode-plus', 'base').getClass('Operator')
{getCodeFoldRowRangesContainesForRow} = requireFrom('vim-mode-plus', 'utils')

class JasmineIncreaseFocus extends Operator
  requireTarget: false
  direction: +1

  initialize: ->
    focusTexts = atom.config.get('vim-mode-plus-jasmine-increase-focus.focusTexts')
    focusTexts.unshift('')
    @focusTexts = focusTexts
    super

  getFocusText: (index) ->
    lastIndex = @focusTexts.length - 1
    index = index % @focusTexts.length
    level = switch
      when index > lastIndex then 0
      when index < 0 then lastIndex
      else index
    @focusTexts[level]

  getNewText: (focusText='', sectionName) ->
    index = @focusTexts.indexOf(focusText)
    index = 0 if (index is -1)
    @getFocusText(index + @getCount() * @direction) + sectionName

  mutateSpecSection: (cursor) ->
    sectionPattern = /\b(f+|x)*(describe|it)\b/
    newRange = null

    foldStartRows =
      getCodeFoldRowRangesContainesForRow(@editor, cursor.getBufferRow())
        .reverse()
        .map((rowRange) -> rowRange[0])

    for row in foldStartRows
      scanRange = @editor.bufferRangeForBufferRow(row)
      @editor.scanInBufferRange sectionPattern, scanRange, ({range, match, replace}) =>
        # Ignore match in middle of word like `it` in `editor`.
        # Range.fromPointWithDelta(range.start, 0, )
        return if /\S/.test(@editor.getTextInBufferRange([[range.start.row, 0], range.start]))
        newRange = replace(@getNewText(match[1..2]...))
        @flashIfNecessary(newRange)

      break if newRange?

  execute: ->
    @mutateSpecSection(@editor.getLastCursor())
    @activateMode('normal')
    if atom.config.get('vim-mode-plus-jasmine-increase-focus.autoSave')
      @editor.save()

class JasmineDecreaseFocus extends JasmineIncreaseFocus
  direction: -1

module.exports = {JasmineIncreaseFocus, JasmineDecreaseFocus}

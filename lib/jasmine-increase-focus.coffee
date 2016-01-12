requireFrom = (pack, path) ->
  packPath = atom.packages.resolvePackagePath(pack)
  require "#{packPath}/lib/#{path}"

Operator = requireFrom('vim-mode-plus', 'base').getClass('Operator')
{getCodeFoldRowRangesContainesForRow} = requireFrom('vim-mode-plus', 'utils')

CommandPrefix = 'vim-mode-plus-user'

class JasmineIncreaseFocus extends Operator
  @commandPrefix: CommandPrefix
  requireTarget: false
  direction: +1

  initialize: ->
    focusTexts = atom.config.get('vim-mode-plus-jasmine-increase-focus.focusTexts')
    focusTexts.unshift('')
    @focusTexts = focusTexts

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

  eachFoldStartRow: (cursor, fn) ->
    row = cursor.getBufferRow()
    foldRowRanges = getCodeFoldRowRangesContainesForRow(@editor, row)
    foldStartRows = foldRowRanges.reverse().map((rowRange) -> rowRange[0])
    for row in foldStartRows
      if fn(row)
        break

  mutateSpecSection: (cursor) ->
    sectionPattern = /(f+|x)*(describe|it)/
    @eachFoldStartRow cursor, (row) =>
      scanRange = @editor.bufferRangeForBufferRow(row)
      replaced = false
      @editor.scanInBufferRange sectionPattern, scanRange, ({matchText, range, match, replace, stop}) =>
        {row, column} = range.start

        # Ignore match in middle of word like `it` in `editor`.
        preceedingText = @editor.getTextInBufferRange([[row, 0], [row, column]])
        return if /\S/.test(preceedingText)

        stop()
        @flash(range) if @needFlash()
        replace(@getNewText(match[1..2]...))
        replaced = true
      replaced

  execute: ->
    cursor = @editor.getLastCursor()
    originalPoint = cursor.getBufferPosition()
    @mutateSpecSection(cursor)
    cursor.setBufferPosition(originalPoint)
    @activateMode('normal')

class JasmineDecreaseFocus extends JasmineIncreaseFocus
  requireTarget: false
  direction: -1

module.exports = {JasmineIncreaseFocus, JasmineDecreaseFocus}

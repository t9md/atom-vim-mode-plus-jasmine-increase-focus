module.exports = function loadVmpCommands(Base) {
  const Operator = Base.getClass("Operator")

  class JasmineIncreaseFocus extends Operator {
    constructor(...args) {
      super(...args)
      this.requireTarget = false
      this.direction = +1
      this.focusTexts = ["", ...atom.config.get("vim-mode-plus-jasmine-increase-focus.focusTexts")]
    }

    getNewText(focusText = "", sectionName) {
      const index = this.utils.getIndex(
        this.focusTexts.indexOf(focusText) + this.getCount() * this.direction,
        this.focusTexts
      )
      return this.focusTexts[index] + sectionName
    }

    mutateSpecSection(cursor) {
      const regex = /\b(f+|x)?(describe|it)\b/
      const foldStartRows = this.utils
        .getCodeFoldRowRangesContainesForRow(this.editor, cursor.getBufferRow())
        .reverse()
        .map(rowRange => rowRange[0])

      let replaced = false
      for (const row of foldStartRows) {
        const scanRange = this.editor.bufferRangeForBufferRow(row)
        this.editor.scanInBufferRange(regex, scanRange, ({range, match, replace}) => {
          // Ignore match in middle of word like `it` in `editor`.
          // Range.fromPointWithDelta(range.start, 0, )
          if (/\S/.test(this.editor.getTextInBufferRange([[range.start.row, 0], range.start]))) {
            return
          }
          const focusText = match[1]
          const sectionName = match[2]
          this.flashIfNecessary(replace(this.getNewText(focusText, sectionName)))
          replaced = true
        })
        if (replaced) break
      }
      if (replaced && !this.mutated) this.mutated = true
    }

    execute() {
      this.mutated = false
      this.mutateSpecSection(this.editor.getLastCursor())
      this.activateMode("normal")
      if (this.mutated && atom.config.get("vim-mode-plus-jasmine-increase-focus.autoSave")) {
        this.editor.save()
      }
    }
  }

  class JasmineDecreaseFocus extends JasmineIncreaseFocus {
    constructor(...args) {
      super(...args)
      this.direction = -1
    }
  }

  return {JasmineIncreaseFocus, JasmineDecreaseFocus}
}

const {CompositeDisposable} = require("atom")

const Config = {
  autoSave: {
    description: "save buffer when increased/decreased",
    type: "boolean",
    default: false,
  },
  focusTexts: {
    description: "comma separated focus text which is prefixed to `it` and `describe`",
    type: "array",
    items: {
      type: "string",
    },
    default: ["f", "x"],
  },
}

module.exports = {
  config: Config,

  activate() {
    this.subscriptions = new CompositeDisposable()
  },

  deactivate() {
    this.subscriptions.dispose()
  },

  consumeVim({Base, registerCommandFromSpec}) {
    let vimCommands

    const spec = {
      prefix: "vim-mode-plus-user",
      getClass(name) {
        if (!vimCommands) vimCommands = require("./jasmine-increase-focus")(Base)
        return vimCommands[name]
      },
    }

    const commandPrefix = "vim-mode-plus-user"
    this.subscriptions.add(
      registerCommandFromSpec("JasmineIncreaseFocus", spec),
      registerCommandFromSpec("JasmineDecreaseFocus", spec)
    )
  },
}

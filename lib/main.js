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

  consumeVim(service) {
    const commands = require("./jasmine-increase-focus")(service)
    for (const command of Object.values(commands)) {
      command.commandPrefix = "vim-mode-plus-user"
      this.subscriptions.add(command.registerCommand())
    }
  },
}

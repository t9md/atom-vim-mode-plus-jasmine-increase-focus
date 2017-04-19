requireFrom = (pack, path) ->
  packPath = atom.packages.resolvePackagePath(pack)
  require "#{packPath}/#{path}"

{getVimState} = requireFrom 'vim-mode-plus', 'spec/spec-helper'

activatePackageByActivationCommand = (name, fn) ->
  activationPromise = atom.packages.activatePackage(name)
  fn()
  activationPromise

describe "vim-mode-plus-jasmine-increase-focus", ->
  [set, ensure, keystroke, editor, editorElement, vimState] = []

  beforeEach ->
    atom.keymaps.add "test",
      'atom-text-editor.vim-mode-plus.normal-mode':
        '+': 'vim-mode-plus-user:jasmine-increase-focus'
        '-': 'vim-mode-plus-user:jasmine-decrease-focus'
      , 100

    waitsForPromise ->
      activatePackageByActivationCommand 'vim-mode-plus-jasmine-increase-focus', ->
        atom.workspace.open().then (editor) ->
          atom.commands.dispatch(editor.element, "vim-mode-plus-user:jasmine-increase-focus")

  describe "increase/decrease", ->
    pack = 'language-coffee-script'

    getEnsureRowText = (row, cursor) ->
      (_keystroke, rowText) ->
        keystroke _keystroke
        expect(editor.lineTextForBufferRow(row)).toBe rowText
        ensure cursor: cursor

    beforeEach ->
      waitsForPromise ->
        atom.packages.activatePackage(pack)

      getVimState 'sample.coffee', (state, vim) ->
        vimState = state
        {editor, editorElement} = state
        {set, ensure, keystroke} = vim

    afterEach ->
      atom.packages.deactivatePackage(pack)

    it "[Case: describe] Change focus level without moving cursor", ->
      set cursor: (point = [2, 4])
      ensureRowText = getEnsureRowText(0, point)

      ensureRowText '+', 'fdescribe "test", ->'
      ensureRowText '+', 'xdescribe "test", ->'
      ensureRowText '+', 'describe "test", ->'

      ensureRowText '-', 'xdescribe "test", ->'
      ensureRowText '-', 'fdescribe "test", ->'
      ensureRowText '-', 'describe "test", ->'

    it "[Case: it] Change focus level without moving cursor", ->
      set cursor: (point = [23, 13])
      ensureRowText = getEnsureRowText(20, point)

      ensureRowText '+', '  fit "test", ->'
      ensureRowText '+', '  xit "test", ->'
      ensureRowText '+', '  it "test", ->'

      ensureRowText '-', '  xit "test", ->'
      ensureRowText '-', '  fit "test", ->'
      ensureRowText '-', '  it "test", ->'

    describe "focusTexts settings", ->
      beforeEach ->
        focusTexts = ["f", "ff", "fff"]
        atom.config.set('vim-mode-plus-jasmine-increase-focus.focusTexts', focusTexts)

      it "Change focus text based on settings", ->
        set cursor: (point = [23, 13])
        ensureRowText = getEnsureRowText(20, point)

        ensureRowText '+', '  fit "test", ->'
        ensureRowText '+', '  ffit "test", ->'
        ensureRowText '+', '  fffit "test", ->'
        ensureRowText '+', '  it "test", ->'

        ensureRowText '-', '  fffit "test", ->'
        ensureRowText '-', '  ffit "test", ->'
        ensureRowText '-', '  fit "test", ->'
        ensureRowText '-', '  it "test", ->'

    describe "autoSave settings", ->
      [ensureRowText, saved] = []
      beforeEach ->
        cursor = [23, 13]
        set {cursor}
        saved = 0
        ensureRowText = getEnsureRowText(20, cursor)
        editor.onDidSave -> saved++

      it "disabled by default", ->
        ensureRowText '+', '  fit "test", ->'
        expect(editor.isModified()).toBe(true)
        ensureRowText '-', '  it "test", ->'
        expect(saved).toBe(0)
        expect(editor.isModified()).toBe(false)

      it "autoSave on increase/decrease", ->
        atom.config.set('vim-mode-plus-jasmine-increase-focus.autoSave', true)
        ensureRowText '+', '  fit "test", ->'
        expect(saved).toBe(1)
        expect(editor.isModified()).toBe(false)
        ensureRowText '-', '  it "test", ->'
        expect(saved).toBe(2)
        expect(editor.isModified()).toBe(false)

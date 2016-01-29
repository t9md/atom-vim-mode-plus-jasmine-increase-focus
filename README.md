[![Build Status](https://travis-ci.org/t9md/atom-vim-mode-plus-jasmine-increase-focus.svg?branch=master)](https://travis-ci.org/t9md/atom-vim-mode-plus-jasmine-increase-focus)

# vim-mode-plus-jasmine-increase-focus

This is operator plugin for [vim-mode-plus](https://atom.io/packages/vim-mode-plus).  

Increase, decrease focus of current jasmine spec section you are in.  
No need to move cursor to header line.  
Of course, this is operator, you can repat it with `.` command.  

![](https://raw.githubusercontent.com/t9md/t9md/1d709b4b42780bf98c1387802b1b8733ea9cd4a5/img/atom-vmp-jasmine-increase-focus.gif)

- ex-1: `it`, `fit`, `xit`
- ex-2: `it`, `fit`, `ffit`, `fffit` for [jasmine-focused](https://www.npmjs.com/package/jasmine-focused) user.

## Features

- Respect `flashOnOperate` configuration of vim-mode-plus.

## keymap example

No keymap by default. Set following keymap to in your `keymap.cson`.  

```coffeescipt
'atom-text-editor.vim-mode-plus.normal-mode':
  '-': 'vim-mode-plus-user:jasmine-increase-focus'
  'ctrl--': 'vim-mode-plus-user:jasmine-decrease-focus'
```

or For specific grammar

- CoffeeScript
```coffeescipt
'atom-text-editor.vim-mode-plus.normal-mode[data-grammar="source coffee"]':
  '-': 'vim-mode-plus-user:jasmine-increase-focus'
  'ctrl--': 'vim-mode-plus-user:jasmine-decrease-focus'
```

- JavaScript
```coffeescipt
atom-text-editor.vim-mode-plus.normal-mode[data-grammar="source js"]':
  '-': 'vim-mode-plus-user:jasmine-increase-focus'
  'ctrl--': 'vim-mode-plus-user:jasmine-decrease-focus'
```


# Configuration

## Focus Texts

You can customize list of prefixed focus level text.  
"`f, x`" is by default.  
This mean you can toggle
 - `fit`, `xit`, `it`(no prefix) when increase
 - `xit`, `fit`, `it`(no prefix) when decrease

e.g.  
If you are using [jasmine-focused](https://www.npmjs.com/package/jasmine-focused) and want to toggle `fit` to `fffit` and don't use `x` focus, set this value to "`f, ff, fff`"

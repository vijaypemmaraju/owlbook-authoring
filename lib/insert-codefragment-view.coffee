path = require 'path'
_ = require 'underscore-plus'
{$, TextEditorView, View} = require 'atom-space-pen-views'
{BufferedProcess} = require 'atom'
fs = require 'fs-plus'

module.exports =
class InsertCodeFragmentView extends View
  previouslyFocusedElement: null
  mode: null

  @content: ->
    @div class: 'package-generator', =>
      @div class: 'codeFragmentLabel', outlet: 'codeFragmentLabel'
      @subview 'codeFragmentEditor', new TextEditorView(mini: true)


  initialize: ->
    atom.commands.add @element,
      'core:confirm': => @confirm()
    atom.commands.add @element,
      'cancel': => @close()
    @attach()


  destroy: ->
    @panel?.destroy()
    @commandSubscription.dispose()

  attach: () ->
    @panel ?= atom.workspace.addModalPanel(item: this, visible: false)
    @previouslyFocusedElement = $(document.activeElement)
    @panel.show()
    @codeFragmentLabel.text("Has Line Numbers? (yes/no)")
    @codeFragmentEditor.focus()


  close: ->
    @panel?.hide()
    @previouslyFocusedElement?.focus()

  confirm: ->
    hasLineNumbers = @codeFragmentEditor.getText()
    if (atom.workspace.activePaneItem)
      atom.workspace.activePaneItem.insertText('<!-- owltag.codefragment linenumber="'+hasLineNumbers+'" -->\n<!-- owltag.endcodefragment -->')
      #atom.workspace.activePaneItem.insertText('')
    @close()

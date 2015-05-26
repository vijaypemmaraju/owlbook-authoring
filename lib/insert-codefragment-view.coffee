path = require 'path'
_ = require 'underscore-plus'
{$, TextEditorView, View} = require 'atom-space-pen-views'
{BufferedProcess} = require 'atom'
fs = require 'fs-plus'

module.exports =
class InsertCodeFragmentView extends View
  # reference to whatever we were looking at before so we can refocus it when we close the view
  previouslyFocusedElement: null

  # the contents of the view itself, represented as HTML
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

  # adds the view as a modal panel to the workspace
  attach: () ->
    @panel ?= atom.workspace.addModalPanel(item: this, visible: false)
    @previouslyFocusedElement = $(document.activeElement)
    @panel.show()
    @codeFragmentLabel.text("Has Line Numbers? (yes/no)")
    @codeFragmentEditor.focus()


  close: ->
    @panel?.hide()
    @previouslyFocusedElement?.focus()


  # gets the input from the editor, performs the appropriate actions on it, and closes the view.
  confirm: ->
    hasLineNumbers = @codeFragmentEditor.getText()
    if (atom.workspace.activePaneItem)
      atom.workspace.activePaneItem.insertText('<!-- owltag.codefragment linenumber="'+hasLineNumbers+'" -->\n<!-- owltag.endcodefragment -->')
    @close()

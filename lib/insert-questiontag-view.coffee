path = require 'path'
_ = require 'underscore-plus'
{$, TextEditorView, View} = require 'atom-space-pen-views'
{BufferedProcess} = require 'atom'
fs = require 'fs-plus'

module.exports =
class InsertQuestionTagView extends View
  # reference to whatever we were looking at before so we can refocus it when we close the view
  previouslyFocusedElement: null

  # the contents of the view itself, represented as HTML
  @content: ->
    @div class: 'package-generator', =>
      @div class: 'questionTagLabel', outlet: 'questionTagLabel'
      @subview 'questionTagEditor', new TextEditorView(mini: true)
      @div class: 'displayLabel', outlet: 'displayLabel'
      @subview 'displayEditor', new TextEditorView(mini: true)
      @div class: 'messageLabel', outlet: 'messageLabel'
      @subview 'messageEditor', new TextEditorView(mini: true)
      @div class: 'titleLabel', outlet: 'titleLabel'
      @subview 'titleEditor', new TextEditorView(mini: true)

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
    @questionTagLabel.text("Enter tag number")
    @displayLabel.text("Enter display type")
    @messageLabel.text("Enter message")
    @titleLabel.text("Enter title")
    @questionTagEditor.focus()


  close: ->
    @panel?.hide()
    @previouslyFocusedElement?.focus()

  # gets the inputs from the editor, performs the appropriate actions on it, and closes the view.
  confirm: ->
    questionNumber = @questionTagEditor.getText()
    display = @displayEditor.getText()
    message = @messageEditor.getText()
    title = @titleEditor.getText()
    if (atom.workspace.activePaneItem)
      atom.workspace.activePaneItem.insertText('<!-- owltag.question number="'+questionNumber+'" display="'+display+'" message="'+message+'" title="'+title+'" -->')
    @close()

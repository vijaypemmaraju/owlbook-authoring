InsertQuestionTagView = require './insert-questiontag-view'
InsertCodeFragmentView = require './insert-codefragment-view'
{CompositeDisposable, Directory, File} = require 'atom'

module.exports = OwlbookAuthoring =
  subscriptions: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable
    # Register commands for our views
    @subscriptions.add atom.commands.add 'atom-workspace', 'owlbook-authoring:insertQuestionTag': => @insertQuestionTag()
    @subscriptions.add atom.commands.add 'atom-workspace', 'owlbook-authoring:insertCodeFragment': => @insertCodeFragment()
    @subscriptions.add atom.commands.add 'atom-workspace', "owlbook-authoring:generateTextbook", => @generateTextbook()
    @subscriptions.add atom.commands.add 'atom-workspace', "owlbook-authoring:newOWLPage", => @newOWLPage()

  deactivate: ->
    @subscriptions.dispose()

  insertQuestionTag: ->
    new InsertQuestionTagView()

  insertCodeFragment: ->
    new InsertCodeFragmentView()

  generateTextbook: ->
    try
      atom.pickFolder(@onFolderPick)
    catch error

  # generates the directory structure for an OWL Textbook. 
  onFolderPick: (paths) ->

      if paths != null
        path = paths[0]
        (new Directory(path + '/includes')).create()
        (new Directory(path + '/includes/css')).create()
        (new Directory(path + '/includes/media')).create()
        (new Directory(path + '/includes/scripts')).create()

        (new Directory(path + '/html')).create()

        (new File(path + '/html/glossary.html')).create()



        (new Directory(path + '/xml')).create()
        (new Directory(path + '/xml/test')).create()

        (new File(path + '/xml/test/system_settings.xml')).create()

        (new Directory(path + '/xml/deploy')).create()

        (new File(path + '/xml/deploy/system_settings.xml')).create()
        (new File(path + '/xml/prefs.xml')).create()
        (new File(path + '/xml/structure.xml')).create()
        (new File(path + '/xml/glossary.xml')).create()
        atom.open(pathsToOpen: [path])

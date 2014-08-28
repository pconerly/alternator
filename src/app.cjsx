
React = require 'react'

Converter = require './convert.coffee'
c = new Converter()

# TODO
# detecting coffee or js. 
# errors.
# output

Alternator = React.createClass
  getInitialState: () ->
    badcodeBlock = """
      define(['jquery', 'underscore', 'backbone', 'common/logger', 'common/swfobject', 'ads/slot', './background_picker', 'common/google_analytics',
              'panels/save/save_panel', 'panels/share/share_panel', 'common/flags', 'common/loading_view',
              'common/flash_callback_manager', 'accounts/user_model', 'accounts/views', 'common/warning_popups', 'viewer/main_view', 
              'common/local_storage'],
      function($, _, Backbone, Logger, swfobject, AdSlot, BackgroundPicker, GA,
               SavePanel, SharePanel, Flags, LoadingView, FlashCallbackManager, User,
               AccountViews, WarningPopups, ViewerMainView, LocalStorage) {

      'pass'
      """

    return {
      badcode: badcodeBlock
      goodcode: ''
      output: ''
      detecting: 'js'
      leading: false
    }

  onKey: (e) ->
    @setState {
      badcode: e.target.value
    }

  leadTrailChange: (e) ->
    @setState {
      leading: e.target.checked
    }

  render: () -> 
    <div className="main">
      <h2 className="headline">Convert the requirejs bad syntax into good syntax.</h2>
      <div className="alerts"/>
      <div className="textareas">
        <div className="bad-syntax textarea-container">
          <textarea className="bad-syntax-textarea textarea" 
            onChange={this.onKey}
            value={this.state.badcode}></textarea>
        </div>
        <div className="alt-syntax textarea-container">
          <textarea className="alt-syntax-textarea textarea" value={c.convertToAlternateSyntax(this.state.badcode, this.state.leading)}></textarea>
        </div>
      </div>
      <div className="settings">
        <h3>Settings</h3>
        <div>
          <label>Leading commas?</label>
          <input type="checkbox" checked={this.state.leading} onChange={this.leadTrailChange} />
        </div>
      </div>
    </div>


React.renderComponent(
  <Alternator />,
  document.getElementById('content')
  )

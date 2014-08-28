
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
    badcodeBlock = """
      define(['jquery', 'underscore', 'backbone', 'common/logger'
          'plugins/jquery.fileopenbutton', 'plugins/jquery.layoutengine'
          './viewer_model', './facebook_view', './flickr_view', './dropbox_view'
          './mycomputer_view', './onedrive_view', 'external_services/models'
          'icanhaz', 'external_services/onedrive'],
      ($, _, Backbone, Logger, fileopenbutton, layoutengine, ViewerModel,
          FacebookView, FlickrView, DropboxView, MyComputerView, OneDriveView, 
          ServiceModels, ich, OneDrive) ->

          class ViewerMainView extends Backbone.View

              pass: 'pass'
      """

    return {
      badcode: badcodeBlock
      goodcode: ''
      output: ''
      detecting: 'js'
      leading: false
      coffeeparens: true
    }

  onKey: (e) ->
    @setState {
      badcode: e.target.value
    }

  settingsChange: (e) ->
    stateObj = {}
    stateObj[e.target.getAttribute('name')] = e.target.checked
    @setState stateObj

  render: () -> 
    result = c.convertToAlternateSyntax(this.state.badcode, {
      leadingcommas: this.state.leading
      coffeeparens: this.state.coffeeparens
      })
    goodcode = result.converted
    detected = result.detected
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
          <textarea className="alt-syntax-textarea textarea" value={goodcode}></textarea>
        </div>
      </div>
      <div className="settings">
        <h3>Settings</h3>
        <div>
          <h4>Language Detected: {detected}</h4>
        </div>
        <div>
          <label>Javascript leading commas?</label>
          <input type="checkbox" name="leading" checked={this.state.leading} onChange={this.settingsChange} />
        </div>
        <div>
          <label>Coffee parens?</label>
          <input type="checkbox" name="coffeeparens" checked={this.state.coffeeparens} onChange={this.settingsChange} />
        </div>
      </div>
    </div>


React.renderComponent(
  <Alternator />,
  document.getElementById('content')
  )

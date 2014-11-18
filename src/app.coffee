
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
      define([
          'config',
          'models/base',
          'models/decorators/singleton'
      ], function (
          config,
          BaseModel,
          singleton
      ) {
          'use strict';

          var Model = BaseModel.extend({

              relations: {
                  context: 'models/category'
              },

              defaults: {

                  // The current Category context of the application. This has a
                  // variety of effects throughout Kindling.
                  context: null
              }
          });

          return singleton(Model, {
              context: config.data('context')
          });
      });

      """

    return {
      badcode: badcodeBlock
      goodcode: ''
      output: ''
      detecting: 'js'
      multivars: true
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
      multivars: this.state.multivars
      leadingcommas: this.state.leading
      coffeeparens: this.state.coffeeparens
      })
    goodcode = result.converted
    detected = result.detected
    <div className="main">
      <h2 className="headline">Convert RequireJS default syntax into CommonJS compatable</h2>
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
          <label>Multiple vars?</label>
          <input type="checkbox" name="multivars" checked={this.state.multivars} onChange={this.settingsChange} />
        </div>
        <div>
          <label>Javascript leading commas?</label>
          <input type="checkbox" name="leading" checked={!this.state.multivars && this.state.leading} onChange={this.settingsChange} />
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

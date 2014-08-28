_ = require "underscore"
_.str = require "underscore.string"
_.mixin _.str.exports()
_.str.include "Underscore.string", "string"

# TODO:
# coffeescript support
# something with indentation for coffeescript

class Converter
    source = ''
    converted = ''
    requires = []
    parameters = []

    scrollToMany: (substrings, opts = {}) ->
        for sub in substrings
            @scrollTo sub, opts

    scrollTo: (substring, opts = {}) ->
        opts.addToConverted ?= true
        itemIndex = @source.indexOf(substring)
        if itemIndex is -1
            throw new Error("Could not find #{substring}.")

        splitAt = itemIndex + substring.length
        if opts.addToConverted
            @converted += @source.slice 0, splitAt
        @source = @source.slice splitAt

    findArrayBeforeSubstring: (substring, opts = {}) ->
        opts.addToConverted ?= false
        itemIndex = @source.indexOf substring
        if itemIndex is -1
            throw new Error "Could not find #{substring}."
        arrayStr = @source.slice 0, itemIndex

        lines = arrayStr.split "\n"
        output = []
        for line in lines
            output = output.concat line.split(',')

        output = (_.trim(req) for req in output)

        output = _.without output, ''


        @scrollTo substring, {
            addToConverted: opts.addToConverted
        }

        return output


    convertToAlternateSyntax: (sourcecode, opts) -> #, callback) ->

        try
            @source = sourcecode
            @converted = ''
            @requires = []
            @parameters = []
            @detected = 'js'

            # find "define", "("
            @scrollToMany ['define', '(']

            # get require arguments
            @scrollTo '[',
                addToConverted: false
            @requires = @findArrayBeforeSubstring ']',
                addToConverted: false

            # get the module function parameters
            @scrollTo ',',
                addToConverted: false

            try
                @scrollTo 'function',
                    addToConverted: false
                @converted += 'function'
            catch
                @detected = 'coffee'


            if @detected is 'js'
                @scrollTo '('
            else
                @scrollTo '(',
                    addToConverted: false
                @converted += '('

            @converted += 'require)'
            @parameters = @findArrayBeforeSubstring ')',
                addToConverted: false

            if @detected is 'js'
                @scrollToMany ['{', '\n']
            else # if @detected is 'coffee'
                @scrollToMany ['->', '\n']

            # append module variables and require with new syntax
            for i in [0...@requires.length]
                if i is 0
                    prefix = 'var'
                else if opts.leadingcommas
                    prefix = '  ,'
                else 
                    prefix = '   '

                if i is @requires.length - 1
                    suffix = ';'
                else if opts.leadingcommas
                    suffix = ''
                else 
                    suffix = ','

                req = @requires[i]
                if i < @parameters.length
                    varname = @parameters[i]
                else # allow for unnamed requirements, giving them a new name.
                    varname = @requires[i].split('/')
                    varname = varname[varname.length - 1]

                if @detected is 'js'
                    @converted += "#{prefix} #{varname} = require(#{req})#{suffix}\n"
                else
                    if opts.coffeeparens
                        @converted += "    #{varname} = require(#{req})\n"
                    else 
                        @converted += "    #{varname} = require #{req}\n"

            # append the rest of the source
            @converted += "\n"
            @converted += @source

            return {
                converted: @converted
                detected: @detected
            }

        catch error
            return {
                converted: error
                detected: 'error'
            }

module.exports = Converter

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


    convertToAlternateSyntax: (sourcecode) -> #, callback) ->

        try
            @source = sourcecode
            @converted = ''
            @requires = []
            @parameters = []

            # find "define", "("
            @scrollToMany ['define', '(']

            # get require arguments
            @scrollTo '[',
                addToConverted: false
            @requires = @findArrayBeforeSubstring ']',
                addToConverted: false

            # get the module function parameters
            @scrollToMany [',',  'function'],
                addToConverted: false
            @converted += 'function'

            @scrollTo '('
            @converted += 'require)'
            @parameters = @findArrayBeforeSubstring ')',
                addToConverted: false

            @scrollToMany ['{', '\n']

            # append module variables and require with new syntax
            for i in [0...@requires.length]
                def = '  ,'
                if i is 0
                    def = 'var'
                suffix = ''
                if i is @requires.length - 1
                    suffix = ';'

                req = @requires[i]
                if i < @parameters.length
                    varname = @parameters[i]
                else # allow for unnamed requirements, giving them a new name.
                    varname = @requires[i].split('/')
                    varname = varname[varname.length - 1]

                @converted += "#{def} #{varname} = require(#{req})#{suffix}\n"

            # append the rest of the source
            @converted += "\n"
            @converted += @source

            return @converted

        catch error
            return error

module.exports = Converter

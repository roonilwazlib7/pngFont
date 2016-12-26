exports = this

CHARS = "abcdefghijklmnopqrstuvwxyz"

CHARS += CHARS.toUpperCase()

CHARS += ".,<>/?"

class PngFont
    renderX: 0
    constructor: ->
        @canvasNode = document.createElement("CANVAS")
        @canvasNode.width = 1280
        @canvasNode.height = 720
        @canvasNode.style.border = "1px solid"

        $("body").append(@canvasNode)

        @canvas = @canvasNode.getContext("2d")

    RenderFont: ->

        chars = CHARS.split()

        for char,index in chars
            @RenderCharacter(char)

    RenderCharacter: (char) ->
        @canvas.fillText(char, @renderX, 0)

        @renderX += 5

$(document).ready ->
    pngFont = exports.pngFont = new PngFont()
    pngFont.RenderFont()

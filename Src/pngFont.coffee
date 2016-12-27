app = require('electron').remote
fs = require('fs')
canvasBuffer = require('electron-canvas-to-buffer')
dialog = app.dialog

exports = this

CHARS = "abcdefghijklmnopqrstuvwxyz"
CHARS += CHARS.toUpperCase()
CHARS += ".,<>/?"

class PngFont
    renderX: 0
    fontSize: 18
    font: "monospace"
    fontColor: "black"
    renderedFont = null

    constructor: ->
        @canvasNode = document.createElement("CANVAS")
        @canvasNode.width = $("#main").width()
        @canvasNode.height = 300
        @canvasNode.style.border = "1px solid"

        $("#canvas-place").append(@canvasNode)

        @canvas = @canvasNode.getContext("2d")

        @BindUIEvents()

    RenderFont: ->
        if @renderedFont?
            $(@renderedFont).remove()
            @renderedFont = null

        @canvas.clearRect(0, 0, @renderX, 400)
        @renderX = 0


        chars = CHARS.split("")

        for char,index in chars
            @RenderCharacter(char)

        @ClipFontImage()

    RenderCharacter: (char) ->
        @canvas.fillStyle = @fontColor
        @canvas.font = "#{@fontSize}px #{@font}"

        @canvas.fillText(char, @renderX, @fontSize)

        @renderX += @canvas.measureText(char).width

    ClipFontImage: ->
        clipHeight = @fontSize * 1.5

        imageData = @canvas.getImageData(0, 0, @renderX, clipHeight)

        newCanvas = document.createElement("CANVAS")
        newCanvas.width = @renderX
        newCanvas.height = clipHeight
        newCanvas.style.border = "1px solid green"

        $("#rendered-font").append(newCanvas)

        canvas = newCanvas.getContext("2d")

        canvas.putImageData(imageData,0,0)

        @renderedFont = newCanvas

    BindUIEvents: ->
        fontName = $("#font-name")
        saveFont = $("#save-font")

        fontName.change =>
            @font = fontName.val()
            @RenderFont()

        saveFont.click =>
            @SaveFile()

    SaveFile: ->
        dialog.showSaveDialog (fileName) =>
            if not fileName?
                alert("no file selected")
            else
                console.log(@renderedFont)
                buffer = canvasBuffer(@renderedFont, "image/png")
                fs.writeFile fileName, buffer, (err) ->
                    if err?
                        alert("An error occured! #{err.message}")
                    else
                        alert("File Saved")

$(document).ready ->
    pngFont = exports.pngFont = new PngFont()
    pngFont.RenderFont()

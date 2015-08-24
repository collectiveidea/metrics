class MetadataPreview
  constructor: ->
    @pattern = $("#metric-form-pattern")
    @command = $("#metric-form-command")

    @timeout = null

    @initializePopover()
    @listen()

  initializePopover: ->
    @command.popover
      content: => @content
      html: true
      placement: "auto top"
      trigger: "manual"

  listen: ->
    @command.on "focus", @fetchMetadata
    @command.on "input", @scheduleMetadataFetch
    @command.on "blur", @hide

  scheduleMetadataFetch: =>
    clearTimeout @timeout
    @timeout = setTimeout(@fetchMetadata, 300)

  fetchMetadata: =>
    $.getJSON(
      "/metrics/preview"
      { pattern: @pattern.val(), command: @command.val() }
      @receiveMetadata
    )

  receiveMetadata: (data) =>
    if $.isEmptyObject(data)
      @error()
      return

    $table = $("<table>")

    for key, value of data
      $row = $("<tr>")
      $row.append $("<th>").text(key)
      $row.append $("<td>").text(value)
      $table.append $row

    @show $table

  show: ($node) =>
    content = $node.wrap("<div>").parent().html()

    unless content == @content
      @content = content
      @command.popover("show")

  hide: =>
    clearTimeout @timeout
    @content = null
    @command.popover("hide")

  error: =>
    if @command.val()
      @show $("<span>").addClass("text-danger").text("No matches!")
    else
      @hide()

$ ->
  window.metadataPreview = new MetadataPreview

class MetadataPreview
  constructor: ->
    @pattern = $("[name='metric[pattern]']")
    @example = $("[name='metric[example]']")

    @timeout = null

    @initializePopover()
    @listen()

  initializePopover: ->
    @example.popover
      content: => @content
      html: true
      placement: "auto top"
      trigger: "manual"

  listen: ->
    @example.on "focus", @fetchMetadata
    @example.on "input", @scheduleMetadataFetch
    @example.on "blur", @hide

  scheduleMetadataFetch: =>
    clearTimeout @timeout
    @timeout = setTimeout(@fetchMetadata, 300)

  fetchMetadata: =>
    $.getJSON(
      "/metrics/preview"
      { pattern: @pattern.val(), example: @example.val() }
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
      @example.popover("show")

  hide: =>
    clearTimeout @timeout
    @content = null
    @example.popover("hide")

  error: =>
    if @example.val()
      @show $("<span>").addClass("text-danger").text("No matches!")
    else
      @hide()

$ ->
  window.metadataPreview = new MetadataPreview

class MetricGraph
  constructor: ->
    @container = $(".metric-detail-graph-container")

    @days = $("#metric-detail-graph-days")
    @metadataName = $("#metric-detail-graph-metadata-name")

    @days.on "change", @fetch
    @metadataName.on "change", @fetch

  fetch: (event) =>
    console.log("here")

    days = @days.val()
    metadataName = @metadataName.val()
    url = $(event.target).data("url")

    $.ajax
      data: { days: days, metadata_name: metadataName }
      method: "GET"
      success: @update
      url: url

  update: (graph) =>
    @container.html(graph)

$ ->
  window.metricGraph = new MetricGraph

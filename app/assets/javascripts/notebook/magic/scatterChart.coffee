define([
    'observable'
    'knockout'
    'd3'
    'dimple'
], (Observable, ko, d3, dimple) ->
  (dataO, container, options) ->
    w = options.width||600
    h = options.height||400

    count = d3.select(container).append("p")
    count .selectAll("span .nrow")
          .data([options.nrow])
          .enter()
          .append("span")
          .attr("class", "nrow")
            .text( (d) ->
              d + " items"
            )
    displayShown = (c) =>
      shown = count.selectAll("span.shown")
                    .data([c])
      shown.remove()
      shown.enter()
            .append("span")
            .attr("class", "shown")
            .attr("style", "color: red")
            .text( (d) ->
              if options.nrow > d
                "(showing " +  d + ")"
              else
                ""
            )
    displayShown(options.shown)

    svg = d3.select(container).append("svg:svg").attr("width", w+"px").attr("height", h+"px").attr("id", "scatter"+@genId)
    chart = new dimple.chart(svg, @dataInit)
    chart.setBounds(w*(50/600), h*(20/400), w *(540/600), h*(350/400))

    chart.addCategoryAxis("x", options.x)
    chart.addMeasureAxis("y", options.y)
    chart.addSeries(options.y, dimple.plot.bubble)
    chart.draw()

    dataO.subscribe( (newData) =>
      displayShown(newData.length)
      chart.data = newData
      chart.draw(1000)
    )
)
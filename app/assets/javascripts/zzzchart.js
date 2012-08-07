var width = 960,
    height = 500;

var color = {'1':'blue', '2':'red'};

var force = d3.layout.force()
    .charge(-30)
    .linkDistance(30)
    .linkStrength(0.1)
    .size([width, height]);

var svg = d3.select("#chart-home").append("svg")
    .attr("width", width)
    .attr("height", height);

d3.json("assets/output_new_s_500.json", function(json) {
  force
      .nodes(json.nodes)
      .links(json.links)
      .start()
  var link = svg.selectAll("line.link")
      .data(json.links)
    .enter().append("line")
      .attr("class", "link")
      .style("stroke-width",4);       

  var node = svg.selectAll("circle.node")
      .data(json.nodes)
    .enter().append("circle")
      .attr("class", "node")
      .attr("r", 4)
      .style("fill", function(d) { return color[d.party]; })
      .call(force.drag);

  node.append("title")
      .text(function(d) { return d.name; });

  force.on("tick", function() {
    link.attr("x1", function(d) { return d.source.x; })
        .attr("y1", function(d) { return d.source.y; })
        .attr("x2", function(d) { return d.target.x; })
        .attr("y2", function(d) { return d.target.y; });

    node.attr("cx", function(d) { return d.x; })
        .attr("cy", function(d) { return d.y; });
  });
});

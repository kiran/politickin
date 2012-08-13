var chart_el = $('#bills-chart'),
    cosponsored = chart_el.data('cosponsored'),
    introduced = chart_el.data('introduced'),
    debated = chart_el.data('debated'),
    enacted = chart_el.data('enacted');
var width = chart_el.parent().width(),
    height = width/4,
    padding = 10;
var aspect = width/height;
$(window).on("resize", function() {
    var targetWidth = chart_el.parent().width();
    chart_el.attr("width", targetWidth);
    chart_el.attr("height", targetWidth / aspect);
});
var bills_chart = d3.select('#bills-chart').
    append("svg:svg").
    attr("width", width).
    attr("height", height).
    attr('viewBox', "0 0 "+width+" "+height).
    attr('perserveAspectRatio',"xMinYMid");
var data = [{x:0, y:cosponsored},
            {x:1, y:introduced}, 
            {x:2, y:debated}, 
            {x:3, y:enacted},
            {x:4, y:0}];
var x = d3.scale.linear().
    domain([0,4.01]).
    range([padding, width - padding * 2]);
var y = d3.scale.linear().
    domain([0,cosponsored]).
    range([height - padding*2, padding]);
var area = d3.svg.area()
    .x(function(d) { return x(d.x); })
    .y0(y(0))
    .y1(function(d) { return y(d.y); })
    .interpolate('linear');
var i;
for (i=0; i<5; i++) {
  bills_chart.append("svg:line").
    attr("x1", x(i)).
    attr("y1", 0).
    attr("x2", x(i)).
    attr("y2", y(0)).
    attr("stroke", "darkgray");
}
bills_chart.append("svg:path").
    attr("d", area(data));
var axisNames = ['cosponsored '+cosponsored, 'introduced '+introduced, 'debated '+debated, 'enacted '+enacted];
bills_chart.selectAll("text.xAxisBottom").
  data([0.5,1.5,2.5,3.5]).
  enter().
    append("svg:text").
      text(function(d, i) { return axisNames[i]; }).
      attr("x", x).
      attr("y", height/5).
      attr("text-anchor", "middle").
      attr("class", "xAxisBottom");
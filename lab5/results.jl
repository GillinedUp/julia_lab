using Gadfly

r0 = [1.965366, 1.906333, 1.985672]
r1 = [1.928721, 1.987546, 1.054316]
r2 = [1.935111, 1.909749, 1.105962]
r3 = [2.025272, 2.033075, 1.045445]

m0 = [4.557505, 4.304107, 4.456504]
m1 = [4.400087, 4.367762, 2.362263]
m2 = [4.339575, 4.352841, 2.377639]
m3 = [4.500329, 4.334363, 2.362037]

n0 = [7.842748, 7.628895, 7.940109]
n1 = [7.890390, 7.895505, 4.274819]
n2 = [7.757135, 7.867424, 4.395717]
n3 = [8.009265, 7.783125, 4.246162]

xaxis = [0, 1, 2]
colorArr = Colors.distinguishable_colors(4, Gadfly.parse_colorant("blue"))
light_panel = Theme(
  panel_fill="white",
  default_color="black"
)
plot2000 = Gadfly.plot(
  layer(x = xaxis, y = r0, Geom.line, Theme(default_color = colorArr[1])),
  layer(x = xaxis, y = r1, Geom.line, Theme(default_color = colorArr[2])),
  layer(x = xaxis, y = r2, Geom.line, Theme(default_color = colorArr[3])),
  layer(x = xaxis, y = r3, Geom.line, Theme(default_color = colorArr[4])),
  Guide.xlabel("Number of additional processes"),
  Guide.ylabel("Time (sec)"),
  Guide.xticks(ticks = xaxis),
  Guide.manual_color_key("Legend", ["serial", "pfor", "pmap", "manual"], colorArr),
  light_panel
)
plot3000 = Gadfly.plot(
  layer(x = xaxis, y = m0, Geom.line, Theme(default_color = colorArr[1])),
  layer(x = xaxis, y = m1, Geom.line, Theme(default_color = colorArr[2])),
  layer(x = xaxis, y = m2, Geom.line, Theme(default_color = colorArr[3])),
  layer(x = xaxis, y = m3, Geom.line, Theme(default_color = colorArr[4])),
  Guide.xlabel("Number of additional processes"),
  Guide.ylabel("Time (sec)"),
  Guide.xticks(ticks = xaxis),
  Guide.manual_color_key("Legend", ["serial", "pfor", "pmap", "manual"], colorArr),
  light_panel
)
plot4000 = Gadfly.plot(
  layer(x = xaxis, y = n0, Geom.line, Theme(default_color = colorArr[1])),
  layer(x = xaxis, y = n1, Geom.line, Theme(default_color = colorArr[2])),
  layer(x = xaxis, y = n2, Geom.line, Theme(default_color = colorArr[3])),
  layer(x = xaxis, y = n3, Geom.line, Theme(default_color = colorArr[4])),
  Guide.xlabel("Number of additional processes"),
  Guide.ylabel("Time (sec)"),
  Guide.xticks(ticks = xaxis),
  Guide.manual_color_key("Legend", ["serial", "pfor", "pmap", "manual"], colorArr),
  light_panel
)
# hstack(plot2000, plot3000, plot4000)
# draw(PNG("ex2_2000.png", 6inch, 4inch), plot2000)

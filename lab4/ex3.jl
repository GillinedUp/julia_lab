module LVExpPlot

using Gadfly
using Query
using Formatting
using DataFrames
using Colors
using LVExp

function plotLVExp(N)
  dfanal, dfjoint, paramArr = LVExp.LVExpParamRand(N)
  qdfArr = Vector{DataFrame}(N)
  plotArr = Vector{Gadfly.Plot}(N)
  phasePlot = Gadfly.Plot
  colorArr = Colors.distinguishable_colors(N, Gadfly.parse_colorant("blue"))
  fspec = FormatSpec(".2f")
  for i = 1:N
    qdfArr[i] = @from j in dfjoint begin
                @where j.experiment == ("exp$(string(i))")
                @select {j.t, j.x, j.y, j.diff}
                @collect DataFrame end
    plotArr[i] = Gadfly.plot(qdfArr[i],
                 layer(x="t", y="x", Geom.line, Theme(default_color = colorant"green")),
                 layer(x="t", y="y", Geom.line, Theme(default_color = colorant"red")),
                 Guide.xlabel("Time"), Guide.ylabel("Amount"),
                 Guide.manual_color_key("Legend", ["Prey", "Predators"],
                 map(s -> Gadfly.parse_colorant(s), ["green", "red"])))
  end
  phasePlot = Gadfly.plot([layer(qdfArr[i], x = "x", y = "y",
              Geom.path,
              Theme(default_color = colorArr[i]))
              for i = 1:N]...,
              Guide.xlabel("Prey"),
              Guide.ylabel("Predators"),
              Guide.manual_color_key("Legend",
              ["exp$i: a = $(fmt(fspec, paramArr[1, i])), b = $(fmt(fspec, paramArr[3, i]))\n"*
              "c = $(fmt(fspec, paramArr[3, i])), d = $(fmt(fspec, paramArr[4, i]))\n"*
              "u = ($(fmt(fspec, paramArr[5, i])), $(fmt(fspec, paramArr[6, i])))\n" for i = 1:N],
              colorArr))
  return plotArr, phasePlot
end

end

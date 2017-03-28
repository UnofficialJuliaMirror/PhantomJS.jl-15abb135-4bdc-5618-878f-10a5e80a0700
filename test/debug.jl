
reload("PhantomJS")
reload("VegaLite")

module Try
end

module Try

import PhantomJS
using VegaLite


ts = sort(rand(10))
ys = Float64[ rand()*0.1 + cos(x) for x in ts]

buttons(false)

v = data_values(time=ts, res=ys) +    # add the data vectors & assign to symbols 'time' and 'res'
      mark_line() +                   # mark type = line
      encoding_x_quant(:time) +       # bind x dimension to :time, quantitative scale
      encoding_y_quant(:res); nothing

pio = IOBuffer()
VegaLite.writehtml(pio, v)
seek(pio,0)

res = PhantomJS.renderhtml(pio, format="jpeg")
open(io -> write(io, res), "/tmp/test.jpg", "w")

seek(pio,0)
res = PhantomJS.renderhtml(pio, format="png")
open(io -> write(io, res), "/tmp/test.png", "w")

seek(pio,0)
res = PhantomJS.renderhtml(pio, format="pdf")
open(io -> write(io, res), "/tmp/test.pdf", "w")

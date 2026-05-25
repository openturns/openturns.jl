
import openturns
ot = openturns


point = ot.Point()
point = ot.Point(3, 2.0)
point[1] = 8.0
@show point[1]
@show point
@show ot.norm(point)

point2 = ot.Point([2.0, 3.0])
@show point2

desc = ot.Description()
desc = ot.Description(3, "zou")
desc[1] = "you";
@show desc[1]
@show desc

desc2 = ot.Description(["ab", "cde"])
@show desc2

sample = ot.Sample()
sample = ot.Sample(4, 8)
@show sample
@show sample[1]
sample[1] = ot.Point(8, 42.0)
@show ot.getSize(sample)
@show ot.getDimension(sample)
@show ot.computeMean(sample)



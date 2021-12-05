
import openturns
ot = openturns


inputs = ot.DescriptionBuildDefault(2, "x")
formula = ot.Description(2)
formula[0] = "sin(x0)"
formula[1] = "cos(x1)"
f = ot.SymbolicFunction(inputs, formula)
@show f
@show ot.getInputDimension(f)
@show ot.getOutputDimension(f)
@show ot.call(f, [3.14, 3.14])

function jlfunc2(X)
    x=X[1]
    y=X[2]
    z = x+y
    return [z]
end
@show jlfunc2([4., 8.])

f = ot.JuliaFunction(2, 1, jlfunc2)
@show f
@show ot.getInputDimension(f)
@show ot.getOutputDimension(f)

@show methods(jlfunc2)
@show methods(f)
# jlfunc2()
@show ot.call(f, [4., 8.])
@show ot.getCallsNumber(f)



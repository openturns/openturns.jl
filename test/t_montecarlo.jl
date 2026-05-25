import openturns
ot = openturns


inputs = ot.Description(4)
inputs[0] = "E"
inputs[1] = "F"
inputs[2] = "L"
inputs[3] = "I"
formula = ot.Description(1, "-F*L^3/(3*E*I)")
f = ot.Function(ot.SymbolicFunction(inputs, formula))
mu = ot.Point(4)
mu[0] = 50.0
mu[1] = 1.0
mu[2] = 10.0
mu[3] = 5.0
sigma = ot.Point(4, 1.0)
dist = ot.Normal(mu, sigma)
rv = ot.RandomVector(ot.Distribution(dist))
output = ot.RandomVector(ot.CompositeRandomVector(f, rv))
op = ot.ComparisonOperator(ot.Less())
event = ot.ThresholdEvent(output, op, -3.0)
experiment = ot.MonteCarloExperiment()
experiment_we = ot.WeightedExperiment(experiment)
algo = ot.ProbabilitySimulationAlgorithm(event, experiment_we)
ot.setMaximumOuterSampling(algo, 1000)
ot.run(algo)
result = ot.getResult(algo)
pf = ot.getProbabilityEstimate(result)
@show pf

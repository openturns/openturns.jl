import openturns
ot = openturns

inputs = ["E", "F", "L", "I"]
formula = ["-F*L^3/(3*E*I)"]
f = ot.Function(ot.SymbolicFunction(inputs, formula))
mu = [50.0, 1.0, 10.0, 5.0]
sigma = [1.0, 1.0, 1.0, 1.0]
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

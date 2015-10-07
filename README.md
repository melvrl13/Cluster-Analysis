# Cluster-Analysis
Cluster Analysis is a set codependent of matlab functions that take cluster data as an input and outputs several plots using Markov analysis.

CLUSTERANALYSIS will return multiple plots based on a set of clustering data. It calls the functions listed below and returns the plots described. It also returns a Markov time series and rate matrix. Cutoff is the cutoff for determining a transition from an initial pure state to another state. To simply pick the most likely state at each decision point, use 0. Steps is the maximum number of steps used by Pathways to plot transitions and TimeToEquilibrium to plot the difference in rate matrix-predicted populations from the actual cluster populations.

Its underlying functions are

CLUSTERPOPULATIONS calculates populations (as a whole number count) and equilibrium probability distribution.

CLUSTERTIMESERIES takes each row and turn them into a set of vertically concatonated columns. Assign each frame a cluster number. 

MARKOVRATEMATRIX calculate a row-normalized rate matrix given a set of cluster numbers and corresponding frames in the form [frames cluster#]

PATHWAYS Returns the pathway of a pure state over "maxTimeSteps" of a simulation using a Markov "rateMatrix." A transition out of a pure state is defined by minimum "cutoff" of how likely the system is to have left a pure state. Cutoff is the likelihood a state has transitioned OUT OF a pure state. %If the cutoff is met but the original state is remains the most likely, a transition will NOT be recorded.

TIMETOEQUILIBRIUM plots the difference between the populations predicted by the Markov rate matrix and the equilibrium probability distribution calculated from the original trajectory as a function of steps. 



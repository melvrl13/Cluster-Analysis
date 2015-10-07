function [equilibriumDistribution, timeSeries,rateMatrix] = ClusterAnalysis(cluster,cutoff,steps,outputFolder)
%CLUSTERANALYSIS will return multiple plots based on a set of clustering data. It calls the functions listed below and returns the plots described. It also returns a Markov time series and rate matrix. Cutoff is the cutoff for determining a transition from an initial pure state to another state. To simply pick the most likely state at each decision point, use 0. Steps is the maximum number of steps used by Pathways to plot transitions and TimeToEquilibrium to plot the difference in rate matrix-predicted populations from the actual cluster populations.

%Variables:
%cluster: frames grouped by clusters
%cutoff: probability cutoff for determining a transition from an initial pure state to another state
%steps: number of steps to use for getting reaction pathway and plotting convergence to equilibrium populations
%outputFolder: optional pathway to output directory

%% ClusterAnalysis will overwrite any files with the names it assigns to its output matrices and figures. You should point ClusterAnalysis to an empty directory for outputs. You've been warned!

%Example call: [equilibriumDistribution, timeSeries,rateMatrix]=clusterAnalysis(clusters,0,50,'/Users/melvrl13/Desktop/testingClusterAnalysis/')

%%%% Functions called

%CLUSTERPOPULATIONS calculates populations (as a whole number count) and equilibrium probability distribution.

%MARKOVTIMESERIES takes each row and turn them into a set of vertically concatonated columns. Assign each frame a cluster number. 

%MARKOVRATEMATRIX calculate a row-normalized rate matrix given a set of cluster numbers and corresponding frames in the form [frames cluster#]

%PATHWAYS Returns the pathway of a pure state over "maxTimeSteps" of a simulation using a Markov "rateMatrix." A transition out of a pure state is defined by minimum "cutoff" of how likely the system is to have left a pure state. Cutoff is the likelihood a state has transitioned OUT OF a pure state. %If the cutoff is met but the original state is remains the most likely, a transition will NOT be recorded.

%TIMETOEQUILIBRIUM plots the difference between the populations predicted by the Markov rate matrix and the equilibrium probability distribution calculated from the original trajectory as a function of steps. 

%2014-09-22
%Ryan Melvin
%%%%%
%
%Example call from command line
%matlab -nodesktop -nosplash -r function input1
%%%%%
%ToDo:
%%%%%
%Credit:
%%%%%

% Check if output folder has matlab files. This thing is dumb. It just checks for fig files.
if any(size(dir([outputFolder '/*.fig' ]),1))
	choice = questdlg('This folder contains previous matlab output (i.e., ".fig" files) that may be overwritten', ...
		'Folder not empty', 'Continue', 'Stop', 'Continue');
	switch choice
	case 'Continue'
		;
	case 'Stop'
		disp('Exiting to avoid files being overwritten')
		return 
	end
else 
	;
end



%%%% Execution of functions described above

%% Equilibrium probability distribution of states
if (nargin>3)
	equilibriumDistributionName=strcat(outputFolder,{'/equilibriumPopulations';});
	[~ , equilibriumDistribution] = ClusterPopulations(cluster,equilibriumDistributionName{1});
else
	[~ , equilibriumDistribution] = ClusterPopulations(cluster);
end


%% Markov time series
if (nargin>3)
	timeSeriesName=strcat(outputFolder,{'/clusterTimeSeries'});
	timeSeries = ClusterTimeSeries(cluster,timeSeriesName{1});
else
	timeSeries = ClusterTimeSeries(cluster);
end

%% Markox rate matrix
% Calculate the Markov rate matrix and plot a heatmap
if (nargin>3)
	rateMatrixName=strcat(outputFolder,{'/markovRateMatrix';});
	rateMatrix = MarkovRateMatrix(timeSeries,rateMatrixName{1});	
else
	rateMatrix = MarkovRateMatrix(timeSeries);	
end

%% Markov continued: Probability Analysis
if (nargin>3)
	pathwaysName=strcat(outputFolder,{'/reactionPathway';});
	Pathways(rateMatrix,cutoff,steps,pathwaysName{1});	
else
	Pathways(rateMatrix,cutoff,steps);
end

%% Time to trajectory's equilibrium probability distribtion
% Next let's see how quickly these Markov-rate-based probabilities converge to the populations of the clusters.
if (nargin>3)
	timeToEquilibriumPlotName=strcat(outputFolder,{'/convergingProbabilities';});
	TimeToEquilibrium(rateMatrix,steps,timeToEquilibriumPlotName{1})
else
	TimeToEquilibrium(rateMatrix,steps)
end

end

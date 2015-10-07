function [ populations, probabilities] = ClusterPopulations(cluster,outName)
%CLUSTERPOPULATIONS calculates populations (as a whole number count) and equilibrium probability distribution.
%Variables:
%cluster: cluster data
%outName: path and prefix for output plot (.fig) and probability vector (.mat)


%Date: Mon May 11 11:58:17 EDT 2015
%Author Name Ryan Melvin
%%%%%
%
%Example call from command line
%matlab -nodesktop -nosplash -r function input1
%%%%%
%ToDo:
%%%%%
%Credit:
%%%%%

%Count the number of states in each cluster. Note that for LabView output, if a 0th frame is in the cluster data, it is not included in the calculations. Really, this is because I can't figure out a way to include it.
checkSource = sum(sum(sum(isnan(cluster))));

	if checkSource ~= 0
		%For VMD modified output
		populations = sum(~isnan(cluster),2);
	end

	if checkSource == 0
		%For ProteinAnalysis/LabView output
                populations = sum(cluster ~= 0); 
	end

frames = sum(populations);

probabilities = populations/frames;


%Plot probabilities as a bar chart

equilibriumDistributionPlot = figure;

bar(probabilities);
        xlabel('Cluster','FontSize',14)
        ylabel('Probability','FontSize',14)
        title('Equilibrium Probability Distribution','FontSize',18)

	%If an output folder was specified, save the figure and vector to that folder.
	if (nargin>1)
		figName=strcat(outName,{'.fig'});
		matrixName=strcat(outName,{'.txt'});
		savefig(equilibriumDistributionPlot,figName{1})
		dlmwrite(matrixName{1},probabilities)
	end
end

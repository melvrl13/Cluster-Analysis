function [rateMatrix] = MarkovRateMatrix(timeSeries,outName)
%MARKOVRATEMATRIX calculate a row-normalized rate matrix given a set of cluster numbers and corresponding frames in the form [frames cluster#s]. "outName" is an optional argument.

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


states=max(timeSeries(:,2));

%Make sure the time series is sorted by frame number
timeSeries=sortrows(timeSeries,1);

%Ignore the frame numbers from here forward
markovChain=timeSeries(:,2);

Norder = 1; %For a completely memoryless markov chain

% This method is a bit opaque but super fast.
% We've tested with multiple simple models to confirm row is transition from and column is transition to.
transitionMatrix = full(sparse(markovChain(1:end-1),markovChain(2:end),1,states^Norder,states));

%Normalize so each row sums to 1
%This method will fail if any row sums to zero, but that input would be nonsensical.
%Methods accounting for rows summing to zero may be slower, so I've stuck with this option until it becomes a problem. If you're looking for the solution, it's something like 
%rateMatrix = spdiags(spfun(@(x) 1./x,sum(transitionMatrix,2)),0,states,states)*transitionMatrix;
%where S is the rateMatrix
rateMatrix=spdiags(sum(transitionMatrix,2),0,states,states)\transitionMatrix;

%Format for nice-looking pcolor
rateMatrixTemp=rateMatrix;
rateMatrixTemp(states+1,:)=zeros;
rateMatrixTemp(:,states+1)=zeros;

%Plot the Rate Matrix as a heat map.

rateMatrixHeatMap=figure;
%rateMatrixTemp(rateMatrixTemp==0)=NaN; %Uncomment this line to
%make zeroes display as white
pcolor(rateMatrixTemp)
shading flat
colormap(jet)
set(gcf, 'renderer', 'zbuffer');
colorbar
ylabel('From Cluster; Decreasing Population ->','FontSize',14)
xlabel('To Cluster; Decreasing Population ->','FontSize',14)
title('RateMatrix Heat Map','FontSize',18)

if (nargin>1)
	figName=strcat(outName,{'.fig'});
	matrixName=strcat(outName,{'.txt'});
	savefig(rateMatrixHeatMap,figName{1})
	dlmwrite(matrixName{1},rateMatrix)
end
end

function [pathways]=TransitionPathways(rateMatrix,transitionThreshold,maxTimeSteps,outName)
%FUNNELDENDROGRAM Returns the pathway of a pure state over "maxTimeSteps" of a simulation using a Markov "rateMatrix." A transition out of a pure state is defined by minimum "transitionThreshold" of how likely the system is to have left a pure state. transitionThreshold is the likelihood a state has transitioned OUT OF a pure state. %If the transitionThreshold is met but the original state is remains the most likely, a transition will NOT be recorded.

%Depending on how you use this function, you should consider citing the paper that inspired it: 
%Prada-Gracia, D., Gómez-Gardeñes, J., Echenique, P., & Falo, F. (2009). Exploring the free energy landscape: From dynamics to networks and back. PLoS Computational Biology, 5(6). doi:10.1371/journal.pcbi.1000415

%2015-04-01
%Ryan Melvin
%%%%%
%
%Example call from command line
%matlab -nodesktop -nosplash -r function input1
%%%%%
%ToDo: Still not really a dendrogram....
%%%%%
%Credit:Based on script by Fred Salsbury.
%%%%%

L=length(rateMatrix);
time=maxTimeSteps; %max timesteps

%Ignore the unlustered state
N=rateMatrix(1:L,1:L);

%Preallocate T
%Record all starting states
T0=1:L; %Is this right?

%Preallocate by assuming they all stay in the pure states (that is, an entirely diagonal transition matrix).
%Also, this setup means we don't have update the matrix unless a transition has occurred.
T=repmat(T0',1,time);

%Begin operating with rateMatrix^timestep for all timesteps
for k=2:time
M=N^(k-1);
%Pull out the diagonal elements
checkPure=diag(M);

%See if the state is still pure based on transitionThreshold
notPure=checkPure<(1-transitionThreshold);

%Find most likely current state for each initially pure state
[~,columnIndex]=max(M,[],2);

%Record the change (and ONLY the change) in T
T(notPure,k)=columnIndex(notPure);

end
%Format for plotting. Time moves down each column.
pathways=T';

%Plot Dendrogram
funnelDendrogram=figure;
stairs(pathways,'--o');
colormap(jet)
xlabel('Timesteps')
ylabel('Macrostate')
title('Transition Pathways')
if (nargin>3)
	figName=strcat(outName,{'.fig'});
	matrixName=strcat(outName,{'.txt'});
	savefig(funnelDendrogram,figName{1})
	dlmwrite(matrixName{1},pathways)
end
end

function [] = TimeToEquilibrium(rateMatrix,steps,outName)
%TIMETOEQUILIBRIUM plots the difference between the populations predicted by the Markov rate matrix and the equilibrium probability distribution calculated from the original trajectory as a function of steps. If an outName is provided, this function will save a figure with that name. DO NOT provide the file extension. That is automatically added.
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

states=length(rateMatrix);
ratio=zeros(states,steps+1); % there will be one ratio for each N and for S
P=zeros(states,states,steps); % we will calculate for each possible pure initial state
I=zeros(states,states);
for i = 1:states
	    I(i,i)=1; % prepare an initial state
end

for k=1:steps+1 % for each pure state we will loop over steps
    P(:,:,k)=I'*rateMatrix^k; % this gives us the probability matrix for each state and each step
 end
 
for i=1:states
	for j=1:states
		for k=1:steps+1
		    ratio(i,j,k)=(P(i,j,k)-P(i,j,steps+1))/(I(i,j)-P(i,j,steps+1));
		end
	end
end
h = zeros(1,states);
Clines = lines(states);
convergingProbabilitiesPlot=figure;
hold
for i=1:states
	colorset = Clines(i,:);
	for j=1:states
		if j == 1
			h(i) = plot(squeeze(ratio(i,j,:)),'color',colorset);
		else
			plot(squeeze(ratio(i,j,:)),'color',colorset)
		end
	end
	convergeLegendInfo{i} = ['State ' num2str(i)];
end
title('Converging Probabilities','FontSize',18)
hold

% legend(h, convergeLegendInfo)

if (nargin>2)
		figName=strcat(outName,{'.fig'});
		savefig(convergingProbabilitiesPlot,figName{1})
end
end

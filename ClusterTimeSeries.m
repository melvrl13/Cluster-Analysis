function [timeSeries] = ClusterTimeSeries(cluster,outName)
%MARKOVTIMESERIES takes each row and turn them into a set of vertically concatonated columns. Assign each frame a cluster number.  "outFile" is an optional for where to save a figure and matrix. Do not provide a file extension.

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

%Initialize variables
%Find out how many states there are. I suppose this woulnd't work if you have more states than frames, but that seems silly anyway... 
states = min(size(cluster));
checkSource = sum(sum(sum(isnan(cluster))));
        for idx = 1:states
            if checkSource ~= 0
                %For VMD modified output
                temp = (cluster(idx,:))';
                temp( all( isnan( temp ), 2 ), : ) = [];
            end
            if checkSource == 0
                %For ProteinAnalysis output
                temp = (cluster(:,idx));
                temp = temp(1:find(temp,1,'last'));
            end
            temp0 = zeros(size(temp));
            tempi = temp0 + idx;
            tempCat = horzcat(temp,tempi);
            if idx == 1
                timeSeries = tempCat;
            else
                timeSeries = vertcat(timeSeries,tempCat);
            end
        end
	%Now sort the timeseries by frame number.
	timeSeries=sortrows(timeSeries,1);
        % Plot Cluster v. Frame #
        % Now we can see the patterns of how the molecule transitions between
        % frames.
        clusterVFramePlot=figure;
        scatter(timeSeries(:,1),timeSeries(:,2),'+')
        xlabel('Frame','FontSize',14)
        ylabel('Cluster','FontSize',14)
        title('Cluster vs.Frame','FontSize',18)

	%If an output folder was specified, save the figure to that folder.
	if (nargin>1)
		figName=strcat(outName,{'.fig'});
		matrixName=strcat(outName,{'.txt'});
		savefig(clusterVFramePlot,figName{1})
		dlmwrite(matrixName{1},timeSeries)
	end
end

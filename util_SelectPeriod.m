function [Date, Data] = util_SelectPeriod(Date,DatePeriod,Data)

% Input 

% Date:           The entire period available.
% DatePeriod:     Desired period for MESH simulation.
% Data:           Matrix Time Series Meteorological Variable. Dim(Lat,Lon,t)

% Output
% Date:           Vector with Desired period for MESH simulation.
% Data:           Time series of meteorological variable for MESH Sim.

Ind = ismember(Date,DatePeriod);
Data = Data(:,:,Ind);
Date = Date(Ind);

end

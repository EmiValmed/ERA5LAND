function main
clear; close all; clc
%% Declarations

% Directories
mainPath =  'Main directory';                  % To modify  
ncPath   =  fullfile(mainPath,'netCDF_Files');       
matPath  =  fullfile(mainPath,'OutputERA5-Land');    
r2cPath  =  fullfile(mainPath,'r2cFiles');           
shpPath  =  'Shapefile path';                  % To modify                                            

% Coordinates origine, delta and count (MESH parameters)

xOrigin  = -86.9235;   % To modify
yOrigin  = 48.7076;    % To modify
xCount   = 5;          % To modify
yCount   = 7;          % To modify
xDelta   = 0.205960;   % To modify
yDelta   = 0.134740';  % To modify

                       % ----------------------------------------------------------------------------------------------------
                       % Note: The values written above correspond to the MESH Sample. This should be changed according to  
                       % the data of the project. In the r2cFile.m function, there is a definition of each value and how they 
                       % can be obtained from the latitude and longitude of the netCDF files.These values should be the same 
                       % for all variables.
                       % ----------------------------------------------------------------------------------------------------

% Reduction

Reducc = 0 ; % To modify

                       % ----------------------------------------------------------------------------------------------------
                       % Note: This variable specifies whether to work with the complete grid (0) or with a sample (1).
                       % ----------------------------------------------------------------------------------------------------


% Time difference between UTC and the local time

LocalZone = '-00:00';  % To modify

                       % ----------------------------------------------------------------------------------------------------
                       % Note: You can specify the time zone value as a character vector of the form +HH:mm or -HH:mm, which
                       % represents a time zone with a fixed offset from UTC that does not observe daylight saving time.
                       % You can also specify the time zone value as the name of a time zone region in the Internet Assigned
                       % Numbers Authority (IANA) Time Zone Database. Run the function "timezones" in the command Windows to
                       % display a list of all IANA time zones accepted by the "datetime" function.
                       % ----------------------------------------------------------------------------------------------------
  
% Catchment name

CatchName = '030282';% To modify                                           % The name of the catchment must match the name of the shapefile. 
                                                                           % e.g., CathmentName = '030282' --> Shapefilename = '030282.shp'


% ---------------------------------------------------------------------------------------------------------------------------
%                                             DO NOT TOUCH FROM HERE
% ---------------------------------------------------------------------------------------------------------------------------
%% Loop to extract each variable   

% Creating output directoy if it does not exist
if ~exist(fullfile(matPath), 'dir')
    mkdir(fullfile(matPath)); addpath(matPath);
end
if ~exist(fullfile(r2cPath), 'dir')
    mkdir(fullfile(r2cPath)); addpath(r2cPath);
end

% Cahnging actual path to the main directory
cd(mainPath)
addpath(genpath(mainPath));


% Variable setting
VarName_nc     = {'d2m';'sp';'t2m';'tp';'ssrd';'strd';'u10';'v10'};        % This is the name of the variable in the *.nc file        
VarName        = {'DewPoint';'Pressure';'Temperature';'Precipitation';...
    'Shortwave';'Longwave';'Wind_u';'Wind_v'};                              
VarType        = [0,0,0,1,1,1,0,0];                                        % A value of 1(0) indicates if the variable is(not) accumulated from the 
                                                                           % beginning of the forecast time to the end of the forecast step.                                      


for iVar = 4:length(VarName)
    
    % NetCDF files directories
    dataPathVar = sprintf('%s/%s/',ncPath,VarName{iVar}) ; 
    addpath(dataPathVar);
   
   
    %% Extracting and concatenating variables to local time
    
    ERA5LAND_Extract(VarName_nc{iVar},VarName{iVar},VarType(iVar),LocalZone,CatchName,dataPathVar,matPath,shpPath)
    
end

%% Creating .r2c Files

Creating_r2c(r2cPath,xOrigin,yOrigin,xCount,yCount,xDelta,yDelta,Reducc)
%% -----------------------------------------------------------END------------------------------------------------------------
clear

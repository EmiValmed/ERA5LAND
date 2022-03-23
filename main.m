clear; close all; clc
%% Declarations

% Directories
dataPath= 'Path where the .nc files are located'  ;                                  % To modify                          
OutPath=  'Path where you want to save the results of the concatenated values'   ;   % To modify      
addpath(dataPath);
addpath(OutPath);

if ~exist(fullfile(OutPath), 'dir')
    mkdir(fullfile(OutPath)); addpath(OutPath);
end

% Variable specifications
VarName     = 't2m';                   % To modify
Name        = 'Temperature';           % To modify
AccVariable = 0; % could be 0 or 1     % To modify

% Time difference between UTC and the local time
LocalZone = '-05:00';  % To modify

                       % ----------------------------------------------------------------------------------------------------
                       % Note: You can specify the time zone value as a character vector of the form +HH:mm or -HH:mm, which
                       % represents a time zone with a fixed offset from UTC that does not observe daylight saving time.
                       % You can also specify the time zone value as the name of a time zone region in the Internet Assigned
                       % Numbers Authority (IANA) Time Zone Database. Run the function timezones in the command Windows to
                       % display a list of all IANA time zones accepted by the datetime function.
                       % ----------------------------------------------------------------------------------------------------

%% -------------------------------------------------- DO NOT TOUCH FROM HERE ------------------------------------------------

%% Extracting and concatenating variables to local time

ERA5LAND_Extract(VarName_nc,VarName,VarType,LocalZone,dataPath,OutPath)

%% -----------------------------------------------------------END------------------------------------------------------------
clear

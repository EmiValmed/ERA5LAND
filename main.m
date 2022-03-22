clear; close all; clc
%% Declarations

% Directories
dataPath= 'Path where the .nc files are located'                                 ; addpath(dataPath);
OutPath=  'Path where you want to save the results of the concatenated values'   ; addpath(OutPath);

if ~exist(fullfile(OutPath), 'dir')
    mkdir(fullfile(OutPath)); addpath(OutPath);
end

% Datebase
VarName     = 't2m';                   % To modify
Name        = 'Temperature';           % To modify
AccVariable = 0; % 1/0                 % To modify

% Time difference between UTC and the local time
TimeZone  = 'UTC';
LocalZone = '-05:00';  % To modify
                       % ----------------------------------------------------------------------------------------------------
                       % Note: You can specify the time zone value as a character vector of the form +HH:mm or -HH:mm, which
                       % represents a time zone with a fixed offset from UTC that does not observe daylight saving time.
                       % You can also specify the time zone value as the name of a time zone region in the Internet Assigned
                       % Numbers Authority (IANA) Time Zone Database. Run the function timezones in the command Windows to
                       % display a list of all IANA time zones accepted by the datetime function.
                       % ----------------------------------------------------------------------------------------------------

%% -------------------------------------------------- DO NOT TOUCH FROM HERE ------------------------------------------------

%% Step 1: Recognizing  .nc files in the directory

ncFiles = dir(strcat(dataPath,'*.nc'));

for ifile = 1:size(ncFiles,1)
    
    tmp = split(convertCharsToStrings(ncFiles(ifile).name), ["_",".nc"]);
    StartDate(ifile,1) = tmp(1);
    EndDate(ifile,1) = tmp(2);
    
end

StartYear = split(StartDate(1,1), "-");  StartYear = str2double(StartYear(1));
EndYear   = split(EndDate(end,1), "-");  EndYear   = str2double(EndYear(1));


%% Step 2: Importing NetCDF coordinates
fileToRead=fullfile(dataPath, sprintf('%s_%s.nc', StartDate{1},EndDate{1}));
ncid = netcdf.open(fileToRead,'NC_NOWRITE');

latitude = netcdf.getVar(ncid,netcdf.inqVarID(ncid,'latitude'),'single');
longitude = netcdf.getVar(ncid,netcdf.inqVarID(ncid,'longitude'),'single'); 
nlat = length(latitude);
nlon = length(longitude);

netcdf.close(ncid);

%% Step 3: Retrieving NetCDF data for iFiles 

for iDates = 1: numel(StartDate)
    
    % Display process
    if rem( iDates,round(numel(StartDate)/50,0) ) == 0
        mntoc = round(toc/60,1);
        fprintf('%2.0f %% of files read - time elapsed %s minutes \n',iDate/numel(StartDate)*100, mntoc)
    end
    
    % Open NetCDF file
    fileToRead=fullfile(dataPath, sprintf('%s_%s.nc', StartDate{iDates},EndDate{iDates}));
    ncid = netcdf.open(fileToRead,'NC_NOWRITE');
    
    % Retrieve ERA5LAND variables and attributes (scale_factor and add_offset).
    
    % Variable    
    dataVar = getVariables(VarName,ncid);
    
    % Time
    Date = netcdf.getVar(ncid,netcdf.inqVarID(ncid,'time'),'double');
    Date = datenum(Date./24) + datenum('1900-01-01 00:00:00');
    ntime = numel(Date);
    
    % Close NetCDF file
    netcdf.close(ncid);
        
    % Define output file name
    outfile = sprintf('%s/%s_%s_%s.mat',dataPath,VarName,StartDate{iDates},EndDate{iDates});
    
    % Export temporal *.mat files
    save(outfile,'dataVar', 'Date','longitude','latitude', '-v7.3');
    
end


%% Step 4: Concatenating all the *.mat files

matFiles = dir(strcat(dataPath,sprintf('/%s*.mat',VarName)));
tmp=[];                                  % start w/ an empty array
for i=1:length(matFiles)
    tmp=[tmp; load(matFiles(i).name)];   % read/concatenate into x
end

delete *.mat % Deleting all temporary *.mat files

%% Step 5: Getting variables
tmp2 = struct2cell(tmp);
Datetmp = datevec(vertcat(tmp2{1,:}));    % Date in the original timeZone.                                                        
Vartmp = cat(3,tmp2{2,:,:,:});            % Variable time serie.

%% Step 6: Disaccumulating variable if required and convert time to local time

if AccVariable == 1
    % Index to start and finish the diff (getting the hourly values without accumulating) 
    diffSD = find(Datetmp(:,4)==1 & Datetmp(:,1)==StartYear, 1 );      % SD: start date.
    diffED = find(Datetmp(:,4)==0 & Datetmp(:,1)==EndYear, 1,'last');  % ED: End date.
    
    % Deaccumulate variables 
    Vartmp1 = Vartmp(:,:,diffSD:diffED);
    Vartmp2 = descVar(Vartmp1,24,nlon,nlat);
    
    % Local time
    Datetmp = datetime(datenum(Datetmp(diffSD:diffED,:)),'ConvertFrom', 'datenum','TimeZone',TimeZone);
    Datetmp.TimeZone = LocalZone;   % Conversion to local time.
    
else
    Datetmp = datetime(datenum(Datetmp),'ConvertFrom', 'datenum','TimeZone',TimeZone);
    Datetmp.TimeZone = LocalZone;   % Conversion to local time.
    Vartmp2 = Vartmp;
end

% Considering full day at the local time
LocalDate = datevec(Datetmp);
SD = find(LocalDate(:,4)==1 & LocalDate(:,1)==StartYear, 1 );      % SD: start date.
ED = find(LocalDate(:,4)==0 & LocalDate(:,1)==EndYear, 1,'last');  % ED: End date.
LocalDate = datenum(LocalDate(SD:ED,:));                           % SD and ED are index to consider full days in the local 
Var1tmp = Vartmp2(:,:,SD:ED);                                      % time (from 1h to 00h)

%%  Step 6: EXPORTING DATA

% Define output file name
outfile = sprintf('%s/%s.mat',OutPath,Name);

% Export
save(outfile,'LocalDate','Var1tmp','latitude','longitude','-v7.3');


%% ---------------------------------------------------------- END -----------------------------------------------------------

function ERA5LAND_Extract(VarName_nc,VarName,VarType,LocalZone,CatchName,dataPath,OutPath,shpPath)
% function ERA5LAND_Extract(VarName_nc,VarName,VarType,LocalZone,CatchName,dataPath,OutPath,shpPath)
%
%   INPUT:
%       VarName_nc     - String variable with the meteo parameter's name attribute in the *.nc file
%                        (e.g., 'tp' --> total precipitation; 't2m' --> temperature, etc.).
%
%       VarName        - String variable with the meteo parameter (e.g., Precipitation,
%                        Temperature, Humidity, etc.).
%
%       VarType        - 1 if the values of the variable in ERA5LAND are accumulated
%                        over time (e.g., precipitation, evaporation), 0 otherwise.
%
%       LocalZone      - Time difference between UTC and the local time.
%
%       CatchNem       - Catchment name.
%
%       dataPath       - Path where the *.nc files are located.
%
%       OutPath        - Path of the results.
%
%       shpPath        - Path of the shapefile .
%
%
%    OUTPUT:
%                      - A *.mat file with the Date, variable time serie,
%                        latitude and longitude vectors, and latitude and logitude matrix (like a grid).



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

fileToRead = fullfile(dataPath, sprintf('%s_%s.nc', StartDate{1},EndDate{1}));
ncid       = netcdf.open(fileToRead,'NC_NOWRITE');

latitude  = netcdf.getVar(ncid,netcdf.inqVarID(ncid,'latitude'),'single');
longitude = netcdf.getVar(ncid,netcdf.inqVarID(ncid,'longitude'),'single');
lonGrid   = repmat(longitude, [1, size(latitude,1)])';
latGrid   = repmat(latitude, [1, size(longitude,1)]);

nlat = length(latitude);
nlon = length(longitude);

%% Step 3: Create catchment mask

Mask = util_CatchMask(latGrid,lonGrid,CatchName,shpPath);

netcdf.close(ncid);

%% Step 4: Retrieving NetCDF data for iFiles

for iDates = 1: numel(StartDate)

    % Display process
    if rem( iDates,round(numel(StartDate)/50,0) ) == 0
        mntoc = round(toc/60,1);
        fprintf('%2.0f %% of files read - time elapsed %s minutes \n',iDate/numel(StartDate)*100, mntoc)
    end

    % Open NetCDF file
    fileToRead = fullfile(dataPath, sprintf('%s_%s.nc', StartDate{iDates},EndDate{iDates}));
    ncid       = netcdf.open(fileToRead,'NC_NOWRITE');

    % Retrieve ERA5LAND variables and attributes (scale_factor and add_offset).

    % Variable time serie and Date
    [dataVar,Date] = util_getVariables(VarName_nc,ncid);

    % Close NetCDF file
    netcdf.close(ncid);

    % Define output file name
    outfile = sprintf('%s/%s_%s_%s.mat',dataPath,VarName_nc,StartDate{iDates},EndDate{iDates});

    % Export temporal *.mat files
    save(outfile,'dataVar', 'Date','longitude','latitude', '-v7.3');

end


%% Step 5: Concatenating all the *.mat files

matFiles = dir(strcat(dataPath,sprintf('/%s*.mat',VarName_nc)));
tmp=[];                                  % start w/ an empty array
for i=1:length(matFiles)
    tmp=[tmp; load(matFiles(i).name)];   % read/concatenate into x
end

%% Step 6: Getting variables

tmp2 = struct2cell(tmp);
Datetmp = datevec(vertcat(tmp2{1,:}));    % Date in the original timeZone.
Vartmp = cat(3,tmp2{2,:,:,:});            % Variable time serie.

%% Step 7: Disaccumulating variable if required and convert time to local time

TimeZone  = 'UTC';
% Index to start and finish the diff (getting the hourly values without accumulating)
diffSD = find(Datetmp(:,4)==1 & Datetmp(:,1)==StartYear, 1 );      % SD: start date.
diffED = find(Datetmp(:,4)==0 & Datetmp(:,1)==EndYear, 1,'last');  % ED: End date.

if VarType == 1

    % Deaccumulate variables
    Vartmp1 = Vartmp(:,:,diffSD:diffED);
    Vartmp2 = util_descVar(Vartmp1,24,nlon,nlat);

else

    Vartmp2 = Vartmp(:,:,diffSD:diffED);
end

% Local time
Datetmp = datetime(datenum(Datetmp(diffSD:diffED,:)),'ConvertFrom', 'datenum','TimeZone',TimeZone);
Datetmp.TimeZone = LocalZone;   % Conversion to local time.

% Considering full day at the local time
LocalDate = datevec(Datetmp);
SD = find(LocalDate(:,4)==1 & LocalDate(:,1)==StartYear, 1 );      % SD: start date.
ED = find(LocalDate(:,4)==0 & LocalDate(:,1)==EndYear, 1,'last');  % ED: End date.
Date = datenum(LocalDate(SD:ED,:));                                % SD and ED are index to consider full days in the local
Datatmp = Vartmp2(:,:,SD:ED);                                      % time (from 1h to 00h)
ntime = numel(Date);

% Trick for computing cathcment mask
tmp00   = arrayfun(@(tstep) squeeze(Datatmp(:,:,tstep)),1:ntime,'UniformOutput',0);

%% Step 7: computing cathcment mask -- Selecting data into the catchment's boundaries.


mask = Mask.(sprintf('C%s',CatchName));
Data = cellfun(@(x) x.*mask,tmp00,'UniformOutput', false);

% changing zeros to NaN
Data = cellfun(@(M) subsasgn(M, substruct('()', {find(M==0)}), NaN), Data, 'uniform', 0);

% Convert cell to matrix (original dimension)
Data = cat(3,Data{:});

%%  Step 8: EXPORTING DATA

% Define output file name
outfile = sprintf('%s/%s.mat',OutPath,VarName);

% Export
save(outfile,'Date','Data','latitude','longitude','lonGrid','latGrid','-v7.3');

%% Deleting matlab temporary files

filePattern = fullfile(dataPath, '*.mat');
theFiles = dir(filePattern);

for k = 1 : length(theFiles)
    baseFileName = theFiles(k).name;
    fullFileName = fullfile(dataPath, baseFileName);
    delete(fullFileName);
end

end
%% ---------------------------------------------------------- END -----------------------------------------------------------

function r2cFile(Data,Date,OutPath,OutName,xOrigin,yOrigin,xCount,yCount,xDelta,yDelta,Reducc)
%function r2cFile(Data,Date,OutPath,OutName,xOrigin,yOrigin,xCount,yCount,xDelta,yDelta)
% INPUTS
%       -Data                :  Meteorological variable time series.
%
%       -Date                :  Vector with the dates in datenum format.
%
%       -OutPath             :  Path of the results. 
%
%       -OutName             :  Output file name. Must correspond to the name 
%                               of the meteorological variable specified by MESH 
%                               docuemntation:
%                               • rain
%                               • humidity
%                               • pres
%                               • temperature                
%                               • longwave
%                               • shortwave
%                               • wind
%
%       -:xOrigin            :  This is the x-coordinate of the point in the bottom left corner of the grid.
%       -:yOrigin            :  This is the y-coordinate of the point in the bottom left corner of the grid.
%       -:xCount             :  The number of points, or vertices, in each row of the grid,along the x-direction.
%       -:yCount             :  The number of points, or vertices, in each column of the grid,along the y-direction.
%       -:xDelta             :  The distance betwwen two adjacent points in a row.
%       -:yDelta             :  The distance betwwen two adjacent points in a column.
%
% OUTPUT
%       -basin_OutName.r2c   :  a .r2c files with the requiremts to fed the MESH
%                              model.

%% Specifications of the variable at a hand

switch lower( OutName ) 
    case 'rain'
        fmt = [repmat(' %.7f ', 1, yCount) '\n']; 
        KeyName = 'PR0';
        VarName = 'Precipitation_rate';
        Unit    = 'mm/s';
        
    case 'humidity'
        fmt = [repmat(' %.6f ', 1, yCount) '\n']; 
        KeyName = 'HU';
        VarName =  'Specific_humidity';
        Unit    = ' kg/kg';
        
    case 'pres'
        fmt = [repmat(' %.1f ', 1, yCount) '\n']; 
        KeyName = 'PO';
        VarName = 'Surface_Pressure';
        Unit = 'Pa';
        
    case 'temperature'
        fmt = [repmat(' %.2f ', 1, yCount) '\n']; 
        KeyName = 'TT';
        VarName = 'Air_temperature_40m';
        Unit = 'K';
        
    case 'longwave'
        fmt = [repmat(' %.2f ', 1, yCount) '\n']; 
        KeyName = 'FI';
        VarName = 'Longwave_down';
        Unit = 'W/m2';
        
    case 'shortwave'
        fmt = [repmat(' %.2f ', 1, yCount) '\n']; 
        KeyName = 'FB';
        VarName = 'Shortwave_down';
        Unit = 'W/m2';
        
    case 'wind'
        fmt = [repmat(' %.2f ', 1, yCount) '\n']; 
        KeyName = 'UV';
        VarName = 'Wind_speed';
        Unit = 'm/s';
        
end

%% CREATING .r2c file

% Date format
format_out =('"yyyy/mm/dd HH:MM:SS.000"');
dtime_str  = datestr(Date, format_out);

% File name and path 
FileNmeAndPath = fullfile(sprintf('%s/basin_%s.r2c',OutPath,OutName));
fVar = fopen(FileNmeAndPath, 'w');          

% Creation Time
t = datetime('now');
CreationDate = datestr(t);

% ---------------------------------------------------------------------------------------------------------------------------
%                                                           Header
% ---------------------------------------------------------------------------------------------------------------------------
% Important!! 
%It is highly recommended not to touch this block. The MESH model is sensitive to input formats.


%Line 1-5
fprintf(fVar, '%s\n','########################################',...
    ':FileType r2c  ASCII  EnSim 1.0','#','# DataType               2D Rect Cell','#');

%Line 6-9
fprintf(fVar, '%s\n',':Application             FORTRAN',':Version                 1.0.0',':WrittenBy               HYDROMET TEAM',...
    sprintf(':CreationDate            %s',CreationDate));

%Line 10-15
fprintf(fVar, '%s\n','#','#---------------------------------------','#',sprintf(':Name                    %s',KeyName),...
    '#',':Projection              LATLONG',':Ellipsoid               WGS84');

%Line 16-20
fprintf(fVar, '%s\n','#',sprintf(':xOrigin                  %s',xOrigin),sprintf(':yOrigin                   %s',yOrigin),...
    '#',':SourceFile              XXXX/           X');

%Line 21-24
fprintf(fVar, '%s\n', '#',sprintf(':AttributeName           %s',VarName),sprintf(':AttributeUnit           %s',Unit),'#');

%Line 25-30
fprintf(fVar, '%s\n',sprintf(':xCount                   %d',xCount),sprintf(':yCount                   %d',yCount),...
    sprintf(':xDelta                   %.6f',xDelta),sprintf(':yDelta                   %.6f',yDelta),'#','#');

%Line 31
fprintf(fVar, '%s\n', ':endHeader');
% ---------------------------------------------------------------------------------------------------------------------------
%                                                      END Header
% ---------------------------------------------------------------------------------------------------------------------------

% Creating frames date
for j = 1:size(Data,3)
    fprintf(fVar, '%s %8d %7d %s\n', ':Frame',j ,j, dtime_str(j,:)); % Dates lines. Defining Frames' name
    if Reducc == 1
        Variable = squeeze(Data(:,:,j));
        [Xq,Yq] = meshgrid(1:xCount,1:yCount); % resize 
        Variable = interp2(Variable,Xq,Yq);    % Reducing data       
    elseif Reducc== 0
        Variable = squeeze(Data(:,:,j));
    end
    fprintf(fVar, fmt, Variable.');
    fprintf(fVar, '%s\n', ':EndFrame');
end
fclose(fVar);
end

    

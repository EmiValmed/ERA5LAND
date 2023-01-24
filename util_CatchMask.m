function Mask = util_CatchMask(lat0b,lon0b,nameC,shpPath)


% Import ctch shape
[S]=shaperead(fullfile(shpPath,sprintf('%s.shp',nameC)));

% Get points inside the catchment
inGrid_tmp = inpolygon(lon0b,lat0b,S.X,S.Y);

% Transpose mask for NetCDF compatibility (y,x,T)
inGrid_tmp = transpose(inGrid_tmp);

% Store for NetCDF extraction
Mask.(sprintf('C%s',nameC)) = inGrid_tmp;

end

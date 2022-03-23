function [dataVar,Date] = getVariables(VarName,ncid)

% Variable time serie
sf   = netcdf.getAtt(ncid,netcdf.inqVarID(ncid,VarName),'scale_factor');
ao   = netcdf.getAtt(ncid,netcdf.inqVarID(ncid,VarName),'add_offset');
dataVar = netcdf.getVar(ncid,netcdf.inqVarID(ncid,VarName),'double');
dataVar = (dataVar .* sf + ao );

% Date 
Date = netcdf.getVar(ncid,netcdf.inqVarID(ncid,'time'),'double');
Date = datenum(Date./24) + datenum('1900-01-01 00:00:00');

end
end

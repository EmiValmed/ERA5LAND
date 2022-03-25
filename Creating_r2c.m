function Creating_r2c (OutPath,xOrigin,yOrigin,xCount,yCount,xDelta,yDelta)
%% Declarations

% Directories
addpath(genpath('OutputERA5-Land'));

%% ---------------------------------------------------- Loading data---------------------------------------------------------
%% Total precipitation in mm/s

load('Precipitation.mat','Date','Data');
tp = Data*(1000/3600); 

r2cFile(tp,Date,OutPath,'rain',xOrigin,yOrigin,xCount,yCount,xDelta,yDelta)

%% Surface pressure in Pa
load('Pressure.mat','Date','Data');
sp = Data;

r2cFile(sp,Date,OutPath,'pres',xOrigin,yOrigin,xCount,yCount,xDelta,yDelta)

%% Air surface temperature in K
load('Temperature.mat','Date','Data');
t2m = Data;

r2cFile(t2m,Date,OutPath,'temperature',xOrigin,yOrigin,xCount,yCount,xDelta,yDelta)

%% Specific Humidity in Kg/Kg

% Dew point temperature in K
load('DewPoint.mat','Date','Data');
d2m = Data;

epsilon = 622; % g kg-1
LvRv = 5423; % K
e0 = 0.6113; % kPa
t0 = 273.16; % K

% équation humidite spécifique (q)
for i = 1: length(d2m)
e = (epsilon.*e0)./(sp(:,:,i)/1000).*exp(LvRv*(1/t0 - 1./d2m(:,:,i)));% water vapor pressure
e_s = (epsilon.*e0)./(sp(:,:,i)/1000).*exp(LvRv*(1/t0 - 1./t2m(:,:,i)));% saturation vapor pressure
RH = e./e_s;
aux = (0.7859+0.03477.*(t2m(:,:,i)-273.15))./(1.0 + 0.00412.*(t2m(:,:,i)-273.15))+2;
e_a = RH.*(10.^(aux)); %surface presure (Pa)
q(:,:,i) = 0.622*e_a./(sp(:,:,i) - 0.378*e_a);
end

r2cFile(q,Date,OutPath,'humidity',xOrigin,yOrigin,xCount,yCount,xDelta,yDelta)

%% Shortwave  in W/m2
load('Shortwave.mat','Date','Data');
ssrd = Data*(1/3600);

r2cFile(ssrd,Date,OutPath,'shortwave',xOrigin,yOrigin,xCount,yCount,xDelta,yDelta)

%% Longwave  in W/m2
load('Longwave.mat','Date','Data');
strd = Data*(1/3600);

r2cFile(strd,Date,OutPath,'longwave',xOrigin,yOrigin,xCount,yCount,xDelta,yDelta)

%% u10 Wind component
load('Wind_u.mat','Date','Data');
u10 = Data;

% v10 Wind component
load('Wind_v.mat','Date','Data');
v10 = Data;

ws = sqrt(u10.*u10 + v10.*v10); % wind_speed is the module of the two components u10 and v10

r2cFile(ws,Date,OutPath,'wind',xOrigin,yOrigin,xCount,yCount,xDelta,yDelta)

function Creating_r2c(OutPath,xOrigin,yOrigin,xCount,yCount,xDelta,yDelta,Reducc,DateSim)
%% Declarations

% Directories
addpath(genpath('OutputERA5-Land'));

%% ---------------------------------------------------- Loading data---------------------------------------------------------
%% Total precipitation in mm/s

load('Precipitation.mat','Date','Data');
tp = Data*(1000/3600); 
[Date, tp] = util_SelectPeriod(Date,DateSim,tp);

util_r2cFile(tp,Date,OutPath,'rain',xOrigin,yOrigin,xCount,yCount,xDelta,yDelta,Reducc)

%% Surface pressure in Pa
load('Pressure.mat','Date','Data');
sp = Data;
[Date, sp] = util_SelectPeriod(Date,DateSim,sp);

util_r2cFile(sp,Date,OutPath,'pres',xOrigin,yOrigin,xCount,yCount,xDelta,yDelta,Reducc)

%% Air surface temperature in K
load('Temperature.mat','Date','Data');
t2m = Data;
[Date, t2m] = util_SelectPeriod(Date,DateSim,t2m);

util_r2cFile(t2m,Date,OutPath,'temperature',xOrigin,yOrigin,xCount,yCount,xDelta,yDelta,Reducc)

%% Specific Humidity in Kg/Kg

% Dew point temperature in K
load('DewPoint.mat','Date','Data');
d2m = Data;
[Date, d2m] = util_SelectPeriod(Date,DateSim,d2m);


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

util_r2cFile(q,Date,OutPath,'humidity',xOrigin,yOrigin,xCount,yCount,xDelta,yDelta,Reducc)

%% Shortwave  in W/m2
load('Shortwave.mat','Date','Data');
ssrd = Data*(1/3600);
[Date, ssrd] = util_SelectPeriod(Date,DateSim,ssrd);

util_r2cFile(ssrd,Date,OutPath,'shortwave',xOrigin,yOrigin,xCount,yCount,xDelta,yDelta,Reducc)

%% Longwave  in W/m2
load('Longwave.mat','Date','Data');
strd = Data*(1/3600);
[Date, strd] = util_SelectPeriod(Date,DateSim,strd);

util_r2cFile(strd,Date,OutPath,'longwave',xOrigin,yOrigin,xCount,yCount,xDelta,yDelta,Reducc)

%% u10 Wind component
load('Wind_u.mat','Date','Data');
u10 = Data;
[~, u10] = util_SelectPeriod(Date,DateSim,u10);

% v10 Wind component
load('Wind_v.mat','Date','Data');
v10 = Data;
[Date, v10] = util_SelectPeriod(Date,DateSim,v10);

ws = sqrt(u10.*u10 + v10.*v10); % wind_speed is the module of the two components u10 and v10

util_r2cFile(ws,Date,OutPath,'wind',xOrigin,yOrigin,xCount,yCount,xDelta,yDelta,Reducc)

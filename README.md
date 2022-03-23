# ERA5LAND

This repository contains files with Matlab code used to format meteorological variables time series from the [ERA5-Land](https://cds.climate.copernicus.eu/cdsapp#!/dataset/reanalysis-era5-land?tab=overview) hourly data Reanalysis. The main function is to create a complete time series from several .nc files and convert them to local time. 

 ## Functions
 The following gives a brief description of the individual files:
 * **main**: This script is the only one to modify. In it, the **input** parameters of the ERA5LAND_EXTRACT function must be specified.

            * **dataPath**: Path where the *.nc files are located.
            * **OutPath**: Path of the results.
 * **VarName_nc**: String variable with the meteo parameter's name attribute in the .nc file (e.g., 'tp' -- total precipitation; 't2m' -- temperature, etc.).
 * **VarName**: String variable with the meteo parameter (e.g., Precipitation, Temperature, Pression, etc.).
 * **VarType**: 1 if the values of the variable in ERA5LAND are accumulated over time (e.g., precipitation, evaporation), 0 otherwise.
 * **LocalZone**: Time difference between UTC and the local time.
 * **ERA5LAND_EXTRACT**:
 * **getVariables**:
 * **descVar**:
 * **r2cFile**:

## Inputs






 | **VarName** | **VarName_nc** | **VarType** |**Unit**|
 | --------------| ------------ |-----------|--------|
 |   DewPoint    |     d2m      |      0    |    K   |
 |    Pression   |     sp       |      0    |        |
 |  Temperature  |     t2m      |      0    |        |
 | Precipitation |      tp      |      1    |        |
 |   ShortWave   |     ssrd     |           |        |
 |   LongWave    |     strd     |           |        |
 |    Wind_u     |     u10      |           |        |
 |     Wind_v    |     v10      |           |        |
 
 ## Output
 


## netCDF file specifications
* The .nc file name must follow the format: **YYYY-MM-DD_YYYY-MM-DD.nc**, indicating the start and end date of the data. 

      Example: 2019-01-01_2019-12-31.nc
      * Start date: 2019-01-01
      * End date: 2019-12-31
      
* The .nc file should only contain one variable.   

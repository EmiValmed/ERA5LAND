# ERA5LAND

## Inputs
 * **dataPath**: Path where the *.nc files are located.
 * **OutPath**: Path of the results.
 * **VarName_nc**: String variable with the meteo parameter's name attribute in the .nc file (e.g., 'tp' -- total precipitation; 't2m' -- temperature, etc.).
 * **VarName**: String variable with the meteo parameter (e.g., Precipitation, Temperature, Pression, etc.).
 * **VarType**: 1 if the values of the variable in ERA5LAND are accumulated over time (e.g., precipitation, evaporation), 0 otherwise.
 * **LocalZone**: Time difference between UTC and the local time.




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
 
 ## Functions
 * **ERA5LAND_EXTRACT**:
 * **getVariables**:
 * **descVar**:
 * **r2cFile**:

## netCDF file specifications
* The .nc file name must follow the format: **YYYY-MM-DD_YYYY-MM-DD.nc**, indicating the start and end date of the data. 

      Example: 2019-01-01_2019-12-31.nc
      * Start date: 2019-01-01
      * End date: 2019-12-31
      
* The .nc file should only contain one variable.   

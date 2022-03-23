# ERA5-Land 	:globe_with_meridians: :artificial_satellite:

This repository contains files with Matlab code used to format meteorological variables time series from the [ERA5-Land](https://cds.climate.copernicus.eu/cdsapp#!/dataset/reanalysis-era5-land?tab=overview) hourly data Reanalysis. The objective is to create a complete time series from several netCDF (.nc) files and convert them to local time. 

 ## Functions
 The following gives a brief description of the individual files:
 * **main.m**: This script is the only one to modify and execute. In it, the **Input** parameters (see below) of the ERA5LAND_EXTRACT.m must be specified. The variables to modify in this script are identified with the comment: **%To modify**
 * **ERA5LAND_EXTRACT.m**:  This is the main function. It reads, concatenates and converts the \*.nc files to local time.
 * **getVariables.m**: A small function used by the ERA5LAND_EXTRACT.m function to read the \*.nc files.
 * **descVar.m**: A small function to deaccumulate variables accumulated from the beginning of the forecast time to the end of the forecast step (e.g., Total precipitation, Evaporation). This is specified by the **VarType input**.

## Inputs
 * **dataPath**: Path where the \*.nc files are located.
 * **OutPath**: Path of the results.
 * **VarName_nc**: String variable with the meteo parameter's name attribute in the \*.nc file (see table below).
 * **VarName**: String variable with the meteo parameter (e.g., Precipitation, Temperature, Pression, etc.). The final result will have the name assigned to this variable
 * **VarType**: 1 if the values of the variable in ERA5-Land are accumulated over time (e.g., precipitation, evaporation), 0 otherwise.
 * **LocalZone**: Time difference between UTC and the local time (e.g., -05:00 for Quebec).

The code is made to be used with any variable from the ERA5-Land database. The table below shows some examples.

 | **VarName** | **VarName_nc** | **VarType** |**Unit**|
 | --------------| ------------ |-----------|---------|
 |   DewPoint    |     d2m      |      0    |    K    |
 |    Pressure   |     sp       |      0    |    Pa   |
 |  Temperature  |     t2m      |      0    |    K    |
 | Precipitation |      tp      |      1    |    m    |
 |   Shortwave   |     ssrd     |      1    |  J m-2  |
 |   LongWave    |     strd     |      1    |  J m-2  |
 |    Wind_u     |     u10      |      0    |  m s-1  |
 |     Wind_v    |     v10      |      0    |  m s-1  |
 
 ## Output
 
The output is a Matlab file (**VarName.mat**) with the following variables:
* **Data**: 3D matrix (longitude,latitude,time) with the values of the meteorological variable.
* **Date**: 2D datevec matrix (time,6) with the Date of the time series.
* **Longitude**: vector with longitude coordinates.
* **Latitude**: vector with latitude coordinates.

## netCDF file specifications
* The .nc file name are expected to follow the format: **YYYY-MM-DD_YYYY-MM-DD.nc**, indicating the start and end date of the data. 

      Example: 2019-01-01_2019-12-31.nc
      * Start date: 2019-01-01
      * End date: 2019-12-31
      
* The .nc file should only contain one variable.  
* 
## Creating .r2c files :computer: :floppy_disk:
 The **r2cFile** function allows to create .r2c files. The function depends heavily on the data structure of a particular project.
 ### Inputs
 * **Data**
 * **VarName**
 * **Unit**
 * **Latitude**
 * **Longitude**
 * **Date**

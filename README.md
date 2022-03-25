# MESH-ERA5Land 	:globe_with_meridians: :artificial_satellite:

This repository contains files with Matlab code used to create the meteorological inputs of the land-surface model [MESH](https://wiki.usask.ca/display/MESH/About+MESH)
using the [ERA5-Land](https://cds.climate.copernicus.eu/cdsapp#!/dataset/reanalysis-era5-land?tab=overview) hourly data Reanalysis. The objective is to create a complete time series from several netCDF (.nc) files, convert them to local time, and generate a \*.r2c file for each meteorological variable.

## Functions
 The following gives a brief description of the individual files:
 * **main.m**: In this script, we specify the **Input** parameters (see below) of the ERA5LAND_EXTRACT.m. 
 * **ERA5LAND_EXTRACT.m**: It reads, concatenates and converts to local time the \*.nc files.
 * **getVariables.m**: A small function used by ERA5LAND_EXTRACT.m to read the \*.nc files.
 * **descVar.m**: A small function to deaccumulate variables accumulated from the beginning of the forecast time to the end of the forecast step (e.g., Total precipitation, Evaporation). We specify this via the **VarType input**.
 * **r2cFile**: This function creates the \*.r2c files with the requirements of the MESH model. 

## Order of execution
Only two functions must be modified and executed in the following order:
1. **main.m**
2. **Creating_r2c.m**

       NOTE: The variables to modify in those scripts are identified with the comment: %To modify

##  main.m function
### Inputs:
 * **dataPath**: Path where the \*.nc files are located (netCDF_Files).
 * **OutPath**: Path of the results (Output folder)).
 * **VarName_nc**: String cell vector with the meteo parameters' name attribute in the \*.nc file (see table below).
 * **VarName**: String cell vector with the meteo parameters' name (e.g., Precipitation, Temperature, Pression, etc.). The final result will have the name assigned to this variable
 * **VarType**: 1 if the values of the variable in ERA5-Land are accumulated over time (e.g., precipitation, shortwave), 0 otherwise.
 * **LocalZone**: Time difference between UTC and the local time (e.g., -05:00 for Quebec).

The code is made to be used with any variable from the ERA5-Land database. However, in this case, only the variables necessary to determine the inputs of the MESH model are included (teable below).

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
 
 ### Outputs:
The output is a Matlab file (**VarName.mat**) with the following variables:
* **Data**: 3D matrix (longitude,latitude,time) with the values of the meteorological variable. Please note that output units are the same as ERA5-Land
* **Date**: Vector with the dates in datenum format.
* **Longitude**: vector with longitude coordinates.
* **Latitude**: vector with latitude coordinates.
* **LonGrid**: 2D matrix (longitude, latitude) with the longitud value in each grid.
* **LatGrid**: 2D matrix (longitude, latitude) with the latitude value in each grid.
 
 ## Creating_r2c.m function:
 ### Inputs:
 * **dataPath**: Path where the **VarName.mat** files are located. It is equivalent to the **OutPath** (Output folder) in the **main.m** function.
 * **OutPath**:  Path of the results (r2cFiles folder)
 * **xOrigin**:  This is the x-coordinate of the point in the bottom left corner of the grid.
 * **yOrigin**:  This is the y-coordinate of the point in the bottom left corner of the grid.
 * **xCount** :  The number of points, or vertices, in each row of the grid,along the x-direction.
 * **yCount** :  The number of points, or vertices, in each column of the grid,along the y-direction.
 * **xDelta** :  The distance betwwen two adjacent points in a row.
 * **yDelta** :  The distance betwwen two adjacent points in a column.

## netCDF file specifications
* The .nc file name are expected to follow the format: **YYYY-MM-DD_YYYY-MM-DD.nc**, indicating the start and end date of the data. 

      Example: 2019-01-01_2019-12-31.nc
      * Start date: 2019-01-01
      * End date: 2019-12-31
      
* The .nc file should only contain one variable.  

* This Repository must cotains the following folders:

    MESH-ERA5Land          : main folder
    
    .
    ├── netCDF_Files        #: Folder with the .nc data  (**dataPath** of the **main.m** function)             
    │   │
    │   ├── DewPoint        #: Folder with DewPoint .nc files
    │   ├── Longwave        #: Folder with Longwave .nc files
    │   ├── Precipitation   #: Folder with Precipitation .nc files
    │   ├── Pressure        #: Folder with Pressure .nc files
    │   ├── Shortwave       #: Folder with Shortwave .nc files
    │   ├── Temperature     #: Folder with Temperature .nc files
    │   ├── Wind_u          #: Folder with u wind component .nc files
    │   └── Wind_v          #: Folder with V wind component .nc files
    |
    ├── OutputERA5-Land     #: Folder with the .mat files (**OutPath** of the **main.m** function and **dataPath** of the **Creating_r2c.m function**) 
    └── r2cFiles            #: Folder with the .r2c files (**OutPath** of the **Creating_r2c.m function**)




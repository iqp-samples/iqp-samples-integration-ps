# <img src="https://github.com/iqp-samples/iqp-samples-ws/raw/master/logo.png" alt="iQuipsys Logo" width="100px" height="100px"> Powershell integration sample

This is a powershell integraion sample for [IQuipsys Positron](http://www.iquipsys.com).
This sample will create .csv file with report about object presence in site zones.

## Installation

- Install **tracker-ps** Powershell module and add it to **PSModulePath**

- Clone this repository to local disk
```bash
> git clone https://github.com/iqp-samples/iqp-samples-integration-ps.git
```

## Usage

- Set the login and password variables
```
$login = "your login"
$password = "your password"
```

- Set the report parameters

    - **$globalParams.siteName** - site name for report, make sure that user, which you specified in step above, have access to this site.
    - **$globalParams.startDate** - start date for report data. The date format is "yyyy-mm-dd".
    - **$globalParams.endDate** - end date for report data. Date format is the same as start date. If you want create report only for one day set end date the same as start date.
    - **$globalParams.startTime** - start time for report data. Ussualy this is shift start time. Time format is "hh:mm"
    - **$globalParams.endTime** - end time for report data. Ussualy this is shift end time. Time format is "hh:mm"
    - **$globalParams.exportFile** - path where result file will be created. Do not set the extension of file, beacuse to this file name will be added site name and report time.
```
$globalParams = @{
	siteName = "Demo Minesite1";
	startDate = "2017-10-21";
	endDate = "2017-10-21";
	startTime = "8:00";
	endTime = "17:00";
	exportFile = "C:\TimeInZones";
}
```

## Results

- While script executing you can see progress by console output current processed object
```
Calculating presence time for Tim Roth
Calculating presence time for Vincent Vega
Calculating presence time for Jules Winnfield
Calculating presence time for Butch Coolidge
Calculating presence time for Marsellus Wallace
Calculating presence time for Ed Sullivan
Calculating presence time for Susan Griffiths
Calculating presence time for James Dean
Calculating presence time for Jerry Lewis
Calculating presence time for Esmeralda Villalobos
Calculating presence time for Karen Maruyama
Calculating presence time for Dressta TD-25
...
```

- After script executed you can check created file by path you setted in **$globalParams.exportFile**. With globalParams specified above created file is 
```
C:\TimeInZones on site 'Demo Minesite1' from '21.10.2017 8-00' to '21.10.2017 17-00'.csv
```

- Result csv file structure

    - The first row of result csv file is headers
    ```
    "Control object";"Special Eqmt zone";"Excavator zone";"South Shovel zone";"Warehouse";"East dump zone";"West dump zone";"Workshop to Power plant road";"Power plant to Truck shop road";"Workshop";"Powerplant";"Truckshop";"Work zone 1";"Work zone 2";"Work zone  3";"Work zone 4";"West Speedway";"Severnaya Zona Ex";"Grader Sharp turn 01";"Presence out of zones";"Total online"
    ```

    - All other rows are data for each object
    ```
    "Tim Roth";"";"";"";"0,010";"0,857";"";"";"";"";"";"";"1,037";"1,171";"1,893";"2,072";"";"";"";"0,490";"7,530"
    ...
    ```
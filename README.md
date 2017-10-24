# <img src="https://github.com/iqp-samples/iqp-samples-ws/raw/master/logo.png" alt="iQuipsys Logo" width="100px" height="100px"> Powershell integration sample

This is a powershell integraion sample for [IQuipsys Positron](http://www.iquipsys.com).
This sample will display csv format report object presence in site zones in powershell console output. You can use this output to create .csv file.

## Installation

- Install **tracker-ps** Powershell module and add it to **PSModulePath**

- Clone this repository to local disk
```bash
> git clone https://github.com/iqp-samples/iqp-samples-integration-ps.git
```

## Usage

- Set the login and password variables in script file Export-PresenceInZones.ps1
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
```
$globalParams = @{
	siteName = "Demo Minesite1";
	startDate = "2017-10-21";
	endDate = "2017-10-21";
	startTime = "8:00";
	endTime = "17:00";
}
```

## Results

- After script executed you can view all data in console

```
"Control object";"Special Eqmt zone";"Excavator zone";"South Shovel zone";"Warehouse";"East dump zone";"West dump zone";"Workshop to Power plant road";"Power plant to Truck shop roa
d";"Workshop";"Powerplant";"Truckshop";"Work zone 1";"Work zone 2";"Work zone  3";"Work zone 4";"West Speedway";"Severnaya Zona Ex";"Grader Sharp turn 01";"Presence out of zones";"Total online"
"Tim Roth";"";"";"";"0,010";"0,857";"";"";"";"";"";"";"1,037";"1,171";"1,893";"2,072";"";"";"";"0,490";"7,530"
"Vincent Vega";"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";""
"Jules Winnfield";"0,005";"";"";"1,133";"";"";"0,160";"1,199";"1,594";"1,854";"2,593";"";"";"";"";"";"";"";"";"7,894"
"Butch Coolidge";"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";""
"Marsellus Wallace";"0,003";"";"";"0,815";"";"";"0,233";"0,756";"2,736";"2,241";"1,502";"";"";"";"";"";"";"";"";"7,894"
...
```
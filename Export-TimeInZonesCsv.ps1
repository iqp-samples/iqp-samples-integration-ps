<#

Don't forget to set the $login and $password variable

#>

Import-Module tracker-ps

$serverHost = "54.158.76.30"
$login = "login"
$password = "password"

$conn = Connect-IqtFacade -Host $serverHost -Port 8080 -Login $login -Password $password

$reportStartTime = Get-Date

$globalParams = @{
	siteName = "Demo Minesite1";
	startDate = "2017-10-21";
	endDate = "2017-10-21";
	startTime = "8:00";
	endTime = "17:00";
	exportFile = "C:\TimeInZones";
}

if ($conn.Session.user.sites.name -notcontains $globalParams.siteName) {
	throw "Site '$($globalParams.siteName)' doesn't exist or user doesn't have access to the site"
}

$site = Get-IqtSite -id ($conn.Session.user.sites | where-object name -eq $globalParams.siteName).id

$globalParams.startDate = Get-Date -Date $globalParams.startDate
$globalParams.endDate = Get-Date -Date $globalParams.endDate

[object[]]$controlObjects = Get-IqtControlObjects -SiteId $site.id
[object[]]$zones = Get-IqtZones -SiteId $site.id

$resultObjects = @()

for ($i = 0; $i -lt $controlObjects.Count; $i++) {
	Write-Host "Calculating presence time for $($controlObjects[$i].name)"

	$resultObj = New-Object System.Object
	$resultObj | Add-Member -MemberType NoteProperty -Name "Control object" -Value $($controlObjects[$i].name)

	$presenceHoursInAllZones = 0

	for ($j = 0; $j -lt $zones.Count; $j++) {
		
		$queryStartDate = $globalParams.startDate
		
		$presenceDataValue = 0

		while ((Get-Date -Date $queryStartDate) -le (Get-Date -Date $globalParams.endDate)) {
			$queryStartDate = $queryStartDate.AddHours($globalParams.startTime.Split(":")[0])
			$queryStartDate = $queryStartDate.AddMinutes($globalParams.startTime.Split(":")[1])

			$queryEndDate = Get-Date -Date $queryStartDate -Hour 0 -Minute 0
			$queryEndDate = $queryEndDate.AddHours($globalParams.endTime.Split(":")[0] - 1) #exclude end hour
			$queryEndDate = $queryEndDate.Addminutes($globalParams.endTime.Split(":")[1])

			if ((Get-Date -Date $queryEndDate) -lt (Get-Date -Date $queryStartDate)) { #if shift ends on next day
				$queryEndDate= $queryEndDate.AddDays(1)
			}
			$presenceData = Read-IqtStatCounter -Group $site.id -Counter "presence.$($controlObjects[$i].id).$($zones[$j].id)" -Type 4 -From $queryStartDate -To $queryEndDate

			for ($k = 0; $k -lt $presenceData.values.Count; $k++) {
				$presenceDataValue += $presenceData.values[$k].value
			}

			$queryStartDate = $queryStartDate.AddDays(1)
			$queryStartDate = Get-Date -Date $queryStartDate -Hour 0 -Minute 0
		}

		$hoursInZone = [math]::Round($presenceDataValue / 3600, 3)
		if ($hoursInZone -gt 0) {
			$resultObj | Add-Member -MemberType NoteProperty -Name "$($zones[$j].name)" -Value $($hoursInZone)
			$presenceHoursInAllZones += $hoursInZone
		} else {
			$resultObj | Add-Member -MemberType NoteProperty -Name "$($zones[$j].name)" -Value $("")
		}
	}

	#get online
	$queryStartDate = $globalParams.startDate
	
	$totalOnline = 0

	while ((Get-Date -Date $queryStartDate) -le (Get-Date -Date $globalParams.endDate)) {
		$queryStartDate = $queryStartDate.AddHours($globalParams.startTime.Split(":")[0])
		$queryStartDate = $queryStartDate.AddMinutes($globalParams.startTime.Split(":")[1])

		$queryEndDate = Get-Date -Date $queryStartDate -Hour 0 -Minute 0
		$queryEndDate = $queryEndDate.AddHours($globalParams.endTime.Split(":")[0] - 1) #exclude end hour
		$queryEndDate = $queryEndDate.Addminutes($globalParams.endTime.Split(":")[1])

		if ((Get-Date -Date $queryEndDate) -lt (Get-Date -Date $queryStartDate)) { #if shift ends on next day
			$queryEndDate= $queryEndDate.AddDays(1)
		}

		$onlineData = Read-IqtStatCounter -Group $site.id -Counter "params.$($controlObjects[$i].id).online" -Type 4 -From $queryStartDate -To $queryEndDate

		for ($k = 0; $k -lt $onlineData.values.Count; $k++) {
			$totalOnline += $onlineData.values[$k].value
		}

		$queryStartDate = $queryStartDate.AddDays(1)
		$queryStartDate = Get-Date -Date $queryStartDate -Hour 0 -Minute 0
	}

	$totalOnlineHours = [math]::Round($totalOnline / 3600, 3)
	$presenceHoursOutOfZones = $totalOnlineHours - $presenceHoursInAllZones
	if ($presenceHoursOutOfZones -gt 0) {
		$resultObj | Add-Member -MemberType NoteProperty -Name "Presence out of zones" -Value $($presenceHoursOutOfZones)
	} else {
			$resultObj | Add-Member -MemberType NoteProperty -Name "Presence out of zones" -Value $("")
	}
	if ($totalOnlineHours -gt 0) {
		$resultObj | Add-Member -MemberType NoteProperty -Name "Total online" -Value $($totalOnlineHours)
	} else {
			$resultObj | Add-Member -MemberType NoteProperty -Name "Total online" -Value $("")
	}
	$currentRow++
	$resultObjects += $resultObj
}

$globalParams.exportFile += " on site '$($site.name)' from '$($globalParams.startDate.ToShortDateString()) $($globalParams.startTime.Replace(":","-"))' to '$($globalParams.endDate.ToShortDateString()) $($globalParams.endTime.Replace(":","-"))'.csv"

$resultObjects | Export-Csv $globalParams.exportFile -Delimiter ";" -NoTypeInformation -Encoding UTF8

write-host "Report created in $(((Get-Date) - $reportStartTime).TotalSeconds) seconds"

Disconnect-IqtFacade
# Author : Bahadir YILMAZ
# Date : 30/04/2020
# Current Virtual machine status ( in the 5 minute )

# Run Powershell as Administrator !!!


# install-module AzureRm
# Login-AzureRmAccount

cls 

# Login-AzAccount


$vm = get-azurermvm -ResourceGroupName "FINAL" -Name "VM-01"  # Please change it!
$vm2 = get-azurermvm -ResourceGroupName "FINAL" -Name "VM-02" # Please change it!

$resourceID = $vm.Id
$resourceID2 = $vm2.Id

$endTime = Get-Date
$startTime = $endTime.AddMinutes(-5) # for last 5 min. you can change it!
$timeGrain = '00:01:00'
$metricName = 'Percentage CPU,Network In Total,Disk Read Bytes'
$metricData = Get-AzureRmMetric -ResourceId $resourceID -TimeGrain $timeGrain -StartTime $startTime -EndTime $endTime -MetricNames $metricName -OutVariable average
write-output "VM-1 Metrics // CPU - Network - Disk"
$metricData.Data

write-output "VM-2 Metrics // CPU - Network - Disk"
$metricName2 = 'Percentage CPU,Network In Total,Disk Read Bytes'
$metricData = Get-AzureRmMetric -ResourceId $resourceID2 -TimeGrain $timeGrain -StartTime $startTime -EndTime $endTime -MetricNames $metricName2
$metricData.Data

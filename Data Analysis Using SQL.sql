Select *
From dbo.cleaned_environment;

-- Task#1: Find the average temperature recorded for each device.

Select device_id, AVG(temperature) As Average_Temperature
From dbo.cleaned_environment
Group By device_id
Order By Average_Temperature Desc;


-- Task#2: Retrieve the devices with the highest average carbon monoxide levels.
Select device_id, AVG(carbon_monoxide) As Average_carbon_monoxide
From dbo.cleaned_environment
Group By device_id
Order By Average_carbon_monoxide Desc;

-- Task#3: Calculate the average temperature recorded in the cleaned_environment table
Select AVG(temperature) as Average_tempearture
From dbo.cleaned_environment;

-- Task#4: Find the timestamp and temperature of the highest recorded temperature for each device.
Select device_id, 
	timestamp,
	MAX(temperature) as Max_Temp
From dbo.cleaned_environment
Group By device_id, timestamp;

-- Task#5: Identify devices where the temperature has increased from the minimum recorded temperature to the maximum recorded temperature
Select device_id
From dbo.cleaned_environment
Group By device_id
Having MAX(temperature) > MIN(temperature);

-- Task#6: Calculate the exponential moving average of temperature for each device
SELECT device_id, timestamp, temperature,
       AVG(temperature) OVER (PARTITION BY device_id ORDER BY timestamp ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS ema_temperature
FROM dbo.cleaned_environment

-- Task#7: Find the timestamps and devices where carbon monoxide level exceeds the average carbon monoxide level of all devices
Select timestamp, device_id, carbon_monoxide
From dbo.cleaned_environment
Where carbon_monoxide > (Select AVG(carbon_monoxide) From dbo.cleaned_environment)

-- Task#8: Retrieve the devices with the highest average temperature recorded.
Select Top 1 device_id,AVG(temperature) as avg_temp
From dbo.cleaned_environment
Group By device_id
Order By avg_temp Desc;

-- Task#9: Calculate the average temperature for each hour of the day across all devices.
Select DATEPART(HOUR,timestamp) As Hr_of_day,
	AVG(temperature) as Avg_temp
From dbo.cleaned_environment
Group BY DATEPART(HOUR,timestamp)
Order By Hr_of_day;

-- Task#10: Which device(s) in the cleaned environment dataset have recorded only a single distinct temperature value
SELECT device_id
FROM dbo.cleaned_environment
GROUP BY device_id
HAVING COUNT(DISTINCT temperature) = 1;

-- Task#11: Find the device with the highest humidity levels.
Select Top 1 device_id, MAX(humidity) as max_humidity
From dbo.cleaned_environment
Group By device_id
Order By max_humidity Desc;

-- Task#12: Calculate the average temperature for each device, excluding outliers (temperatures beyond 3 standard deviations).
With outliers AS(
	Select device_id,temperature,
	AVG(temperature) OVER(Partition By device_id) AS average_temp,
	STDEV(temperature) OVER(Partition BY device_id) AS std_temp
	From dbo.cleaned_environment
)
Select device_id, AVG(temperature) as avg_temp
FROM outliers
WHERE temperature Between (average_temp - 3 * std_temp) AND (average_temp + 3 * std_temp)
Group BY device_id;

-- TAsk#13: Calculate the cumulative sum of temperature for each device
Select device_id, 
	timestamp,
	temperature,
	SUM(temperature) Over(Partition BY device_id Order By timestamp) as cumulative_sum
From dbo.cleaned_environment;



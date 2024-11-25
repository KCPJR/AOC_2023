Function D5{
    [CmdletBinding(DefaultParameterSetName = 'A')]
    Param(
        [Parameter(ParameterSetName = "A")]
        [Switch] $A,

        # Parameter help description
        [Parameter(ParameterSetName = "B")]
        [Switch]
        $B
    )
    Begin{

        switch ($PsCmdlet.ParameterSetName) {
            A {
                Write-host "ParameterSet A"
                $data = Get-Content .\Day_05\Input_test.txt
            }
            B {
                Write-host "ParameterSet B"
                $data = Get-Content .\Day_05\Input.txt
            }
            Default {}
        }

        #parse data
        $rowindex = 0
        $seeds = $data[$rowindex].Substring(7).split(" ")
        $rowindex++
        $rowindex++
        $rowindex++
        $mapindex = 1
        $maps = @()
        while($rowindex -lt $data.count){
            while( ($data[$rowindex] -ne "") -and ($rowindex -lt $data.count) ){
                #write-host("{0}" -f $data[$rowindex])
                $mapdata = $data[$rowindex].split(" ")
                $maps += [PSCustomObject]@{
                        Level = $mapindex
                        Source = [long]$mapdata[1]
                        Destination = [long]$mapdata[0]
                        Range = [long]$mapdata[2]
                    }
                $rowindex++
                }
            $rowindex++
            $rowindex++
            $mapindex++
        }
        #$maps
    
        #follow the map
        $MappingDescription = @("Seed","Soil","Fertilizer","Water","Light","Temperature","Humidity","Location")
        $seedhistory = @()
        $seedindex = -1
        foreach($sval in $seeds){
        $seedindex++
        [long]$s = $sval
        $seedhistory += [PSCustomObject]@{
            SeedIndex = $seedindex
            Seed = $s
            Soil = $s
            Fertilizer = $s
            Water = $s
            Light = $s
            Temperature = $s
            Humidity = $s
            Location = $s
        }
        #$activemapLevel = 0
        foreach($activemaplevel in (1..7)){
            $finish = $s
            foreach($mapping in $maps|?{$_.Level -eq $activemapLevel}){
            if(($s -ge $mapping.Source) -and ($s -le ($mapping.source + $mapping.Range -1)) ){
                #write-host ("In mapping range")
                $finish = $s - $mapping.source + $mapping.Destination
                #Write-host ("Remapped to {0}" -f $finish)
                $seedhistory[$seedindex].($mappingdescription[$activemapLevel]) = $finish
                $s = $finish
                Break
            }
            else {
               #write-host ("Not in scope of range")
            }
        }
        #$activemapLevel++
        $seedhistory[$seedindex].($mappingdescription[$activemapLevel]) = $finish
        $s = $finish
        }
    }
    $seedhistory
    [long]$min = [long]$seedhistory[0].Location
    foreach($h in $seedhistory){
        if([long]$h.Location -lt [long]$min){[long]$min = [long]$h.Location}
    }
    Write-Host ("Answer Part 1: {0}" -f $min)
}#begin 
}
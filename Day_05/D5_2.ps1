Function D5B{
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
        $seeds = @()
        $seeds_temp = $data[$rowindex].Substring(7).split(" ")
        For($i = 0;$i -lt $seeds_temp.count;$i++){
            $seeds += [PSCustomObject]@{
                start = [Int64]$seeds_temp[$i]
                range = [int64]$seeds_temp[$i + 1]
                end = [int64]$seeds_temp[$i] + [int64]$seeds_temp[$i + 1] -1
                remaplevel = 0
            }
            $i++
        }

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
                        Start = [long]$mapdata[1]
                        End = [long]$mapdata[1] + [long]$mapdata[2] -1
                        Destination = [long]$mapdata[0]
                        Range = [long]$mapdata[2]
                        Offset = [long]$mapdata[0] - [long]$mapdata[1]
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
        
        #foreach($s in $seeds){
        #seedindex
        for($activemapLevel = 1;$activemapLevel -le 7;$activemapLevel++){
        for($si = 0;$si -lt $seeds.count; $si++){
        $s = $seeds[$si]
        #$activemapLevel = 1
        
        Write-host ("`nSeed Range: Start: {0} Finish: {1} Range: {2}" -f $s.start, $s.end, $s.range)
        foreach($map in $maps|?{$_.Level -eq $activemapLevel}|sort Start)
            {
                Write-host ("Start: {0} Finish: {1} Range: {2} Offset:{3}" -f $map.Start, $map.End, $map.Range,$map.Offset)
                If(($s.start -le $map.End) -and ($s.end -ge $map.Start)){
                    write-host("  We've got a match")
                    if($s.start -lt $map.Start){
                        if($s.end -le $map.End){
                            Write-Host("   Case 1")
                            write-host("Old Seed: S{0} E{1} R{2}" -f $s.start, $s.end, $s.range)
                            
                            #New Seed range
                            $seeds += [PSCustomObject]@{
                                start = $s.start 
                                range = $map.start -1 - $s.start + 1
                                end = $map.Start -1
                                remaplevel = 0
                            }
                            Write-host("New Seed: S{0} E{1} R{2}" -f ($s.start),($map.Start -1),($map.start -1 - $s.start + 1) )
                            #Modify existing seed
                            $seeds[$si].start = $map.start + $map.offset
                            $seeds[$si].end = $s.end + $map.Offset
                            $seeds[$si].range = ($s.end + $map.Offset) - ($map.start + $map.offset) +1
                            $seeds[$si].remaplevel = $activemapLevel +1 
                            Write-host("Mod Seed: S{0} E{1} R{2}" -f $map.start,$s.end,(($s.end + $map.Offset) - ($map.start + $map.offset) +1))
                            break
                        }
                        Else{
                            Write-Host("   Case 2")
                            write-host("Old Seed: S{0} E{1} R{2}" -f $s.start, $s.end, $s.range)
                            $tempstart = $s.start 
                            $tempend = $s.end
                            #New Seed range at for beginning
                            $seeds += [PSCustomObject]@{
                                start = $s.start 
                                range = $map.start -1 - $s.start + 1
                                end = $map.Start -1
                                remaplevel = 0
                            }
                            Write-host("New Seed: S{0} E{1} R{2}" -f ($s.start),($map.Start -1),($map.start -1 - $s.start + 1) )
                            #Modify existing seed
                            $seeds[$si].start = $map.start + $map.offset
                            $seeds[$si].end = $map.end + $map.Offset
                            $seeds[$si].range = $map.Range
                            $seeds[$si].remaplevel = $activemapLevel +1 
                            Write-host("Mod Seed: S{0} E{1} R{2}" -f $map.start,$map.end,$map.Range)
                            Write-host("        : S{0} E{1} R{2}" -f ($map.start + $map.offset),($map.end + $map.Offset),$map.Range)
                            #New Seed range for end
                            $seeds += [PSCustomObject]@{
                                start = $map.End +1 
                                range = $temp - ($map.End +1) +1
                                end = $tempend
                                remaplevel = 0
                            }
                            Write-host("New Seed: S{0} E{1} R{2}" -f ($map.End +1),($tempend),($temp - ($map.End +1) +1) )
                            break    
                        }

                        
                    }
                    Else{
                        if($s.end -le $map.End){
                            Write-host("   Case 3 - No Change in Ranges")
                            write-host("Old Seed: S{0} E{1} R{2}" -f $s.start, $s.end, $s.range)
                            $temp = $s.end
                            $seeds[$si].start = $s.start + $map.Offset
                            $seeds[$si].end = $s.end + $map.Offset 
                            $seeds[$si].range = $seeds[$si].end - $seeds[$si].start + 1
                            $seeds[$si].remaplevel = $activemapLevel + 1
                            write-host("        : S{0} E{1} R{2}" -f ($s.start), ($s.end), $s.range)
                            break
                        }
                        Else
                        {
                            Write-Host("   Case 4")
                            write-host("Old Seed: S{0} E{1} R{2}" -f $s.start, $s.end, $s.range)
                            
                            $temp = $s.end
                            $seeds[$si].start = $s.start + $map.Offset
                            $seeds[$si].end = $map.End + $map.Offset 
                            $seeds[$si].range = $seeds[$si].end - $seeds[$si].start + 1
                            $seeds[$si].remaplevel = $activemapLevel + 1
                            Write-host("Mod Seed: S{0} E{1} R{2}" -f $map.start,$map.end,$map.Range)
                            Write-host("        : S{0} E{1} R{2}" -f ($map.start + $map.offset),($map.end + $map.Offset),$map.Range)
                            #new seed
                            $seeds += [PSCustomObject]@{
                                start = $map.End +1 
                                range = $temp - ($map.End +1) +1
                                end = $temp
                                remaplevel = 0
                            }
                            Write-host("New Seed: S{0} E{1} R{2}" -f ($map.End +1),($temp),($temp - ($map.End +1) +1 ))d
                            break
                        }
                    }
                }
            }#map loop
        }#seed loop
    }#Level Loop
        #$seeds
        $part2 = @($seeds|select -ExpandProperty start |sort )[0]
        write-host("Answer Part 2: {0}" -f $part2)
}#begin 
}
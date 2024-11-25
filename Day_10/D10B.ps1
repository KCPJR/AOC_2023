Function D10B{
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
                $data = Get-Content .\Day_10\Input_test4.txt
            }
            B {
                Write-host "ParameterSet B"
                $data = Get-Content .\Day_10\Input.txt
            }
            Default {}
        }
        
        $yct = $data.count
        $xct = $data[0].tochararray().length
        $gsize = $yct * $xct
        $g = @{}
        $ghash = @{}
        #$g = [object[]]::new($gsize)
        <# $templateobj = [PSCustomObject]@{
            coord = "0,0"
            Y = 0
            X = 0
            OVal = ""
            EVal = ""
            FVal = ""
            isAP = $false
            pindex = $null

        } #>

        #(0..($gsize -1))|%{
        #    $coord = ("{0},{1}" -f $y,$x)
        #
        #    $g[$_] = $templateobj|Select-Object}

        for($y = 0;$y -lt $yct;$y++){
            for($x = 0;$x -lt $xct;$x++){
                $gindex = ($y*$xct) + $x
                $coord = ("{0},{1}" -f $y,$x)
                $g[$coord] = [PSCustomObject]@{
                    index = $gindex
                    coord = $coord
                    Y = $y
                    X = $x
                    OVal = $data[$y][$x]
                    EVal = ""
                    FVal = ""
                    isAP = $false
                    pindex = $null
                }
                $ghash[$gindex] = $coord
                
            }
        }
        
        


        $hashpipe = @{}
        $hashpipeindex = @{}
        $ap = @() #activepipes (part of the pipe loop)
        $movecounter = 0

        #get start
        $y = 0 
        while($data[$y].indexof("S") -eq -1){$y++}
        $x = $data[$y].indexof("S")
        Write-host("Origin Y: {0} X:{1} " -f $y, $x)
        $OrigY = $y;$OrigX = $x 
        $tempcoord = "{0},{1}" -f $y,$x
        <# $ap += [PSCustomObject]@{
            y = $y
            x = $x
            val = $data[$y][$x]
            coord = $tempcoord
        } #>
        #$hashpipe.($tempcoord) = $hashpipe.Keys.Count

        $validN = @("|","7","F")
        $validS = @("|","J","L")
        $validE = @("-","J","7")
        $validW = @("-","F","L")

        #Start = $data[$y][$x]

        $dir = @()
            #South
            if($data[$y +1][$x] -in $validS){$dir += "S"}
            #West
            if($data[$y][$x -1 ] -in $validW){$dir += "W"}
            #North
            if($data[$y -1][$x] -in $validN){$dir += "N"}
            #East
            if($data[$y][$x + 1] -in $validE){$dir += "E"}
            
        $py = $OrigY
        $px = $OrigX
        #$val = $data[$y][$x]
        #$movecounter = 1

        #determine real val of starting location
        $dirstr = ($dir |sort) -join "" 
        switch ($dirstr) {
            "NS" {$val = "|" }
            "EW" {$val = "-" }
            "ES" {$val = "F" }
            "SW" {$val = "7" }
            "NW" {$val = "J" }
            "EN" {$val = "L" }
        }
        $SEval = $val
        $startcoord = ("{0},{1}" -f $OrigY,$OrigX)
        $g[$startcoord].eval = $dir[0]
        #pick one of the possible moves as the previous location
        switch ($dir[0]) {
            "S" {$py = $y + 1  }
            "N" {$py = $y - 1  }
            "W" {$px = $x - 1  }
            "E" {$px = $x + 1  }
        }

        #at this point have px and py and val 
        Do {
        #determine and advance based on current val and py,px
        $tempx = $x; $tempy = $y
        switch ($val) {
            "F" {
                if($px -eq $x){
                    $dird = "East"
                    $x++                 
                }
                Else{
                    $dird = "South"
                    $y++
                }
              }
            "|" {
                if($py -lt $y){
                    $dird = "South"
                    $y++
                }
                Else{
                    $dird = "North"
                    $y--
                }
            }
            "-" {
                if($px -lt $x){
                    $dird = "East"
                    $x++
                }
                Else{
                    $dird = "West"
                    $x--
                }
            }
            "L" {
                if($py -eq $y){
                    $dird = "North"
                    $y--
                }
                else {
                    $dird = "East"
                    $x++
                }
            }
            "J" {
                if($py -eq $y){
                    $dird = "North"
                    $y--
                }
                else{
                    $dird = "West"
                    $x--
                    
                }
            }
            "7" {
                if($py -eq $y){
                    $dird = "South"
                    $y++
                }
                else{
                    $dird = "West"
                    $x--
                }
            } 
        }
        Write-Host ("({0},{1}) : {2} Previous location ({3},{4}) Moving {5} to ({6},{7})" -f $tempy,$tempx,$val,$py,$px,$dird,$y,$x)
        #update py, px
        $px = $tempx; $py = $tempy
        #update movecounter 
        $movecounter++
        $val = $data[$y][$x]
        $coord = ("{0},{1}" -f $y,$x)
        $g[$coord].pindex = $movecounter
        $g[$coord].isAP = $true

        <# $ap += [PSCustomObject]@{
            y = $y
            x = $x
            val = $val
            coord = ("{0},{1}" -f $y,$x)
            movecounter = $movecounter
        } #>
        $tempcoord = "{0},{1}" -f $y,$x
        $hashpipe.($tempcoord) = $hashpipe.Keys.Count
        $hashpipeindex.($hashpipe.Keys.Count -1) = $tempcoord
        
    } While (($x -ne $OrigX) -or ($y -ne $OrigY))

    Write-host ("Moves Made: {0}" -f $movecounter)

    Write-host ("That's all folks!")    
    write-host ("Answer Part 1: {0}" -f ($movecounter /2))
   # Write-host ("Pipe count: {0}" -f $ap.count)

    #Set-Content .\Day_10\OutputMap.txt -Value $null
    for($y=0;$y -lt $yct;$y++){
        for($x = 0; $x -lt $xct;$x++){
            $tempcoord = "{0},{1}" -f $y,$x
            if($g[$tempcoord].isAP){$g[$tempcoord].EVal = $g[$tempcoord].OVal}
            else{$g[$tempcoord].EVal = "."}}
        
    }
    #reset the eval for S
    $g[$startcoord].eval = $SEval
    
    Set-Content .\Day_10\OutputMap.txt -Value $null
    for($y=0;$y -lt $yct;$y++){
        [string]$r = @()
        for($x = 0; $x -lt $xct;$x++){
            $tempcoord = "{0},{1}" -f $y,$x
            $r += $g[$tempcoord].EVal
        }
        Add-Content -Value $r -Path .\day_10\OutputMap.txt
    }
    write-host ("Stop here for now!")
    
    #get the first pipe in the highest row
    $i = 0
    while($g[$ghash[$i]].OVal -eq "."){$i++}
    write-host ("First pipe is at {0} : {1}" -f $i,$ghash[$i])
    $tempstart = $g[$ghash[$i]]

    $temppipearray = $g.Values|?{$null -ne $_.pindex}|sort pindex
    $tempindex = $tempstart.pindex
    $pa = $temppipearray[($tempindex -1)..($temppipearray.count)] + $temppipearray[0.. ($tempindex)]

    for($y = 0;$y -lt $yct;$y++){
        $io = $false #inside/outside
        for($x = 0;$x -lt $xct;$x++){
            $coord = ("{0},{1}" -f $y,$x)
            $CV = $g[$coord].eval
            switch ($CV) {
                "." { if($io) {$g[$coord].FVal = "I" }Else{$g[$coord].FVal = "O"}}
                "F" { $g[$coord].FVal = $CV}
                "L" { $io = !$io ;$g[$coord].FVal = $CV}
                "7" { $g[$coord].FVal = $CV}
                "J" { $io = !$io ;$g[$coord].FVal = $CV}
                "|" { $io = !$io ;$g[$coord].FVal = $CV}
                "-" {$g[$coord].FVal = $CV}
                Default {}
                }
            
        }
    }

    Set-Content .\Day_10\OutputMap.txt -Value $null
    for($y=0;$y -lt $yct;$y++){
        [string]$r = @()
        for($x = 0; $x -lt $xct;$x++){
            $tempcoord = "{0},{1}" -f $y,$x
            $r += $g[$tempcoord].fVal
        }
        Add-Content -Value $r -Path .\day_10\OutputMap.txt
    }
    
    $insides = ($g.Values.fVal|?{$_ -eq "I"}).count
    write-host ("Answer Part 2: {0}" -f $insides)
    <# $paind = 0
    $prev = @($true,$true,$true,$true,$true,$true,$true,$true)
    foreach($p in $pa){
        switch ($p.OVal) {
            "F" {$cur = ($true,$true,$true,$null,$false,$null,$true,$true)  }
            Default {}
        }
    } #>

    #$pa
    #$ap
    #$hashpipe
    }
}
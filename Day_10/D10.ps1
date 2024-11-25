Function D10{
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
                $data = Get-Content .\Day_10\Input_test3.txt
            }
            B {
                Write-host "ParameterSet B"
                $data = Get-Content .\Day_10\Input.txt
            }
            Default {}
        }
        $map0 = $data
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
        $ap += [PSCustomObject]@{
            y = $y
            x = $x
            val = $val
            coord = ("{0},{1}" -f $y,$x)
            movecounter = $movecounter
        }
        $tempcoord = "{0},{1}" -f $y,$x
        $hashpipe.($tempcoord) = $hashpipe.Keys.Count
        $hashpipeindex.($hashpipe.Keys.Count -1) = $tempcoord
        
    } While (($x -ne $OrigX) -or ($y -ne $OrigY))

    Write-host ("Moves Made: {0}" -f $movecounter)

    Write-host ("That's all folks!")    
    write-host ("Answer Part 1: {0}" -f ($movecounter /2))
    Write-host ("Pipe count: {0}" -f $ap.count)

    Set-Content .\Day_10\OutputMap.txt -Value $null
    for($y=0;$y -lt $data.Count;$y++){
        [string]$r = @()
        for($x = 0; $x -lt $data[0].length;$x++){
            $tempcoord = "{0},{1}" -f $y,$x
            if($hashpipe.ContainsKey($tempcoord)){
                $r+= $data[$y][$x]
            }else{$r += "."}
        }
        Add-Content -Value $r -Path .\day_10\OutputMap.txt     
    }
    $dm = Get-Content .\Day_10\OutputMap.txt
    
    $y = 0;$x = 0
    $val = 0
    $dm[$y][$x] = $val
    Set-Content .\Day_10\OutputMap.txt -value $dm

    #$ap
    #$hashpipe
    }
}
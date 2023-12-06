Function D3{
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
                $data = Get-Content .\Day_03\Input_test.txt
            }
            B {
                Write-host "ParameterSet B"
                $data = Get-Content .\Day_03\Input.txt
            }
            Default {}
        }
        $pnarray = @()
        $ll = $data[0].Length  -1 #line length
         
        for($y = 0;$y -lt $data.count;$y++){
            $x = 0
            while ($x -le $ll){
                $c = $data[$y][$x]
                if(($c -ge "0" ) -and ($c -le "9")){
                    
                    #write-host ("{0} found number at [{1}][{2}]" -f $c,$y,$x)
                    #get lenght of number
                    $numlength = 1
                    $startx = $x
                    while (($x -lt $ll) -and ($data[$y][$x +1] -ge "0" -and $data[$y][$x +1] -le "9")) {
                        $numlength++;
                        $x++
                    }
                    #write-host ("Number length: {0}" -f $numlength)
                    $pnarray += [PSCustomObject]@{
                        Value = $data[$y].substring($startx,$numlength)
                        Xstart = $startx
                        Ystart = $y
                        Length = $numlength
                        Valid = $false
                        StarAdjacent = $false
                    }
                }
                else{
                    #write-host ("{0}" -f $c)
                }
                $x++

            }
        }#y loop

        #$pnarray
        $nonsym = @(".","0","1","2","3","4","5","6","7","8","9")
        $stars = @()
        foreach($pn in $pnarray){
            $pnFlag = $false
            #top
            write-host ("PN: {0} [{1}][{2}]" -f $pn.Value, $pn.Ystart, $pn.Xstart)
            if($pn.Ystart -1 -ge 0){
                #write-host " Can check top"
                $xbordervals = ($pn.Xstart -1)..($pn.Xstart + $pn.Length)
                foreach($x in $xbordervals){
                    if($x -ge 0 -and $x -le $ll){
                        $tx = $x; $ty = $pn.Ystart -1; $tv = $data[$ty][$tx]
                        if($tv -notin $nonsym)
                        {
                            $pnFlag = $true
                            $pn.Valid = $true
                            if($tv -eq "*"){
                                $pn.StarAdjacent = $true
                                $stars += [PSCustomObject]@{
                                    coord = ("{0},{1}" -f $ty,$tx)
                                    PNValue = [int]$pn.Value
                                }
                            }
                        }
                        else
                        {
                            $pnFlag = $false
                        }
                        #write-host("   [{0}][{1}] Value: {2} -- {3}" -f ($ty),$tx,$tv,$pnFlag)
                    }
                }
            }
            #left
            if($pn.Xstart -1 -ge 0){
                #write-host (" Can check left")
                $tx = $pn.Xstart -1; $ty = $pn.Ystart; $tv = $data[$ty][$tx]
                if($tv -notin $nonsym){
                    $pnFlag = $true
                    $pn.Valid = $true
                    if($tv -eq "*"){
                        $pn.StarAdjacent = $true
                        $stars += [PSCustomObject]@{
                            coord = ("{0},{1}" -f $ty,$tx)
                            PNValue = [int]$pn.Value
                        }
                    }
                }
                else{
                    $pnFlag = $false
                }

                #write-host("   [{0}][{1}] Value: {2} -- {3}" -f ($ty),$tx,$tv,$pnFlag)
            }
            #right
            if($pn.Xstart + $pn.Length -le $ll){
                $tx = $pn.Xstart +$pn.Length; $ty = $pn.Ystart; $tv = $data[$ty][$tx]
                #write-host (" Can check right")
                if($tv -notin $nonsym){
                    $pnFlag = $true
                    $pn.Valid = $true
                    if($tv -eq "*"){
                        $pn.StarAdjacent = $true
                        $stars += [PSCustomObject]@{
                            coord = ("{0},{1}" -f $ty,$tx)
                            PNValue = [int]$pn.Value
                        }
                    }
                }
                else
                {
                    $pnFlag = $false
                }
                
                #write-host("   [{0}][{1}] Value: {2} -- {3}" -f ($ty),$tx,$tv,$pnFlag)
            }
            #bottom
            if($pn.Ystart +1 -lt $data.Count){
                #write-host " Can check bottom"
                $xbordervals = ($pn.Xstart -1)..($pn.Xstart + $pn.Length)
                foreach($x in $xbordervals){
                    if(($x -ge 0) -and ($x -le $ll)){
                        $tx = $x; $ty = $pn.Ystart +1 ; $tv = $data[$ty][$tx]
                        if($tv -notin $nonsym){
                            $pnFlag = $true
                            $pn.Valid = $true
                            if($tv -eq "*"){
                                $pn.StarAdjacent = $true
                                $stars += [PSCustomObject]@{
                                    coord = ("{0},{1}" -f $ty,$tx)
                                    PNValue = [int]$pn.Value
                                }
                            }
                        }
                        else
                        {
                            $pnFlag = $false
                        }
                 
                #        write-host("   [{0}][{1}] Value: {2} -- {3}" -f ($ty),$tx,$tv,$pnFlag)
                    }
                }
            }
        }
        $pntotal = 0
        foreach($pn in $pnarray|?{$_.Valid -eq $true}){
           #Write-host ("{0}" -f $pn.Value)
            $pntotal += [int]$pn.Value
        }
        write-host ("Answer Part 1: {0}" -f $pntotal)
        #$pnarray
        #$stars
        #part 2
        $sumofgearratios = 0
        $ustars = $stars|group coord | ?{$_.count -gt 1} | select -ExpandProperty name
        foreach($us in $ustars){
            $tempgearratio = 1
            $substars = $stars|?{$_.coord -eq $us}
            foreach($subs in $substars){
                $tempgearratio = $tempgearratio * $subs.PNValue
            }
            #$stars|?{$_.coord -eq $us}|%{$tempgearratio = $tempgearratio * $_.}
            $sumofgearratios += $tempgearratio
        }
        write-host ("Answer Part 2: {0}" -f $sumofgearratios)
    }#begin
}
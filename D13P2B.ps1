Function D13p2b{
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
                $data = Get-Content .\Day_13\Input_test.txt
            }
            B {
                Write-host "ParameterSet B"
                $data = Get-Content .\Day_13\Input.txt
            }
            Default {}
        }
        $games =@()
        #parse data into games
        #find next blank line
        $y = 0; $ys = 0
        While ($y -le $data.count){
            While($data[$y] -ne "" -and ($y -lt $data.count)){
                write-host("Y:{0:d4} | {1}" -f $y,$data[$y])
                $y++
            } 
            $games += [PSCustomObject]@{
                ys = $ys
                ye = $y -1 
                xs = 0
                xe = $data[$ys].length -1
                scoreOrig = @()
                scoreMod = @()
            }
            
            write-host ("Break found - Y: {0}" -f $y)
            write-host  ("Game:  ({0},{1}) to ({2},{3})" -f $ys,0,($y -1),($data[$ys].length))
            $y++
            $ys = $y
        }#end of parsing data

        foreach($g in $games){

            #get the board data
            $mb  = @() #masterboard
            $rows = @(); $cols = @()
            for($y = $g.ys;$y -le $g.ye;$y++){
                $mb += ,($data[$y].tochararray())
                $rows += $data[$y]
            }
            for($x = 0; 
                $x -le $g.xe;
                $x++)
            {
                $cols += ($mb|%{$_[$x]}) -join ""
            }


            #now get scores for unmod
            $mb  = @() #masterboard
            $rows = @(); $cols = @()
            for($y = $g.ys;$y -le $g.ye;$y++){
                $mb += ,($data[$y].tochararray())
                $rows += $data[$y]
            }
            for($x = 0; $x -le $g.xe; $x++){$cols += ($mb|%{$_[$x]}) -join ""}

            #compare Columns
                $vscore = 0
                for($i = 0;$i -lt ($cols.Count -1);$i++){
                    #write-host ("{0} and {1}" -f $i,($i +1))
                    if($cols[$i] -eq $cols[$i+1]){
                        #Write-host "  Match"
                        $left = @(0..$i);$right = @(($i+1)..($cols.count -1))
                        #write-host ("  {0}..{1} ({2}) and {3}..{4} ({5})" -f 0,$i,($left.count),($i + 1),($v.count -1),$right.count)
                        $j = [math]::Min($left.count,$right.count)
                        #write-host ("  {0} to compare" -f $j)
                        $flag = $true
                        for($k = 0;$k -lt $j;$k++){
                            $leftindex = $i - $k; $rightindex = $i + 1 + $k
                            if($cols[$leftindex] -ne $cols[$rightindex]){$flag = $false}
                        }
                        #Write-Host ("   Mirror Location: {0}" -f $flag)
                        if($flag){
                            $g.scoreOrig += $left.count
                            write-host ("   VScore: {0}" -f $left.count)
                            
                        }
                    }
                    else{
                        #Write-host "  No Match"
                        
                    }
                }

            #Compare Rows
                $hscore = 0
                for($i = 0;$i -lt ($rows.Count -1);$i++){
                    #write-host ("{0} and {1}" -f $i,($i +1))
                    if($rows[$i] -eq $rows[$i+1]){
                        #Write-host "  Match"
                        $top = @(0..$i);$bottom = @(($i+1)..($rows.count -1))
                        #write-host ("  {0}..{1} ({2}) and {3}..{4} ({5})" -f 0,$i,($top.count),($i + 1),($v.count -1),$bottom.count)
                        $j = [math]::Min($top.count,$bottom.count)
                        #write-host ("  {0} to compare" -f $j)
                        $flag = $true
                        for($k = 0;$k -lt $j;$k++){
                            $topindex = $i - $k; $bottomindex = $i + 1 + $k
                            if($rows[$topindex] -ne $rows[$bottomindex]){$flag = $false}
                        }
                        #Write-Host ("   Mirror Location: {0}" -f $flag)
                        if($flag){
                            $g.scoreOrig += (100 * $top.count)
                            write-host ("   HScore: {0}" -f (100 * $top.count))
                            $htotscore += $hscore
                        }
                    }
                    else{
                        #Write-host "  No Match"
                        
                    }
                }

            #get the mirror with change.

                $swapindex = 0
                $swapflag = $false
                $xsize = $g.xe - $g.xs +1 
                $ysize = $g.ye - $g.ys +1
                While(($swapflag -eq $false) -and ($swapindex -lt ($ysize * ($xsize)))){
                #While( ($swapindex -lt ($ysize * ($xsize)))){
                    $swapy = [math]::floor($swapindex / $xsize)
                    $swapx = $swapindex % $xsize
                    $flag = $false
                    Write-host ("  Swapping {0},{1}" -f $swapy,$swapx)
                    $tb = @()
                    for($y = $g.ys;$y -le $g.ye;$y++){
                        $tb += ,($data[$y].tochararray())
                    }

                    switch ($mb[$swapy][$swapx]) {
                        "." {
                            $tb[$swapy][$swapx] = "#" ;
                            #write-host ("  Swapped . for #");
                            break
                        }
                        "#" {
                            $tb[$swapy][$swapx] = "." ;
                            #write-host ("  Swapped # for .");
                            break
                        }
                        Default {}
                    }
                    Write-host ("Pause to look at tb")

                    $h = @()
                    for($y = 0;$y -lt ($g.ye - $g.ys + 1);$y++){
                        #$db+= ,$tb[$y].tochararray()
                        $h += $tb[$y] -join ""
                    }

                    $v = @()
                    for($i = 0;$i -lt $tb[0].length;$i++){
                        $v+= ($tb|%{$_[$i]}) -join ""
                    }
                    
                    #compare Columns
            
                        $vscore = 0
                        for($i = 0;$i -lt ($v.Count -1);$i++){
                            #write-host ("{0} and {1}" -f $i,($i +1))
                            if($v[$i] -eq $v[$i+1]){
                                #Write-host "  Match"
                                $left = @(0..$i);$right = @(($i+1)..($v.count -1))
                                #write-host ("  {0}..{1} ({2}) and {3}..{4} ({5})" -f 0,$i,($left.count),($i + 1),($v.count -1),$right.count)
                                $j = [math]::Min($left.count,$right.count)
                                #write-host ("  {0} to compare" -f $j)
                                $flag = $true
                                for($k = 0;$k -lt $j;$k++){
                                    $leftindex = $i - $k; $rightindex = $i + 1 + $k
                                    if($v[$leftindex] -ne $v[$rightindex]){$flag = $false}
                                }
                                #Write-Host ("   Mirror Location: {0}" -f $flag)
                                if($flag){
                                    
                                    write-host ("   VScore: {0}" -f $left.count)
                                    if( ($left.count) -in $g.scoreOrig){
                                        $swapflag = $false;
                                        $flag = $false
                                    }
                                    else{
                                        $swapflag = $true
                                        $g.scoreMod += $left.count
                                    }
                                }
                            }
                            else{
                                #Write-host "  No Match"
                                
                            }
                        }

                    #Compare Rows
                        $hscore = 0
                        for($i = 0;$i -lt ($h.Count -1);$i++){
                            #write-host ("{0} and {1}" -f $i,($i +1))
                            if($h[$i] -eq $h[$i+1]){
                                #Write-host "  Match"
                                $top = @(0..$i);$bottom = @(($i+1)..($h.count -1))
                                #write-host ("  {0}..{1} ({2}) and {3}..{4} ({5})" -f 0,$i,($top.count),($i + 1),($v.count -1),$bottom.count)
                                $j = [math]::Min($top.count,$bottom.count)
                                #write-host ("  {0} to compare" -f $j)
                                $flag = $true
                                for($k = 0;$k -lt $j;$k++){
                                    $topindex = $i - $k; $bottomindex = $i + 1 + $k
                                    if($h[$topindex] -ne $h[$bottomindex]){$flag = $false}
                                }
                                #Write-Host ("   Mirror Location: {0}" -f $flag)
                                if($flag){
                                    
                                    write-host ("   HScore: {0}" -f (100 * $top.count))
                                    if( (100 * $top.count) -in $g.scoreOrig){
                                        $swapflag = $false;
                                        $flag = $false
                                        
                                    }else{
                                        $swapflag = $true
                                        $g.scoreMod += (100 * $top.count)
                                    }
                                    #$htotscore += $hscore
                                }
                            }
                            else{
                                #Write-host "  No Match"
                                
                            }
                        }

                    if($flag){                        
                        #we found a mirror and thus the smudge location Exit this loop.
                    }else{
                        #Write-host ("Swap did not yield a match... move to the next swap")
                        $swapindex++
                    }

                }#end of Swaps

            
                

            Write-host ("`nEnd of game")
        }#end for each game
        foreach($g in $games){
            $us = $g.scoreMod|select -Unique
            $total = $total + $us
        }
        write-host ("Total Mod: {0}" -f $total)
        Write-host  ("Done")
        $games
    }
}
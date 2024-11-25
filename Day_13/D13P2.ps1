Function D13p2{
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

        $bsy = 0; $y = 0 #board start y
        $bey  = $data.count -1 #board end y
        
        $htotscore = 0 #horizontal Total Score
        $vtotscore = 0 #vertical total Score
        #get board

        #false Start
        #$y = 226
        #$bstart = $y

        #loop for games
        While($y -lt $data.count){
            $db = @()
            
            #Find the next game block
                While(($y -lt $data.count) -and ($data[$y] -ne "")){
                    $y++
                }
                
                $bey = $y - 1
                $bsx = 0
                
                $bex = $data[$bsy].length -1 
                $bexplus = $data[$bsy].length
                write-host ("`nBlock from {0},{1} to {2},{3}" -f $bsy,$bsx,$bey,$bex)


            #reset loop for swaps
                $swapindex = 0
                $swapflag = $false

                While(($swapflag -eq $false) -and ($swapindex -lt (($bey - $bsy + 1) * $bexplus))){
                    $swapy = [math]::floor($swapindex / $bexplus)
                    $swapx = $swapindex % $bexplus
                    
                    Write-host ("  Swapping {0},{1}" -f $swapy,$swapx)

                    #get tempboard and perform the swap
                    $tb = @() #tempboard will contain the swap
                    $tmb = $data[($bsy)..($bey)] #temp board master - will contain copy of board for future swaps
                    foreach($row in $tmb){
                        $tb += ,($row.tochararray())
                    }
                    
                    switch ($tb[$swapy][$swapx]) {
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

                    #logic to check for mirrors

                    $h = @()
                    for($y = 0;$y -lt ($bey - $bsy + 1);$y++){
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
                                    $vscore = $left.count
                                    write-host ("   VScore: {0}" -f $vscore)
                                    $vtotscore += $vscore
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
                                        $hscore = 100 * $top.count
                                        write-host ("   HScore: {0}" -f $hscore)
                                        $htotscore += $hscore
                                    }
                                }
                                else{
                                    #Write-host "  No Match"
                                    
                                }
                            }

                    #after the mirror checks before moving on
                    if($flag){
                        $swapflag = $true
                        #we found a mirror and thus the smudge location Exit this loop.
                    }else{
                        #Write-host ("Swap did not yield a match... move to the next swap")
                        $swapindex++
                    }
                }

        $bsy = $bey + 2
        $y = $bsy
<# 
            $h = @()
            for($y = $bstart;$y -le $blockend;$y++){
                $db+= ,$data[$y].tochararray()
                $h += $data[$y]
            }
            
            $v = @()
            for($i = 0;$i -lt $data[$bstart].length;$i++){
                $v+= ($db|%{$_[$i]}) -join ""
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
                        $vscore = $left.count
                        write-host ("   VScore: {0}" -f $vscore)
                        $vtotscore += $vscore
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
                        $hscore = 100 * $top.count
                        write-host ("   HScore: {0}" -f $hscore)
                        $htotscore += $hscore
                    }
                }
                else{
                    #Write-host "  No Match"
                    
                }
            }
            #$db
            $y = $y + 2
            $bstart = $blockend + 2
            $y = $bstart
         #>
        }#big while loop for games

    
        write-host ("Answer Part 1: {0}" -f ($htotscore + $vtotscore))
    }
}
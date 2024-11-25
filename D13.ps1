Function D13{
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

        $bstart = 0; $y = $bstart
        $bend  = $data.count -1
        
        $htotscore = 0
        $vtotscore = 0
        #get board

        #false Start
        #$y = 226
        #$bstart = $y

        While($y -lt $bend){
            $db = @()
        While(($y -le $bend) -and ($data[$y] -ne "")){
            $y++
        }
        $blockend = $y - 1
        write-host ("`nBlock from {0} to {1}" -f $bstart,$blockend)

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
        #$y = $y + 2
        $bstart = $blockend + 2
        $y = $bstart
    }#big while loop for data

    write-host ("Answer Part 1: {0}" -f ($htotscore + $vtotscore))
    }
}
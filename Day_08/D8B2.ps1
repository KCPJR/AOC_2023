Function D8b2{
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
                $data = Get-Content .\Day_08\Input_test3.txt
            }
            B {
                Write-host "ParameterSet B"
                $data = Get-Content .\Day_08\Input.txt
            }
            Default {}
        }
    
        #parse Data
        $startkeys = @()
        $h = @{}
        $dt = @($data[0])
        $d = $dt.tochararray()
        #$dt = $dt.replace("R", [int] 1)
        #$d = $dt.ToCharArray()
        for($i = 2;$i -lt $data.count;$i++){
            Write-Verbose ("Str: {0}" -f $data[$i])
            $str = $data[$i]
            $key = ($str.substring(0,3)).tostring()
            Write-Verbose ("  Key: {0}" -f $key)
            if($key[2] -eq 'A'){$startkeys += $key}
            $Left = ($str.substring(7,3)).ToString()
            Write-Verbose ("  Left: {0}" -f $Left)
            $Right = ($str.substring(12,3)).tostring()
            Write-Verbose ("  Right: {0}" -f $Right)
            #$h.Add($data[$i].substring(0,2).tostring(),@($data[$i].substring(7,9).tostring(),$data[$i].substring(12,14).tostring()))
            $h.Add($key,($left,$right))
        }
        #$h
        
       
        #$StartKey = $startkeys[1]
            $loopinfo = @()
            $loopindex = 0
        foreach($startkey in $startkeys){
            $movehist = @()
            $zcount = 0
            $exit = $false
            $i = -1
            $start = $h[$startkey]
        While ($exit -eq $false){
            $i++ 
            $j = $i % $d.count
            $destentry = ($h[$StartKey])
            $dir = $d[$j]
            switch ($dir) {
                "L" { $dest = $destentry[0]
                }
                "R" { $dest = $destentry[1]}
                Default {}
            }
            #$dest = $destentry[$dir]
            #Write-Host ("i: {0} j:{1} Dir: {2}  ({3})" -f $i, $j, $dir, ($h[$StartKey] -join (",")))
            #write-host ("Start: {0}  Destination: {1}" -f $StartKey, $dest)
            #Write-host ("Start: {0}  ({1}) {2} {3}" -f $StartKey, ($h[$StartKey] -join (",")),$dir,$i)
            $destkey = $dest
            if($destkey[2] -eq 'Z' ){
                if($zcount -gt 0){$exit = $true}
                $movehist += [PSCustomObject]@{
                    Index = $i
                    Start = $startkey
                    Direction = $dir
                    Destination = $destkey

                }
            }
            else{
                $zcount++
                
            }
            $StartKey = $dest
            
        }#while Loop
        #Write-host ("Answer Part 1: {0}" -f ($i + 1))
        #$movehist
        
        $loopinfo += [PSCustomObject]@{
            Index = $loopindex
            Loop1 = $movehist[0].Index +1
        }   
        $loopindex++
        }#foreach loop
        $answerpart2 = get-lcm ($loopinfo.loop1)
        write-host ("Answer Part2 : {0}" -f $answerpart2) 
    }
}
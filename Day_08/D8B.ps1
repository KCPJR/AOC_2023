Function D8B{
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
        $h = @{}
        $dt = @($data[0])
        $d = $dt.tochararray()
        #$dt = $dt.replace("R", [int] 1)
        #$d = $dt.ToCharArray()
        $startkeys = @()
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
        $exit = $false
        $i = -1
        #$StartKey = 'AAA'
        #$start = $h['AAA']
        While ($exit -eq $false){
            $destkeys = @()
            $i++ 
            $j = $i % $d.count
            
            foreach($startkey in $startkeys){
                $destentry = ($h[$StartKey])
                $dir = $d[$j]
                switch ($dir) {
                    "L" { $destkeys += $destentry[0]
                        Break
                    }
                    "R" { $destkeys += $destentry[1]
                        Break
                    }
                    Default {}
                }
            #$dest = $destentry[$dir]
                Write-Host ("i: {0} j:{1} Dir: {2}  ({3})" -f $i, $j, $dir, ($h[$StartKey] -join (",")))
            #write-host ("Start: {0}  Destination: {1}" -f $StartKey, $dest)
            }
            $exitTemp = $true    
            foreach($destkey in $destkeys){
                    #if($destkey[2] -eq 'Z'){$exitTemp = $exitTemp -and $true}
                    $exitTemp = $exitTemp -and ($destkey[2] -eq 'Z')
            }    

            if($exitTemp -eq $true ){
                $exit = $true}    
            else{
                    $StartKeys = $destkeys
            }

            
        }#while Loop
        Write-host ("Answer Part 2: {0}" -f ($i + 1))
    }
}
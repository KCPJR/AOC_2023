Function D11{
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
                $data = Get-Content .\Day_11\Input_test.txt
            }
            B {
                Write-host "ParameterSet B"
                $data = Get-Content .\Day_11\Input.txt
            }
            Default {}
        }

        $ymax = $data.count -1
        $xmax = $data[0].tochararray().length -1

        $occupiedx = New-Object bool[] ($xmax + 1)
        $occupiedy = New-Object bool[] ($ymax + 1)

        $g = @{} #galaxy hash
        $i = 0
        for($y = 0;$y -le $ymax;$y++){
            for($x = 0; $x -le $xmax;$x++){
                if($data[$y][$x] -eq "#"){
                    $g[$i] = ("{0},{1}" -f $y,$x)
                    $occupiedx[$x] = $true
                    $occupiedy[$y] = $true
                    $i++
                }
            }
        }

        $expansionx = @(); $expansiony = @()
        for($i = 0;$i -lt $xmax;$i++){if(!$occupiedx[$i] ){$expansionx += $i}}
        for($i = 0;$i -lt $ymax;$i++){if(!$occupiedy[$i]){$expansiony += $i}}

        #time to calculate
        $totaldistance = 0
        $totdt10 = 0
        $k = 0
        for($i = 0;$i-le ($g.Count);$i++){
            for($j = $i + 1; $j -lt $g.count;$j++){
                
                
                $k++

                $Py = ($g[$i].split(","))[0]
                $Px = ($g[$i].split(","))[1]

                $Qy = ($g[$j].split(","))[0]
                $Qx = ($g[$j].split(","))[1]
            
                $dx = [math]::Abs($Qx - $Px)
                $dy = [math]::Abs($Qy - $Py)
                $d= $dx + $dy

                $adjx = ($expansionx|?{$_ -in ($Px..$Qx)}).count
                $adjy = ($expansiony|?{$_ -in ($Py..$Qy)}).count
                
                $adjx10 = (1000000 - 1 )* ($expansionx|?{$_ -in ($Px..$Qx)}).count
                $adjy10 = (1000000 - 1 ) * ($expansiony|?{$_ -in ($Py..$Qy)}).count


                $totaldistance = $totaldistance + $dx + $dy + $adjx + $adjy
                $totdt10 = $totdt10 + $dx + $dy + $adjx10 + $adjy10 
                #write-host ("{0} : {1} to {2} = base: {3} + adjx: {4} + adjy: {5}" -f $k,$i,$j,$d,$adjx, $adjy)
            }
        }


        #$occupiedx
        write-host ("Stop right here")
        Write-host ("Answer Part 1: {0}" -f $totaldistance)
        write-host ("Answer 10x : {0}" -f $totdt10)
    }
}
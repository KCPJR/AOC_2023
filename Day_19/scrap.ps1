function generator {

    $xs = (0..3)
    $ms = (0..4)
    $as = (0..3)
    $ss = (0..4)

    $i = 0
    $table = [ordered]@{}
    foreach($x in $xs){
        foreach($m in $ms){
            foreach($a in $as){
                foreach($s in $ss){
                    $table.add($i, [PSCustomObject]@{
                        I = $i
                        X = $x
                        M = $m
                        A = $a
                        S = $s
                    }
                    )
                    $i++
                }
            }
        }
    }
    
    write-host ("Pause")
    $table.Values
}

function Converter {
    [CmdletBinding()]
    param (
        $v
    )
    
    begin {
        $xr = 3
        $mr = 4
        $ar = 3
        $sr = 4
        
        $sv = 1
        $av = $sr + 1
        $mv = ($ar + 1) * ($sr + 1)
        $xv = ($mr + 1) * ($ar + 1) * ($sr + 1) 
        

        $tv = $v
        
        $x = [math]::floor($tv / $xv)
            $tv = $tv - ($x * $xv)
        $m = [math]::floor($tv / $mv)
            $tv = $tv - ($m * $mv)
        $a = [math]::floor($tv /$av)
            $tv = $tv - ($a * $av)
        $s = $tv
    
        write-host ("I:{0} -- X:{1} M:{2} A:{3} S:{4}" -f $v,$x,$m,$a,$s)

    }
    
    process {
        
    }
    
    end {
        
    }
}
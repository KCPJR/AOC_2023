function get-factors {
    [CmdletBinding()]
    param (
        $n        
    )
    
    begin {
        $i = 2
        $factors = @()
        while ($i -le [math]::Sqrt($n)){
            $r = $n % $i
            write-host ("{0} / {1} = {2} R {3}" -f $n,$i,([math]::Floor($n/$i)),$r)
            if($r -eq 0){
                Write-host (" Factor Found: {0}" -f $i)
                $factors += $i
                #$factors += [math]::floor($n/$i)
                $n = $n / $i
                $i = 2
            }
            else{
                $i++
            }
        }
        $factors += $n
        $factors

    }
    

}

function Get-LCM {
    [CmdletBinding()]
    param (
        $numbers = @()
    )
    
    begin {
        $factorhash = @{}
        foreach($n in $numbers){
        $factors  = get-factors $n
        $gft = $factors|group -NoElement
        
        foreach($factor in $gft){
            if($factorhash.ContainsKey($factor.Name)){
                if($factor.count -gt $factorhash[$factor.name]){$factorhash[$factor.name] = $factor.count}
            }Else{
                $factorhash[$factor.name] = $factor.count
            }
        }
    }
    $t = 1
    foreach($f in $factorhash.Keys){
        $t= $t * [math]::Pow($f, $factorhash[$f])
    }    
    write-host ("LCM: {0}" -f $t)
    $t
}
    
}
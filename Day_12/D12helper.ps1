

function convertTo-Base
{
    [CmdletBinding()]
    param (
        [parameter(HelpMessage="Integer number to convert")][int]$decNum="",
        [int]$base = 2
        )
    Begin{    
        
        $alphabet = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        $vals = $alphabet.substring(0,$base)
        
            do {
                $remainder = ($decNum % $base)
                $char = $vals.substring($remainder,1)
                $baseNum = "$char$baseNum"
                $decNum = ($decNum - $remainder) / $base
            }
            while ($decNum -gt 0)
            #while ($decNum -gt $base)

            $baseNum
        
    }
}

function Helper-Combo {
    [CmdletBinding()]
    param (
        [int]$n = 4, #locations,
        [int]$r = 4
    )
    
    begin {
        #$max = [math]::Pow($n,$r)
        switch ($r) {
            0 { "{0}" -f ("0" * $n)}
            1 { for($i = 0;$i -lt $n;$i++){"{0:d$n}" -f [int]([math]::Pow(10,$i))} }
            Default 
            {
                $ti = 0
               #$max = [math]::Pow($r+ 1,$n) -1
                $max = [math]::Pow($r +1 ,$n) - [math]::Pow($r + 1,$n -1)
                #$max = [math]::Pow($n,$r+1) - [math]::Pow($n,$r) 
                #write-host ("Max: {0}" -f $max)
                $raw = 0..($max )
                Write-Verbose ("Max: {0}" -f $raw.count)
                foreach($q in $raw){
                    
                    $t = "{0:d$n}" -f [int](convertTo-Base -decNum $q -base ($r + 1))
                    Write-Verbose ("{0} : {1}" -f $ti,$t)
                    #$t = "{0}" -f [int](convertTo-Base -decNum $q -base $n)
                    #$tsum = ([int[]]($t -split("") -ne '')|measure -sum).sum
                    $tsum = ([int[]]($t -split("") )|measure -sum).sum
                    if($tsum -eq $r){$t}
                    $ti++
                }
            }
        }#switch

        
    } #begin
} #function
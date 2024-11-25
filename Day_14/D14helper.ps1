function D14-Pattern {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        $results
       $raw = Get-Content .\day_14\TestOut_1000.txt
       $arr = @()
       foreach($r in $raw){
            $rsplit = $r.split("`t")
            $obj = [PSCustomObject]@{
                ind = $rsplit[0]
                v = $rsplit[1]
            }
            $arr += $obj
       } 

       $tar = $arr|group v -NoElement|?{$_.Count -eq 12}|select -ExpandProperty Name
       foreach($t in $tar){
        $subgroup = @($arr|?{$t -eq $_.v}|select -ExpandProperty ind)
        $min = @($subgroup|sort )[0]
        $results += ,$min
        write-host ("Min: {0} "-f $min)
        }
       ($results|sort)[0]
    }
    
}
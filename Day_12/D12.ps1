function Get-Factorial {
    [CmdletBinding()]
    param (
        [int]$n
    )
    
    begin {
        $i = [Math]::Max($n,1)
        $f = [bigint] $i

        while(--$i -ge 1){
            $f = $f * $i
        }
        $f
    }
    
    process {
        
    }
    
    end {
        
    }
}

Function D12c{
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
                $data = Get-Content .\Day_12\Input_test.txt
            }
            B {
                Write-host "ParameterSet B"
                $data = Get-Content .\Day_12\Input.txt
            }
            Default {}
        }
        $dontenum = !$false

        $g = @()
        $totalgood = 0
        
        $index = 1
        $batchsize = $data.Count

        $reccount = $index + $batchsize
        #foreach($r in $data[$index..$reccount]){
        #foreach($r in $data[52]){
        foreach($r in $data){
            $matchcount = 0
            $spaceindex = $r.indexof(" ")
            #write-host ("R: {0}" -f $r)
            
            $strarr = $r[0..($spaceindex -1 )] #str
            $str = $strarr -join ""
            $blocks = $r.Substring($spaceindex + 1).split(",") #arr of groups
            $blockstr = $blocks -join ","
            $nu = ($r.ToCharArray()|?{$_ -eq "?"}).count #num of unknown
            $nlbs = ($strarr|?{$_ -eq "#"}).count
            #write-host  ("  Count of ?: {0}" -f $nu)
            $sumblocksplus = ($blocks|measure -Sum).sum + $blocks.count -1
            $target = ($blocks|measure -Sum).Sum
            [int]$unplacedspacecount = $str.Length - ($sumblocksplus)
            $qpow2 = [int][math]::Pow(2,$nu)
            Write-Host ("")
            Write-host ("{0} of {1} ({2:p1})" -f $index,$batchsize,($index/$reccount))

            $n = $blocks.count + 1 #possible positions
            $r = $unplacedspacecount #number of spaces left to assign
            $combinations = (get-factorial ($n + $r -1))/( (Get-Factorial ($n -1)) * (Get-Factorial $r))
            $ratio = [int]$combinations / [int]$qpow2 
            
            write-host ("  {0} : [{1}]" -f $str,$blockstr)
            write-host ("  Unknown: {0}" -f $nu)
            write-host ("  N: {0} R: {1} C:{2} CRaw:{3} QBinRaw: {4} Wrong:{5}" -f $n,$r,$combinations, ([math]::Pow($n,$r)),$qpow2,([math]::Pow($n,$n)))
            
            if(!$dontenum){
                if($r -eq 0){
                    #there are no options - there is only one way 
                }
                
                $enum = Helper-Combo -n $n -r $r
                
                foreach ($e in $enum){
                    $estr = ""
                    #$ch = $e.ToCharArray()
                    $ch = [int[]](($e -split '') -ne '')
                    #Write-Host ("Ch[0]: {0}" -f $ch[0])
                    $estr += '.' * [int]$ch[0]
                    for($i = 1;$i -le ($ch.count -1);$i++){
                        $estr += "#" * $blocks[$i -1]
                        $estr += "." * ($ch[$i] + 1)
                    }
                    #remove last extra .
                    $estr = $estr.Substring(0,($estr.Length -1))
                    #write-host ("[{0}] -> {1}" -f $blockstr, $estr)
                    
                    $i = 0
                    $match = $true
                    foreach($x in $strarr){
                        switch ($x) {
                            "#" {if($estr[$i] -ne "#"){$match = $false;break}  }
                            "." {if($estr[$i] -ne "."){$match = $false;break}}
                            Default {}
                        }
                        $i++
                        if(!$match ){break}
                    }
                    #write-host ("Match: {0}" -f $match)
                    if($match){$matchcount++}
                }
            }#enum

            $gnew = [PSCustomObject]@{
                index = $index
                strarr = $strarr
                str = $str
                blocks = $blocks
                blockstr = $blockstr
                nu = $nu
                nlbs = $nlbs
                Accounted = [int]$sumblocksplus
                Length = $str.Length
                
                uSpaces = $unplacedspacecount
                PoPos = $n
                C = $combinations
                CRaw = [bigint][math]::Pow($r +1 ,$n) - [bigint][math]::Pow($r + 1,$n -1)
                RawUBin = $qpow2
                R = $ratio
                Matches = $matchcount
            }

            $gnew | select index, str, blockstr, length, accounted, uSpaces, popos, c, CRaw, Matches
            #Write-host("{0} of {1} {2} N:{3} R:{4} C:{5} Matches:{6}"-f $index, $reccount,$str,$n,$unplacedspacecount, $combinations, $matchcount )
            $totalgood += $matchcount
            #write-host ("C: {0}" -f $combinations)
            $index++
        }
        Write-host ("Total Matches: {0}" -f $totalgood)
        #$g | select str, blockstr, length, accounted, uSpaces, popos, c, RawUBin, R, Matches
        


    }
}
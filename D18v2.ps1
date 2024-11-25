Function D18v2{
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
                $data = Get-Content .\Day_18\Input_test.txt
            }
            B {
                Write-host "ParameterSet B"
                $data = Get-Content .\Day_18\Input.txt
            }
            Default {}
        }

        $x = 0; $y = 0
        $map = @{}
        #$map.add("0,0",$true)
        $minx = 0; $miny = 0
        $maxx = 0; $maxy = 0

        foreach($instr in $data){
            $tmp = $instr.split(" ")
            $dir = $tmp[0]
            $dist = $tmp[1]
            
            for ($i = 1;$i -le $dist;$i++){
                switch ($dir) {
                    R {$x++}
                    L {$x--}
                    D {$y++}
                    U {$y--}
                    Default {}
                }
                #$coord = ("{0},{1}" -f $x,$y)
                #$map[$coord] =$true
                if($x -lt $minx){$minx = $x}
                if($x -gt $maxx){$maxx = $x}
                if($y -lt $miny){$miny = $y}
                if($y -gt $maxy){$maxy = $y}
            }
        }
        write-host ("Min X:{0} Max X:{1}" -f $minx,$maxx)
        write-host ("Min Y:{0} Max Y:{1}" -f $miny,$maxy)

        $xmod = [math]::Abs($minx) +1 #; write-host ("X shift:{0}"-f $xmod)
        $ymod = [math]::Abs($miny) +1 #; write-host ("Y shift:{0}"-f $ymod)

        foreach($instr in $data){
            $tmp = $instr.split(" ")
            $dir = $tmp[0]
            $dist = $tmp[1]
            
            for ($i = 1;$i -le $dist;$i++){
                switch ($dir) {
                    R {$x++}
                    L {$x--}
                    D {$y++}
                    U {$y--}
                    Default {}
                }
                $coord = ("{0},{1}" -f ($x + $xmod),($y + $ymod))
                $map[$coord] =$true
                if($x -lt $minx){$minx = $x}
                if($x -gt $maxx){$maxx = $x}
                if($y -lt $miny){$miny = $y}
                if($y -gt $maxy){$maxy = $y}
            }
        }
        write-host ("Pause")

        $minx = 0;$miny = 0
        $maxx = $maxx + $xmod +1; $maxy = $maxy + $ymod +1
        $imap = @{}
        $filepath = ".\Day_18\map.txt"
        
        Set-Content -Path $filepath -Value $null
        
        $flag = $false
        for($y = 0;$y -le $maxy;$y++){
            
            $str = ""
            $str2 = ""
            $flag = $false
            $prev = "."
            for($x = 0;$x -le $maxx;$x++){
                
                
                
                $coord = ("{0},{1}" -f $x,$y)
                if($map.ContainsKey($coord)){
                    $ind = $x + ($y * ($maxx +1))
                    $imap[$ind] = $true
                    $ch = "#"
                    $str+= $ch
                }
                else{
                    $ch = "."
                    $str+= $ch
                }
            }
            Add-Content -Path $filepath -Value $str
        }
     
        $nm = @{} #map of nots


        $x = 0 ; $y = 0
        $next = @{}
        #$next[0] = $x + $y * ($maxx + 1)
        $next[0] = ("{0},{1}" -f $x,$y)

        <# $i = 0
        for($y = 0; $y -le $maxy +1 ;$y++){
            for($x = 0;$x -le $maxx +1;$x++){
                $nm[$i] =("{0},{1}" -f $x,$y)
                $i++
            }
        } #>
        

        $Visited = @{}
        write-host ("Pause")
        $cur = 0
        $x = 0 ; $y = 0
        do{
            $cur = ($next.keys|sort)[0]
            $Visited.add($cur,$true)
            $x = $cur % ($maxx +1)
            $y = [math]::floor($cur/($maxx +1 ))
            
            if(!($imap.Keys -Contains($cur))){
                $nm[$cur] = $true
                #$ind = $x + $y * ($maxx + 1)
                #East
                    $ty = $y  ; $tx = $x + 1
                    $tind = $tx + $ty * ($maxx + 1)
                    if($tx -eq 8)
                        {write-host "Pause"}
                    if($Visited.Keys -Contains($tind)){$BT = $true}else{$BT = $false}
                    
                    if(($tx -lt $maxx +1) -and
                        !$BT
                        ){
                        
                        $next[($tx + $ty * ($maxx + 1))] = ("{0},{1}" -f $tx,$ty)
                    }
                #South
                    $ty = $y +1  ; $tx = $x
                    $tind = $tx + $ty * ($maxx + 1)
                    if($ty -eq 11)
                        {write-host "Pause"}
                    
                        if($Visited.Keys -Contains($tind)){$BT = $true}else{$BT = $false}  
                    if(($ty -lt $maxy +1) -and !$BT){
                        $next[($tx + $ty * ($maxx + 1))] = ("{0},{1}" -f $tx,$ty)
                    }

                #North
                    $ty = $y -1 ; $tx = $x
                    $tind = $tx + $ty * ($maxx + 1)
                    if($Visited.Keys -Contains($tind)){$BT = $true}else{$BT = $false}
                    if(($tind -gt 0) -and !$BT){
                        $next[($tx + $ty * ($maxx + 1))] = ("{0},{1}" -f $tx,$ty)
                    }

                #west
                    $ty = $y ; $tx = $x -1
                    $tind = $tx + $ty * ($maxx + 1)
                    if($Visited.Keys -Contains($tind)){$BT = $true}else{$BT = $false}
                    if(($tx -ge 0) -and !$BT){
                        $next[($tx + $ty * ($maxx + 1))] = ("{0},{1}" -f $tx,$ty)
                    }
                }
            
            $next.remove($cur)
            
            
        }While ($next.Keys.count -gt 0)
        Write-Host ("Pause")

        $totalsq = ($maxy +1) * ($maxx + 1)
        $outside = $nm.Keys.Count
        $LagoonArea = $totalsq - $outside
        write-host ("Answer Part 1:{0}" -f $LagoonArea)

        

        
    }
}
Function D18v3{
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
        $rawvert = @()
        $i = 0
        $edge = 0
        foreach($instr in $data){
            $tmp = $instr.split(" ")
            $dir = $tmp[0]
            $dist = $tmp[1]
            $edge += $dist
            switch ($dir) {
                R {$x = $x + $dist}
                L {$x = $x - $dist}
                D {$y = $y + $dist}
                U {$y = $y - $dist}
                Default {}
            }
            $rawvert += [PSCustomObject]@{
                Index = $i
                X = $x
                Y = $y
            }
            $i++
            if($x -lt $minx){$minx = $x}
            if($x -gt $maxx){$maxx = $x}
            if($y -lt $miny){$miny = $y}
            if($y -gt $maxy){$maxy = $y}
        
        }
        write-host ("Min X:{0} Max X:{1}" -f $minx,$maxx)
        write-host ("Min Y:{0} Max Y:{1}" -f $miny,$maxy)
        $edge += 4 #accounting for size of perimeter of 4 box
        $xmod = [math]::Abs($minx) +1 # This is adding an extra space as a buffer.  Not necessary
        $ymod = [math]::Abs($miny) +1 # This is adding an extra space as a buffer.  Not necessary

        $verts = @{}
        foreach($v in $rawvert){
            $verts[$v.Index] = [PSCustomObject]@{
                Index = $v.Index
                X = $v.X + $xmod
                Y = $v.Y + $ymod
            }
        }
        write-host ("Pause - Verts Hash Built")
        
        #create lace arrays
        $XLace = @()
        $YLace = @()
        $XLace += $xmod
        $YLace += $ymod
        foreach($v in $rawvert){
            $XLace += ($v.X + $xmod)
            $YLace += ($v.Y + $ymod)    
        }
        #$XLace += ($rawvert[0].X + $xmod)
        #$YLace += ($rawvert[0].Y + $ymod)
    
        $i = 0
        $sub = 0
        for($i = 0;$i -le ($rawvert.count -1);$i++){
            $det = ($XLace[$i] * $YLace[$i+1] ) - ( $XLace[$i+1] * $YLace[$i])
            $sub += $det
            Write-host("`n{0}" -f $i)
            write-host("i   : ({1},{2})" -f $i,$XLace[$i],$ylace[$i])
            write-host("i+1 : ({1},{2})" -f $i,$XLace[$i +1],$YLace[$i + 1])
            write-host("    : ({1} * {2}) - ({3} * {4}) = {5}" -f $i,$XLace[$i],$YLace[$i+1],$XLace[$i+1],$YLace[$i],$det)
        }
        write-host  ("`nSub: {0}" -f $sub)
        write-host ("Inside Pts: {0}" -f ($sub/2))
        $Volume = ($sub/2) + ($edge / 2) -1
        write-host ("Volume: {0}" -f $volume)
    }
}
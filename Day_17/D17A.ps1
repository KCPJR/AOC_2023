Function D17A{
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
                $data = Get-Content .\Day_17\Input_test.txt
            }
            B {
                Write-host "ParameterSet B"
                $data = Get-Content .\Day_17\Input.txt
            }
            Default {}
        }
        $mr = 2
        $maxrow = $data.count -1
        $maxcol = $data[0].length -1
        #$nodecheckorder = @()
        $mod = $maxcol + 1
        #$visitednodes = @()
        #$visited = @{}
        $scores = @{}
        #$unvisitednodes = @()
        $nodes = @{}

        for($y = 0;$y -le $maxrow;$y++){
            
            $rowdata = $data[$y].tochararray()
            $rowdataint = @()
            
            foreach($ch in $rowdata){$rowdataint += [int]$ch -join "" - 48}
            for($x = 0;$x -le $maxcol;$x++){
                $ind = ($y * ($maxcol + 1) + $x)
                $nodes.add($ind,[PSCustomObject]@{
                    X = $x
                    Y = $y
                    Index = $ind
                    Coord = ("{0},{1}" -f $x, $y)                            
                    CostofNode = [int]($rowdata[$x] -join "") 
                    Visited = $false
                })
                #$unvisitednodes += $ind
            }    
        }
                $v = @{}
            
                $nodes[0].Visited = $true
                #$nodes[0].DirPath = "" 
                #$visited.add(0,1)
                #$visitednodes += ,0
                $CN = 0 #Current Node

                #Foreach($CN in (0..($nodes.Count -1))){
                $k = 0
                $nextoptions = @()
                $states = @()
                $newstates =@()
                $states += [PSCustomObject]@{
                    Index = 0
                    PreviousNode = ""
                    Dir = ""
                    TotalCost = 0
                    K = $k++
                    CurrentRun = 1
                    KR = 0
                    Path = @(0)
                    PathLength = 0
                    CabDist = 0
                    R = 0
                }
                $prevpath =@(0)
                #$k++
                
                #Repeat
                Do{
                    #Write-host ("Pause")
                    $pots = @()
                    #North
                    
                    $n = $CN - ($maxcol +1)
                    if($prevdir -eq "N"){$cr = $prevcr + 1}Else{$cr = 1}
                    $vstr = ("{0}|{1}|{2}" -f $n,"N",$cr)
                    $tc = $prevtotalcost + $nodes[$n].CostofNode
                    $flagprev = $false
                    if($v.ContainsKey($vstr)){
                        if($v[$vstr] -gt $tc ){$flagprev = $true}
                    }
                    else{$flagprev = $true}

                    If( ($n -ge 0) -and 
                        ($n -notin $prevpath) -and 
                        ($prevcr -le $mr -or ($prevdir -ne "N")) -and 
                        ($flagprev)
                        ){
                        $pots += [PSCustomObject]@{
                            N = $n
                            Dir = "N"
                        }    
                    }
                    #South
                    $n = $CN + ($maxcol + 1 )
                    
                    if($prevdir -eq "S"){$cr = $prevcr + 1}Else{$cr = 1}
                    $vstr = ("{0}|{1}|{2}" -f $n,"S",$cr)
                    $tc = $prevtotalcost + $nodes[$n].CostofNode
                    $flagprev = $false
                    if($v.ContainsKey($vstr)){
                        if($v[$vstr] -gt $tc ){$flagprev = $true}
                    }
                    else{$flagprev = $true}

                    If(($n -lt ($nodes.count)) -and ($n -notin $prevpath)-and ($prevcr -le $mr -or ($prevdir -ne "S")) -and $flagprev){
                        $pots += [PSCustomObject]@{
                            N = $n
                            Dir = "S"
                        }
                    }
                    #East
                    $n = $CN + 1
                    
                    if($prevdir -eq "E"){$cr = $prevcr + 1}Else{$cr = 1}
                    $vstr = ("{0}|{1}|{2}" -f $n,"E",$cr)
                    $tc = $prevtotalcost + $nodes[$n].CostofNode
                    $flagprev = $false
                    if($v.ContainsKey($vstr)){
                        if($v[$vstr] -gt $tc ){$flagprev = $true}
                    }
                    else{$flagprev = $true}

                    If( ([math]::Floor(($CN + 1 ) / $mod) -eq [math]::Floor(($CN) / $mod)) -and ($n -notin $prevpath)-and ($prevcr -le $mr -or ($prevdir -ne "E")) -and $flagprev){
                        $pots += [PSCustomObject]@{
                            N = $n
                            Dir = "E"
                        }
                    }
                    #West
                    $n = $CN -1
                    
                    if($prevdir -eq "W"){$cr = $prevcr + 1}Else{$cr = 1}
                    $vstr = ("{0}|{1}|{2}" -f $n,"W",$cr)
                    $tc = $prevtotalcost + $nodes[$n].CostofNode
                    $flagprev = $false
                    if($v.ContainsKey($vstr)){
                        if($v[$vstr] -gt $tc ){$flagprev = $true}
                    }
                    else{$flagprev = $true}

                    If(([math]::Floor(($CN - 1 ) / $mod) -eq [math]::Floor(($CN) / $mod)) -and ($n -notin $prevpath)-and ($prevcr -le $mr -or ($prevdir -ne "W")) -and $flagprev){
                        $pots += [PSCustomObject]@{
                            N = $n
                            Dir = "W"
                        }
                    }

                    foreach($pot in $pots){
                        $makenew = $false
                        if($prevdir -eq $pot.Dir){$cr = $prevcr + 1}Else{$cr = 1}
                        $vind = ("{0}|{1}|{2}" -f $pot.N,$pot.Dir,$cr)
                        $newscore = $prevtotalcost + $nodes[$pot.N].CostofNode
                        if($v.ContainsKey($vind)){
                            if( $v[$vind] -gt $newscore){
                                #create new state
                                $makenew = $true
                            }
                            #if cost is lower update it in the scores hash.
                            if($scores[$pot.N] -gt $newscore){
                                $scores[$pot.N] = $newscore
                            }
                        }   
                        Else{
                            if(!$scores.ContainsKey($pot.N)){$scores.Add($pot.n,$newscore)}
                            #$visited.Add($Pot.N,$cr)
                            $makenew = $true
                        }
                        if($makenew){
                            $path =  @($prevpath + $pot.N)
                            $cx = $nodes[$pot.n].X; $cy = $nodes[$pot.n].Y
                            $cab = $cx + $cy
                            $tc = $prevtotalcost + $nodes[$pot.N].CostofNode
                            $newstates += [PSCustomObject]@{
                                Index = $pot.N
                                PreviousNode = $CN
                                Dir = $pot.Dir
                                TotalCost = $tc
                                K = $k++
                                CurrentRun = $cr
                                KR = $cab/($tc * $cr * ($path.count))
                                Path = $path
                                PathLength = $path.count
                                CabDist = $cab
                                R = $cab/$path.count    
                            }
                            
                            $v.add($vind,$tc)
                        }
                    }

                    $newstates = $newstates | ?{$_.Index -ne 0}
                    
                    
                    <# foreach($optobj in $newstates){    
                        $opt = $optobj.Index
                        $PN = $optobj.PreviousNode
                        $states += $optobj
                    }  #>   
                        #if (  ($states[$PN].CostofPath + $nodes[$Opt].CostofNode -lt $states[$opt].CostofPath)){
                            #write-host("{0} + {1} = {2}" -f ($nodes[$PN].CostofPath),($nodes[$opt].CostofNode),(($nodes[$opt].CostofNode)+($nodes[$PN].CostofPath)))
                            #$nodes[$opt].CostofPath = [int](($nodes[$PN].CostofPath) + ($nodes[$opt].CostofNode))
                            #$nodes[$opt].Path = $Nodes[$PN].Path
                            #$nodes[$opt].Path += $PN
                            #$nodes[$opt].Path += $opt
                        #} 
                    

                    #$lowest = ($nodes.Values |?{$_.visited -eq $false}|sort CostofPath)[0].Index
                    $lowestobj = ($newstates | sort TotalCost)[0]
                    $lowest = $lowestobj.Index
                    #Write-host ("Node: {0} ({1},{2})  {3:p2}" -f $lowest,$nodes[$lowest].X,$nodes[$lowest].y, ($visitednodes.count / ($nodes.count -1)))
                    Write-host ("Node: {0} ({1},{2})  {3:p2}" -f $lowest,$nodes[$lowest].X,$nodes[$lowest].y, ($scores.Keys.count / ($nodes.count -1)))

                    #$nodecheckorder += $lowest # troubleshooting only.

                    #$nodes[$lowest].Visited = $true
                    #$visitednodes += $lowest
                    #$unvisitednodes = $unvisitednodes|?{$_ -ne $lowest}
                    $prevdir = $lowestobj.dir
                    $prevtotalcost = $lowestobj.TotalCost
                    $prevcr = $lowestobj.CurrentRun
                    
                    $prevpath = $lowestobj.Path
                    #make lowest the new CN
                    #$states += $lowestobj
                    $newstates = @($newstates | ?{$_.k -ne $lowestobj.K})

                    $CN = $lowest

                }
                while($lowest -ne ($nodes.count -1)  )
                #while($lowest -ne ($nodes.count -1) -and $k -le 1000 )
                
                #$newstates
                #$states
                Write-host ("Solution Part 1: {0}" -f $scores[$nodes.count -1])
                write-host ("Pause")
            
            
        
    }
}
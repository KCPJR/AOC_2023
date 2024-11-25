Function D17{
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
        $nodecheckorder = @()
        $maxrow = $data.count -1
        $maxcol = $data[0].length -1 
        #$maxrow = 3; $maxcol = 4
        $mod = $maxcol + 1
        $visitednodes = @()
        $unvisitednodes = @()
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
                    #CostofNode = $rowdata[$x]                    
                    CostofNode = [int]($rowdata[$x] -join "") 
                    Visited = $false
                    Path = @(0)
                    DirPath = @()
                    CurrentRun = 0
                    CostofPath = 999999999999999
                })
                $unvisitednodes += $ind
            
            }
        }

        $nodes[0].CostofPath = 0
        $nodes[0].Visited = $true
        $nodes[0].DirPath = "" 
        $visitednodes += ,0
        $CN = 0 #Current Node

        #Foreach($CN in (0..($nodes.Count -1))){
        
        $nextoptions = @()
        $mr = 2 #Max Repeat
        #Repeat
        Do{
            
            #North
            $n = $CN - ($maxcol +1)
            #If(($n -notin $visitednodes) -and ($n -ge 0) -and (($nodes[$CN].CurrentRun) -le $mr -or ($nodes[$CN].DirPath[-1] -ne "N"))){
            If( ($n -ge 0) -and (($nodes[$CN].CurrentRun) -le $mr -or ($nodes[$CN].DirPath[-1] -ne "N"))){    
                $nextoptions += [PSCustomObject]@{
                    Index = ($CN - ($maxcol + 1 ))
                    PreviousNode = $CN
                    Dir = "N"
                }
            }
            #South
            $n = $CN + ($maxcol + 1 )
            #If(($n -notin $visitednodes) -and ($n -le ($nodes.count)) -and (($nodes[$CN].CurrentRun)-le $mr -or ($nodes[$CN].DirPath[-1] -ne "S"))){
            If(($n -le ($nodes.count)) -and (($nodes[$CN].CurrentRun)-le $mr -or ($nodes[$CN].DirPath[-1] -ne "S"))){
                $nextoptions += [PSCustomObject]@{
                    Index = ($CN + ($maxcol + 1 ))
                    PreviousNode = $CN
                    Dir = "S"
                }
            }
            #East
            $n = $CN + 1
            #If(($n -notin $visitednodes) -and ([math]::Floor(($CN + 1 ) / $mod) -eq [math]::Floor(($CN) / $mod)) -and (($nodes[$CN].CurrentRun) -le $mr -or ($nodes[$CN].DirPath[-1] -ne "E"))){
            If( ([math]::Floor(($CN + 1 ) / $mod) -eq [math]::Floor(($CN) / $mod)) -and (($nodes[$CN].CurrentRun) -le $mr -or ($nodes[$CN].DirPath[-1] -ne "E"))){
                $nextoptions += [PSCustomObject]@{
                    Index = $n
                    PreviousNode = $CN
                    Dir = "E"
                }
            }
            #West
            $n = $CN -1 
            #If(($n -notin $visitednodes) -and ([math]::Floor(($CN - 1 ) / $mod) -eq [math]::Floor(($CN) / $mod)) -and (($nodes[$CN].CurrentRun) -le $mr -or ($nodes[$CN].DirPath[-1] -ne "W"))){
            If(([math]::Floor(($CN - 1 ) / $mod) -eq [math]::Floor(($CN) / $mod)) -and (($nodes[$CN].CurrentRun) -le $mr -or ($nodes[$CN].DirPath[-1] -ne "W"))){
                $nextoptions += [PSCustomObject]@{
                    Index = $n
                    PreviousNode = $CN
                    Dir = "W"
                }
            }
            
            #remove 0 from next options?
            $nextoptions = $nextoptions | ?{$_.Index -ne 0}

            #eliminate duplicates in nextoptions
            #$nextoptions = $nextoptions |select -Unique

            #Write-Host ("Pause")
            foreach($optobj in $nextoptions){
                $opt = $optobj.Index
                $PN = $optobj.PreviousNode
                if ( ($nodes.$Opt.Visited -eq $false) -and ($nodes[$PN].CostofPath + $nodes[$Opt].CostofNode -lt $nodes[$opt].CostofPath)){
                    #write-host("{0} + {1} = {2}" -f ($nodes[$PN].CostofPath),($nodes[$opt].CostofNode),(($nodes[$opt].CostofNode)+($nodes[$PN].CostofPath)))
                    $nodes[$opt].CostofPath = [int](($nodes[$PN].CostofPath) + ($nodes[$opt].CostofNode))
                    $nodes[$opt].Path = $Nodes[$PN].Path
                    #$nodes[$opt].Path += $PN
                    $nodes[$opt].Path += $opt
                } 
            }
            #Get the lowest cost node
            
            $lowest = ($nodes.Values |?{$_.visited -eq $false}|sort CostofPath)[0].Index
            

            Write-host ("Node: {0} ({1},{2})  {3:p2}" -f $lowest,$nodes[$lowest].X,$nodes[$lowest].y, ($visitednodes.count / ($nodes.count -1)))
            
            $nodecheckorder += $lowest # troubleshooting only.
            #adjust CN 
            #$CN = $nodes[$lowest].Path[-1]
            $PP = $nodes[$lowest].path

            $CN = $nodes[$lowest].Path[$pp.count -2]

            #Mark as visited
            $nodes[$lowest].Visited = $true
            $visitednodes += $lowest
            $unvisitednodes = $unvisitednodes|?{$_ -ne $lowest}
            #Update Path for that node
            #$nodes[$lowest].Path += ($nodes[$CN].Path)
            #$nodes[$lowest].Path += $lowest

            switch ($lowest) {
                ($CN + 1) { $dirtraveled = "E";break }
                ($CN + $maxcol+ 1) {$dirtraveled = "S";break}
                ($CN - ($maxcol + 1)) {$dirtraveled = "N";break}
                ($CN -1)  {$dirtraveled = "W";break}
                Default {}
            }


            <# #get direction traveled 
            if($CN + 1 -eq $lowest){
                #traveled East
                $dirtraveled = "E"
            }
            if($CN -1 -eq $lowest){
                #traveled West
                $dirtraveled = "W"
            }
            if($CN + $maxcol+ 1 -eq $lowest){
                #traveled South
                $dirtraveled = "S"
            }
            if($CN - ($maxcol + 1) -eq $lowest){
                #Traveled North
                $dirtraveled = "N"
            } #>
            
            


            #$dirtraveled = $lowestobj.dir
            #Write-host ("LowestObjDir: {0} = DirTraveled:{1} -- {2}" -f $lowestobj.dir,$dirtraveled, ($lowestobj.dir -eq $dirtraveled))
            $Nodes[$lowest].DirPath += $nodes[$CN].dirpath + $dirtraveled
            #$Nodes[$lowest].Path += $lowest

            #Do we need to increment Current Run?
            if($nodes[$CN].DirPath[-1] -eq $dirtraveled){
                $nodes[$lowest].CurrentRun = $nodes[$CN].CurrentRun + 1
            }Else{
                $nodes[$lowest].CurrentRun = 1
            }
            
            Write-host("  Moved {0} to {1} :{2} CurrentRun:{3}" -f $CN,$lowest,$dirtraveled,$nodes[$lowest].CurrentRun)
            Write-Host("  {0}" -f ($nodes[$lowest].path -join ","))
            Write-host("  {0}" -f ($nodes[$lowest].dirpath -join " "))
            #remove the processed node ($lowest) from the list of nextoptions
            $nextoptions = @($nextoptions | ?{$_.Index -ne $lowest})
            #make lowest the new CN
            $CN = $lowest
        
        <# if($unvisitednodes.count -le 10){
            Write-host ("Pause")
        } #>
        
        }While (($nextoptions.count -gt 0) -and ($unvisitednodes.count -gt 1) -and ($lowest -ne ($nodes.count -1) ))      
        #}
        
            
        $nodes
        Write-host ("Solution Part 1: {0}" -f ($nodes[($nodes.count -1)].CostofPath + $nodes[($nodes.count -1)].CostofNode))
        write-host ("Pause")
    }
}
Function D16{
    [CmdletBinding(DefaultParameterSetName = 'A')]
    Param(
        [Parameter(ParameterSetName = "A")]
        [Switch] $A,

        # Parameter help description
        [Parameter(ParameterSetName = "B")]
        [Switch]
        $B,

        $x,
        $y,
        $IND,
        $Dir,
        $Score
    )
    Begin{

        $ox = $x
        $oy = $y
        $oIND = $IND
        $oDir = $Dir
        

        switch ($PsCmdlet.ParameterSetName) {
            A {
                Write-host "ParameterSet A"
                $data = Get-Content .\Day_16\Input_test.txt
            }
            B {
                Write-host "ParameterSet B"
                $data = Get-Content .\Day_16\Input.txt
            }
            Default {}
        }

        #build has board as hash
        $bd = @{}
        
        $maxcol = $data[0].length -1
        $maxrow = $data.count -1
        for($y = 0;$y -le $maxrow;$y++){
            $currow = $data[$y].tochararray()
            for($x = 0;$x -le $maxcol;$x++){
                $v = $currow[$x]
                if($v -ne "."){
                    $coord = ("{0},{1}" -f $x,$y)
                    $bd.add($coord,$v)
                }
            }
        }
        #write-host ("Board Built")
        $heads = @{}
        $headindex = 1
        
        if($x -ne $null){
            $heads.Add($headindex, [PSCustomObject]@{
                X = $ox
                Y = $oy
                IND = $oIND
                Dir = $oDir
            })
        }
        Else{     
            #Create initial snake head
            
            $heads.Add($headindex, [PSCustomObject]@{
                X = 0
                Y = 0
                IND = $headindex
                Dir = "East"
            })
        }   
        $headindex++

        #write-host("Heads Created")
        #Create Visited Hash
        $visited = @{}
        
        

        While($heads.Keys.count -ne 0){
            #snake heads exist
            $snakekeys = $heads.Keys
            foreach($snakekey in $snakekeys){
                $s = $heads[$snakekey]
                #Write-host (" Index: {0}  ({1},{2}) Moving: {3}" -f $s.ind,$s.x,$s.y,$s.Dir)    
            
                

                #check to see if position is valid
                $validposition = $true
                if($s.x -gt $maxcol -or $s.x -lt 0){$validposition = $false}
                if($s.y -gt $maxrow -or $s.y -lt 0){$validposition = $false}

                #check to see if we've already been down this path
                $coord = ("{0},{1}" -f $s.x,$s.y)
                
                if($visited.ContainsKey($coord)){
                    if($s.dir -in $visited.$coord){
                        #been there done that.
                        
                        $validposition = $false
                    }
                    else{
                        $visited.$coord += $s.dir
                    }
                }
                else{
                    $visited.add($coord,@($s.dir)) 
                }
                if(!$validposition){
                    #not a valid move -kill the snake
                    $heads.remove($s.IND)
                }
                else{
                    #process the action for the new square.
                    #write-host "Need to take action"
                    $Action = $bd[("{0},{1}" -f $s.x,$s.y)]
                    switch ($Action) {
                        "|" {
                            if($s.dir -eq "East" -or $s.dir -eq "West"){
                                #split
                                $heads.Add($headindex, [PSCustomObject]@{
                                    X = $s.x
                                    Y = $s.y - 1
                                    IND = $headindex
                                    Dir = "North"
                                })
                                $headindex++
                                $heads.Add($headindex, [PSCustomObject]@{
                                    X = $s.x
                                    Y = $s.y + 1
                                    IND = $headindex
                                    Dir = "South"
                                })
                                $headindex++
                                #remove old head
                                $heads.remove($s.IND)
                            }
                            else{
                                #keep moving
                                switch ($s.Dir) {
                                    "North" {
                                        $s.y--
                                      }
                                    "South" {
                                        $s.y++
                                      }
                                    "East" {
                                        $s.x++
                                      }
                                    "West" {
                                        $s.x--
                                      }
                                    
                                }#end of keep moving
                            }
                        }
                        "-" {
                            if($s.dir -eq "North" -or $s.dir -eq "South"){
                                 #split
                                 $heads.Add($headindex, [PSCustomObject]@{
                                    X = $s.x -1
                                    Y = $s.y
                                    IND = $headindex
                                    Dir = "West"
                                })
                                $headindex++
                                $heads.Add($headindex, [PSCustomObject]@{
                                    X = $s.x + 1
                                    Y = $s.y
                                    IND = $headindex
                                    Dir = "East"
                                })
                                $headindex++
                                #remove old head
                                $heads.remove($s.IND)
                            }
                            else{
                                #keep moving
                                switch ($s.Dir) {
                                    "North" {
                                        $s.y--
                                      }
                                    "South" {
                                        $s.y++
                                      }
                                    "East" {
                                        $s.x++
                                      }
                                    "West" {
                                        $s.x--
                                      }
                                    
                                }#end of keep moving
                            }
                        }
                        "/" {
                            switch ($s.Dir) {
                                "North" {
                                    $s.x++ ; $s.Dir = "East"
                                }
                                "South" {
                                    $s.x--; $s.Dir = "West"
                                }
                                "East"  {
                                    $s.y-- ; $s.Dir = "North"
                                }
                                "West"  {
                                    $s.y++ ; $s.Dir = "South"
                                }
                            }
                            
                        }
                        "\" {
                            switch ($s.Dir) {
                                "North" {
                                    $s.x--; $s.dir = "West"
                                  }
                                "South" {
                                    $s.x++; $s.dir = "East"
                                }
                                "East"  {
                                    $s.y++; $s.dir = "South"
                                }
                                "West"  {
                                    $s.y--; $s.dir = "North"
                                }
                            }
                        }
                        Default {
                            #keep moving
                            switch ($s.Dir) {
                                "North" {
                                    $s.y--
                                  }
                                "South" {
                                    $s.y++
                                  }
                                "East" {
                                    $s.x++
                                  }
                                "West" {
                                    $s.x--
                                  }
                                
                            }#end of keep moving
                        }
                    }#end of action switch
                
                #write-host ("New Position: ({0},{1}) going {2}" -f $s.x,$s.y,$s.Dir)
                }
            }#snake key loop


        }#while heads exist loop
        
        #Write-host ("Walking the Path is done.")
        $cleansposts = @{}
        $visitedspots = $visited.Keys
        foreach($vs in $visitedspots){
            [int]$x = $vs.split(",")[0]
            [int]$y = $vs.split(",")[1]
            $validposition = $true
                if($x -gt $maxcol -or $x -lt 0){$validposition = $false}
                if($y -gt $maxrow -or $y -lt 0){$validposition = $false}
            if($validposition){
                #$visitedspots.remove("$vs")
                $cleansposts.add($vs,$true)
            }
            
        }#end of visisted spot clean-up loop.
    
        $visitedspotscount = $cleansposts.Count
        #write-host ("Answer Part 1: {0}" -f $visitedspotscount)
    
        [PSCustomObject]@{
            x = $ox
            y = $oy
            IND = $oIND
            Dir = $oDir
            Score = $visitedspotscount
        }
    }

}
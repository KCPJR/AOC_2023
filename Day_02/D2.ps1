Function D2{
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
                $data = Get-Content .\Day_02\Input_test.txt
            }
            B {
                Write-host "ParameterSet B"
                $data = Get-Content .\Day_02\Input.txt
            }
            Default {}
        }

        #data parse
        #$i = 0
        #$Gamedata = $data[$i]
        $game = @()
        foreach($gamedata in $data){
            
            $gidt1 = $Gamedata.Substring($gamedata.indexof(" ")+1)
            $gid = $gidt1.Substring(0,$gidt1.indexof(":"))
            #write-host ("Game ID: {0}" -f $gid)
            $gd = $gamedata.Substring($gamedata.indexof(":") + 1)
            #write-host ("  {0}" -f $gd)
            $pulls = $gd.split(";")
            $round = @()
            $colpicks = @()
            foreach($pull in $pulls){
                #write-host("    {0}" -f $pull)
                $picks = $pull.split(",")
                
                $red = 0;$blue = 0;$green = 0
                foreach($pick in $picks){
                    $picktrimmed = $pick.TrimStart()
                    $blockcount = $picktrimmed.Substring(0,$picktrimmed.indexof(" "))
                    $Color = $picktrimmed.substring($picktrimmed.indexof(" ") +1)
                #    write-host ("     Color: {0} Qty: {1}" -f $color,$blockcount)
                    
                    switch ($color) {
                        "blue" {$blue = $blockcount  }
                        "green" {$green = $blockcount}
                        "red" {$red = $blockcount}
                        Default {}
                    }
                    
                    
                    }
                    
                    $colpicks += [PSCustomObject]@{
                        "blue" = [int]$blue
                        "green" = [int]$green
                        "red" = [int]$red
                    }
                }
                #$round += [PSCustomObject]@{
                #    Round = $colpicks
                #}    
            $game += [PSCustomObject]@{
                GameID = [int]$gid
                Round = $colpicks
                }
            }#game parse loop           
        $game
        
        #Analysis Section
        $maxred = 12
        $maxblue = 14
        $maxgreen = 13
        
        $totalgoodgames = 0
        $index = 0
        $sumofcubes = 0
        Foreach($g in $game){
            $bad = $false
            $biggestred = 0; $biggestblue = 0; $biggestgreen = 0
            $vstring = $data[$index]
            Write-Verbose("")
            write-verbose("{0}" -f $vstring )
            $g|select -ExpandProperty Round|%{
                #Write-Verbose ("Blue {0} is less than {1} : {2}" -f $_.blue, $maxblue, ($_.blue -lt $maxblue))
                if($_.blue -gt $maxblue){$bad = $true}
                if($_.blue -gt $biggestblue){$biggestblue = $_.blue}
                #Write-Verbose ("  Bad is {0}" -f $bad)
            }

            $g|select -ExpandProperty Round|%{
                #Write-Verbose ("Red {0} is less than {1} : {2}" -f $_.red, $maxred, ($_.blue -lt $maxred))
                if($_.red -gt $maxred){$bad = $true}
                if($_.red -gt $biggestred){$biggestred = $_.red}
                #Write-Verbose ("  Bad is {0}" -f $bad)
            }
            
            $g|select -ExpandProperty Round|%{
                #Write-Verbose ("Green {0} is less than {1} : {2}" -f $_.green, $maxgreen, ($_.green -lt $maxgreen))
                if($_.green -gt $maxgreen){$bad = $true}
                if($_.green -gt $biggestgreen){$biggestgreen = $_.green}
                #Write-Verbose ("  Bad is {0}" -f $bad)
            }

            if(!$bad){
                #Write-Verbose ("Game {0} is good" -f $g.GameID)
                $totalgoodgames += [int]$g.GameID
            }
            else{
                #Write-Verbose ("Game {0} is bad" -f $g.GameID)
            }
            $index++
            Write-Verbose ("Game {0} Minimums Blue:{1} Green:{2} Red:{3}" -f $g.GameID, $biggestblue, $biggestgreen, $biggestred)
            $cube = $biggestred * $biggestblue * $biggestgreen
            $sumofcubes += $cube
            Write-Verbose (" Cube: {0}  Running Total: {1}" -f $cube, $sumofcubes)
        }
        Write-host ("Answer Part 1: {0}" -f $totalgoodgames)
        Write-host ("Answer Part 2: {0}" -f $sumofcubes)
    }
}
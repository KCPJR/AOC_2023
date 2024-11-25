function Rotate-Data {
    [CmdletBinding()]
    param (
        $bdata,

        [Parameter(ParameterSetName = "CW")]
        [Switch] $CW,

        [Parameter(ParameterSetName = "CCW")]
        [Switch]
        $CCW
    )
    
    begin {
     
        $mci = $bdata.length -1
        $mri = $bdata.count -1
        #write original
        #foreach($row in $bdata){write-host ("{0}" -f ($row -join ""))}
        $new = @()
        
        switch ($PsCmdlet.ParameterSetName) {
            CW {
                #Write-host "Rotate Clockwise"
                for($x = 0;$x -le $mci;$x++){
                    $te = @()
                    for($y = $mri;$y -ge 0;$y--){
                        $te += $bdata[$y][$x]
                    }
                    $new += ,$te
                }
            }
            CCW {
                #Write-host "Rotate Counter Clockwise"
                for($x = $mri;$x -ge 0;$x--){
                
                    $te = @()
                    for($y = 0;$y -le $mci;$y++){
                    
                        $te += $bdata[$y][$x]
                    }
                    $new += ,$te
                }
            }
            Default {}
        }

        
        #write the rotation to host
        <# $new|%{
            #write-host ("{0}" -f($_ -join ""));
            $_
        } #>
        $new
    }
}

function Tilt-Board {
    [CmdletBinding()]
    param (
        $data 
    )
    
    begin {
        $maxcolindex = $data[0].count -1
        $Tilted = @()
        for($i = 0;$i -le $maxcolindex;$i++){
            #$i = 9
            
            $ostr = $data[$i] -join ""
            $wstr = $data[$i] -join ""
            $tempstr = ""
    
            $substart = 0
            #write-host ("{0}" -f $ostr)
            #Set-Content .\day_14\TestOut.txt -Value ($cols[$i] -join "")
            #While ($substart -le $maxrowindex){
            While ($wstr.length -gt 0){
            
            switch ($wstr[$substart]) {
                "#" {
                    $tempstr += "#"
                    $wstr = $wstr.Substring(1)
                    $substart = 0 
                }
                Default {
                    
            
                    $subend = $wstr.indexof("#")
                    if($subend -eq -1){$subend = $wstr.length }
                    $substr = $wstr.substring($substart,$subend)
                    $substrl = $substr.Length
                    $substr = $substr.replace(".","")
                    $substrl2 = $substr.length
                    $substr = $substr + ("." * ($substrl - $substrl2))
                    $tempstr += $substr
                    #Write-Host ("{0}" -f $substr)
                    $wstr = $wstr.Substring($subend)
                    $substart = 0
                    break
                }
            }
    
            }
            $Tilted += ,($tempstr.ToCharArray())
    
        }

        #Write-host ("Pause Tilt-Board")
        $Tilted


    }
    
}

Function D14B{
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
                $data = Get-Content .\Day_14\Input_test.txt
            }
            B {
                Write-host "ParameterSet B"
                $data = Get-Content .\Day_14\Input.txt
            }
            Default {}
        }
        $cyclestodo = 1000
        
        Set-Content .\day_14\TestOut.txt -Value $null
        $maxcolindex = $data[0].length -1
        $maxrowindex = $data.count -1
        $d = @()
        $cols = @()
        $colsstr = @()
        for($i = 0;$i -le $maxrowindex;$i++){
            $d += ,($data[$i].ToCharArray())
        }
        

        $dirs = @("North","West","South","East")
        #$dirindex = 1
        $cyclecount = 0
        $board = Rotate-Data -bdata $d -CCW
        $displayDir = 3 
        $dirindex = 0
        While($cyclecount -lt $cyclestodo){
            $cyclecount++
            
            
            
            
            for($steps = 1;$steps -le 4;$steps++){
                
                #Write-host ("Tilting {0}" -f ($dirs[$dirindex % 4]))
                $board = Tilt-Board -data $board
                
                $board = Rotate-Data -bdata $board -CW
                $dirindex++;$displayDir++
            }

            
        Write-host ("Cycle {0} -- Complete" -f $cyclecount)
        #$board = Tilt-Board -data $board
        
        #Write-host ("Pause")
        $board = Rotate-Data -CW -bdata $board
        $dirindex++;$displayDir++
        #Write-host ("Displaying {0}" -f ($dirs[$displayDir % 4]))
        #foreach($row in $board){write-host ("{0}" -f ($row -join ""))}
    
        #Calculate Score at end of cycle
            $Cyclescore = 0
            For($sri = $maxrowindex;$sri -ge 0;$sri--){
                $countRocks = ($board[($maxrowindex - $sri)]|?{$_ -eq "O"}).count
                $weightfactor = $sri + 1
                $rowscore = $weightfactor * $countrocks
                #Write-host ("Row:{0}  Count:{1} Score:{2}" -f ($maxrowindex - $sri),$countRocks,$rowscore)
                $Cyclescore += $rowscore
            }            
            Write-host ("Cycle {0} Score: {1}" -f $cyclecount, $Cyclescore)
            #write board to string in log
                Add-Content .\day_14\TestOut.txt -Value ("{0}`t{1}" -f $cyclecount,  $Cyclescore)

        #correcting after display
        $board = Rotate-Data -CCW -bdata $board
        $dirindex--;$displayDir--

    }
    $board = Rotate-Data -CW -bdata $board
    $dirindex++;$displayDir++    
    foreach($row in $board){write-host ("{0}" -f ($row -join ""))}

    }
}
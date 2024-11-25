Function D16B{
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
                $data = Get-Content .\Day_16\Input_test.txt
            }
            B {
                Write-host "ParameterSet B"
                $data = Get-Content .\Day_16\Input.txt
            }
            Default {}
        }

        $maxcol = $data[0].length -1
        $maxrow = $data.count -1
        $sims = @()
        for($x = 0; $x -le $maxcol;$x++){
            $sims += [PSCustomObject]@{
                x = $x
                y = 0
                IND = 1
                Dir = "South"
                Score  = 0
            }
            $sims += [PSCustomObject]@{
                x = $x
                y = $maxrow
                IND = 1
                Dir = "North"
                Score = 0
            }
        }
        For($y = 0; $y -le $maxrow; $y++){
            $sims += [PSCustomObject]@{
                x = 0
                y = $y
                IND = 1
                Dir = "East"
                Score = 0
            }
            $sims += [PSCustomObject]@{
                x = $maxcol
                y = $y
                IND = 1
                Dir = "West"
                Score = 0
            }
        }

        #collection of starting positions created.
        set-content .\Day_16\out.txt -Value $null
        $results = @()
        $q = 0
        $qmax = $sims.count
        foreach($sim in $sims){
            $splat = @{
                ($PsCmdlet.ParameterSetName) = $true
                X = $sim.x
                Y = $sim.y
                IND = $sim.IND
                Dir = $sim.Dir
            }
            $results += d16 @splat
            write-host ("Returned: {0}" -f $sim.Score)
            Add-Content .\Day_16\out.txt -Value ("{0} ({1},{2}) {3}  Returned: {4}" -f $q,$sim.x,$sim.y, $sim.Dir,$results[$q].Score)
            $q++
        }#end of sims loop

        write-host ("Pause")
        $maxscore = ($results.Score |sort -Descending )[0]
        write-host ("Answer Part 2: {0}" -f $maxscore)
        
    }
}
Function D6{
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
                $data = Get-Content .\Day_06\Input_test.txt
            }
            B {
                Write-host "ParameterSet B"
                $data = Get-Content .\Day_06\Input.txt
            }
            Default {}
        }

        
            $timelimit =($data[0].split(":"))[1].split(" ")|?{$_ -ne ""}
            $record = ($data[1].split(":"))[1].split(" ")|?{$_ -ne ""}
            
            $races = @()
            $i=0
            foreach($t in $timelimit){
                $races += [PSCustomObject]@{
                    TimeLimit = [int]$timelimit[$i]
                    Record = [int]$record[$i]
                    Min = $null
                    Max = $null
                    Winners = $null
                    Ct_Win = $null
                }
                $i++
            }
            
            $i = 0
            foreach($race in $races){
                [int]$a = -1
                [int]$b = [int]$race.TimeLimit
                [int]$c = -([int]$race.Record)
                
                $z = ($b * $b) - (4 * $a *$c)
                $y = [math]::sqrt($z)
                $p = (-$b - $y)/(2 * $a)
                $q = (-$b + $y)/(2 * $a) 

                $p = [math]::Floor($p)
                $q = [math]::Ceiling($q)

                #write-host(" {0} : {1} : {2} : {3}" -f $z,$y,$p,$q)
                $set = @($p,$q)
                [int]$race.min = @($set|sort)[0]
                [int]$race.max = @($set|sort)[1]
                
                #$k = -1 * $race.min * $race.min
                #$j = $race.min * $race.TimeLimit
                #$l = $race.record
                
                #write-host ("{0}  : {1} + {2}" -f $race.Record,(-$race.TimeLimit * $race.Min),($race.Min * $race.Min))
                #write-host ("{0}  : {1} + {2}" -f $l,$k,$j)
                if($race.Record -eq (($race.min * $race.TimeLimit) + ( -1 * $race.Min * $race.Min))){$race.min++;$race.Max--}
                
                $race.Winners = $race.min..$race.max
                $race.Ct_Win = $race.Winners.count
                
                
            }
        #$races
        $answerPart1  = 1
        foreach($race in $races){$answerPart1 = $answerPart1 * $race.Ct_Win}
        write-host  ("Answer Part 1: {0}" -f $answerPart1)
        
        #Part2
        $p2time = ($data[0].split(":"))[1].replace(" ","")
        $p2record = ($data[1].split(":"))[1].replace(" ","")
        Write-Host ("")
        write-host ("Part Two TimeLimit: {0}" -f $p2time)
        write-host ("Part Two Record: {0}" -f $p2record)

        [int]$a = -1
        [long]$b = [int]$p2time
        [double]$c = -[double]$p2record
        
        $z = ($b * $b) - (4 * $a *$c)
        $y = [math]::sqrt($z)
        $p = (-$b - $y)/(2 * $a)
        $q = (-$b + $y)/(2 * $a) 

        $p = [math]::Floor($p)
        $q = [math]::Ceiling($q)

        #write-host(" {0} : {1} : {2} : {3}" -f $z,$y,$p,$q)
        $set = @($p,$q)
        [long]$P2min = @($set|sort)[0]
        [long]$P2max = @($set|sort)[1]

        Write-host ("Part 2 Min: {0}" -f $P2min)
        Write-host ("Part 2 Max: {0}" -f $P2max)
        
        $P2WinCt = $p2max - $P2min +1
        Write-host ("Part 2 Answer: {0}" -f $P2WinCt)
    }


}
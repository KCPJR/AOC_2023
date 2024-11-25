Function D9{
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
                $data = Get-Content .\Day_09\Input_test.txt
            }
            B {
                Write-host "ParameterSet B"
                $data = Get-Content .\Day_09\Input.txt
            }
            Default {}
        }
        $AnswerPart1 = 0
        $AnswerPart2 = 0
        foreach($row in $data){
            $p = @()
            $rawint = @()
            $raw = @()
            $raw += $row.split(" ")
            $raw | % {$rawint += @([int]$_)}
            

        $p += ,($rawint)
        $rowindex = 1
        
        $test = $true
        $prevrow = $p[$rowindex - 1]
        ($prevrow | % { $test = ($_ -eq 0)-and $test}) 
        While( !$test){
        $newrow = @()
        $prevrow = $p[$rowindex -1]
        for($i = 1;$i -lt $prevrow.count;$i++){
            $newrow += $prevrow[$i] - $prevrow[$i -1]
        }
        $p += ,($newrow)
        $rowindex++
        $test = $true
        $prevrow = $p[$rowindex - 1]
        ($prevrow | % { $test = ($_ -eq 0)-and $test}) 
        }
        #have run history to zero
        
        #add zero to last row
        $p[-1] += 0
        
        #Work back up the chain
        #from rowcount -2 (n -1 th row index) to 0
        $Z = 0
        for($i = $p.count -2; $i -ge 0;$i--){
            #right side
            $index = $p[$i].count -1
            $p[$i] += ($p[$i + 1][$index] + $p[$i][$index])
        
            #left side
            
            #Y - Z = X
            $X = $p[$i][0] - $Z
            $Z = $X
        }
        #get extrapolation
        $AnswerPart1 += $p[0][-1]
        $AnswerPart2 += $X
        Write-Host ("Row Answer: {0} .. {1}" -f $X, $p[0][-1])
    }   #loop through each datarow from input
        
        Write-Host ("Answer Part 1: {0}" -f $AnswerPart1)
        Write-Host ("Answer Part 2: {0}" -f $AnswerPart2)
        #$p
        
    }
}
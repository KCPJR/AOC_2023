Function D4{
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
                $data = Get-Content .\Day_04\Input_test.txt
            }
            B {
                Write-host "ParameterSet B"
                $data = Get-Content .\Day_04\Input.txt
            }
            Default {}
        }
        $grandpoints = 0
        $cardwinners = @()
        $cardwinners += 0
        $cardcount = @()
        $origcardcount = $data.Count
        write-host ("Total Cards: {0}" -f $origcardcount)
        
        $stack = @()
        $stack += [PSCustomObject]@{
            Index = 0
            Matched = 0
            Qty = 0
        }
        (1..$origcardcount) | %{
            $stack += [PSCustomObject]@{
                Index = $_
                Matched = 0
                Qty = 1
            }
        }
        $rowindex = 1
        Foreach($row in $data){
            $tstr = $row.replace("  "," ")
            $tstr = $tstr.replace(" | "," ")
            $tstr = $tstr.substring($tstr.indexof(":")+1)
            Write-Host ("{0}" -f $tstr)
            $arr = $tstr.split(" ")
            #write-host ($tstr)
            $winnercount = @($tstr.split(" ")|group|?{$_.count -gt 1}).count
            write-host("  Winner Count: {0}" -f $winnercount)
            if($winnercount -gt 0)
                {
                    $score = [math]::Pow(2,$winnercount -1)
                    (1..$winnercount)|%{$stack[$rowindex + $_].Qty = $stack[$rowindex].Qty + $stack[$rowindex + $_].Qty}
                }
                else
                {
                    $score = 0
                }
            $grandpoints += $score
            Write-host ("  Score: {0}" -f $score)
            $stack[$rowindex].Matched = $winnercount
            $rowindex++
        }
        Write-Host ("Answer Part 1: {0}" -f $grandpoints)
        $totalcardQty = 0
        foreach($item in $stack){
            $totalcardQty += $item.Qty
        }
        Write-host ("Answer to Part 2: {0}" -f $totalcardQty)
        $stack
    }
}
Function D12{
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
                $data = Get-Content .\Day_12\Input_test.txt
            }
            B {
                Write-host "ParameterSet B"
                $data = Get-Content .\Day_12\Input.txt
            }
            Default {}
        }

        $g = @()
        foreach($r in $data){
            
            $spaceindex = $r.indexof(" ")
            write-host ("R: {0}" -f $r)
            
            $strarr = $r[0..($spaceindex -1 )] #str
            $str = $strarr -join ""
            $blocks = $r.Substring($spaceindex + 1).split(",") #arr of groups
            $blockstr = $blocks -join ","
            $nu = ($r.ToCharArray()|?{$_ -eq "?"}).count #num of unknown
            write-host  ("  Count of ?: {0}" -f $nu)
            $sum = ($blocks|measure -Sum).sum + $blocks.count -1
            $g += [PSCustomObject]@{
                strarr = $strarr
                str = $str
                blocks = $blocks
                blockstr = $blockstr
                nu = $nu
                SumBlocks = [int]$sum
                Length = $str.Length
            }


        }

        $g

    }
}
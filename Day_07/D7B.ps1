Function D7b{
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
                $data = Get-Content .\Day_07\Input_test.txt
            }
            B {
                Write-host "ParameterSet B"
                $data = Get-Content .\Day_07\Input.txt
            }
            Default {}
        }

        #parse data
        
        $cardpower."A" = 12
        $cardpower."K" = 11
        $cardpower."Q" = 10
        $cardpower."J" = 0
        $cardpower."T" = 9
        $cardpower."9" = 8
        $cardpower."8" = 7
        $cardpower."7" = 6
        $cardpower."6" = 5
        $cardpower."5" = 4
        $cardpower."4" = 3
        $cardpower."3" = 2
        $cardpower."2" = 1 

        $hands = @()
        
        Foreach($row in $data){
            $cards = $row.split(" ")[0]
            $cardsarr = $row.split(" ")[0].ToCharArray()
            $bid = $row.split(" ")[1]
            $type = 0
            $rank = 0

            $cg = $cards.ToCharArray()|group -NoElement | select -ExpandProperty count | sort -Descending
            $cgnoj = @($cards.ToCharArray()|?{$_ -ne "J"}|group -NoElement | select -ExpandProperty count | sort -Descending)
            $js = @($cards.ToCharArray()|?{$_ -eq "J"}).count
            $mod = $cgnoj[0] + $js
            switch ($mod) {
                5  {
                    #5 of a kind
                    $type = 6
                  }
                4 {
                    #4 of a kind
                    $type = 5
                }
                3 {
                    if($cg[1] -eq 2){
                        #Full house
                        $type = 4
                    }
                    else{
                        #3 of a kind
                        $type = 3
                    }
                }
                2 {
                    if($cg[1] -eq 2){
                        #two pair
                        $type = 2
                    }
                    else{
                        #one pair
                        $type = 1
                    }
                }
                1 {
                    #High card
                    $type = 0
                }  
                Default {}
            }# end of switch
           
            $v0 = $cardpower[$cardsarr[0].tostring()]
            $V1 = $cardpower[$cardsarr[1].tostring()]
            $V2 = $cardpower[$cardsarr[2].tostring()]
            $V3 = $cardpower[$cardsarr[3].tostring()]
            $V4 = $cardpower[$cardsarr[4].tostring()]
            $hands += [PSCustomObject]@{
                C = $cards
                Bid = $bid
                Type = $type
                Rank = 0
                
                V0 = $v0
                V1 = $v1
                V2 = $v2
                V3 = $v3
                V4 = $v4
            }

            $HR = @{}
            $HR.($handindex) = 0
            $RH = @{}
            $RH.$handindex = ""
        }#end of foreach row data parse
        $i = 1
        $Part1 = 0
        foreach($hand in $hands|sort type,v0,v1,v2,v3,v4){
            $hand.rank = $i
            $part1 += $i * $hand.Bid
            $i++
        }
        write-host ("Answer Part 1: {0}" -f $Part1)
        #$hands
    }
}
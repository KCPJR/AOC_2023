function Scrap {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
    $total = 0
    $data = Get-Content .\Day_18\map.txt
    foreach($row in $data){
        $char = $row.ToCharArray()
        $ct = ($char|?{$_ -eq "#"}).Count
        $total += $ct
    }
    write-host ("total: {0}" -f $total)

    }
    
    
        
    
}

Function Parse-Part2{
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
                $data = Get-Content .\Day_18\Input_test.txt
            }
            B {
                Write-host "ParameterSet B"
                $data = Get-Content .\Day_18\Input.txt
            }
            Default {}
        }

        $x = 0; $y = 0
        $map = @{}
        #$map.add("0,0",$true)
        $minx = 0; $miny = 0
        $maxx = 0; $maxy = 0
        $rawvert = @()
        $i = 0
        $edge = 0
        foreach($instr in $data){
            $tmp = $instr.split(" ")
            #$dir = $tmp[0]
            #$dist = $tmp[1]
            $hexstr = $tmp[2]
            #$edge += $dist
         
            write-host ("{0}" -f $hexstr)
            $hdist = $hexstr.Substring(2,5)
            $dist = [int32]"0x$hdist"
            $hdir = $hexstr.Substring(7,1)
            write-host ("  Dist: #{0} - > {1}" -f $hdist,$dist)
            write-host ("  Dir : {0}" -f $hdir)
        
            switch ($hdir) {
                0 { }#Right 
                1 { }#Down
                2 { }#Left
                3 { }#Up
                Default {}
            }
        }
            


    }
}
function Get-Hash {
    [CmdletBinding()]
    param (
        [string]$str
    )
    
    begin {
        $cv = 0

        Foreach($ch in $str.ToCharArray()){
            $asci = [int]$ch
            $cv = $cv + $asci
            $cv = $cv * 17
            $cv = $cv % 256
            
        }
        
        #Write-Host ("Hash Value: {0}" -f $cv)
        $cv
    }
    
}


Function D15A{
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
                $data = Get-Content .\Day_15\Input_test.txt
            }
            B {
                Write-host "ParameterSet B"
                $data = Get-Content .\Day_15\Input.txt
            }
            Default {}
        }
        $sums = 0
        $strs = $data.split(",")
        Foreach($str in $strs){
            $hv = Get-Hash -str $str
            $sums += $hv
        }

        Write-host ("Answer Part 1: {0}" -f $sums)
    }
}

Function D15B{
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
                $data = Get-Content .\Day_15\Input_test.txt
            }
            B {
                Write-host "ParameterSet B"
                $data = Get-Content .\Day_15\Input.txt
            }
            Default {}
        }
        $boxes = @()
        (0..255)|%{$boxes += [ordered]@{}}

        $strs = $data.split(",")
        foreach($str in $strs){
            
            if($str.IndexOf("=") -eq -1){
                #its a - not a =
                $label = ($str[0..($str.length - 2)] -join "" )
                $boxnum = (Get-Hash -str $label)
                $op = "-"
                $foclen = $null
            }
            else{
                $label = ($str[0..($str.length - 3)] -join "" )
                $boxnum = Get-Hash -str ($str.Split("=")[0])
                $op = "="
                $foclen = [int]$str.split("=")[1]
            }
        
            #Write-Host ("Box:{0} Op:{1} Label:{2} Focal Length:{3}" -f $boxnum,$op,$label,$foclen)

            switch ($op) {
                "-" {
                    $boxkeys = $boxes[$boxnum].keys
                    If($label -in $boxkeys)
                    {
                        $boxes[$boxnum].remove($label)
                        #Write-Host("  Removed {0} from Box {1}" -f $label, $boxnum)
                    }
                  }
                "=" {
                    $boxkeys = $boxes[$boxnum].keys
                    If($label -in $boxkeys)
                    {
                        $boxes[$boxnum].$label = $foclen
                        #write-host("  Replaced {0} in Box {1} with FL {2}" -f $label,$boxnum,$foclen)
                    }
                    else
                    {
                        $boxes[$boxnum].add($label,$foclen)
                        #Write-Host("  Added {0} {1} to Box {2}" -f $label,$foclen,$boxnum)
                    }
                  }
                Default {}
            }

        }
        #Final Calculations
        $Total = 0
        $i = 0
        foreach($box in $boxes){
            $bf = $i+1
            $slots = $box.GetEnumerator()
            $sindex = 1
            Foreach($slot in $slots){
                $fl = $slot.Value
                $Temp = $bf * $sindex * $fl
                Write-Host("{0} * {1} * {2} = {3}" -f $bf,$sindex,$fl,$Temp)
                $total += $Temp
                $sindex++
            }
            $i++
        }
        Write-host  ("Answer Part 2: {0}" -f $Total)

    }
}
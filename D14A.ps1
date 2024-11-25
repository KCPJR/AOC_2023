Function D14{
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
        $newmaprotated = @()
        $maxcolindex = $data[0].length -1
        $maxrowindex = $data.count -1
        $d = @()
        $cols = @()
        $colsstr = @()
        for($i = 0;$i -le $maxrowindex;$i++){
            $d += ,($data[$i].ToCharArray())
        }
        
        for($i = 0;$i -le $maxcolindex;$i++){
            $cols += ,($d|%{$_[$i]})
        }
        for($i = 0;$i -le $maxcolindex;$i++){
        #$i = 9
        
        $ostr = $cols[$i] -join ""
        $wstr = $cols[$i] -join ""
        $tempstr = ""

        $substart = 0
        #write-host ("{0}" -f $ostr)
        Set-Content .\day_14\TestOut.txt -Value ($cols[$i] -join "")
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
        $newmaprotated += ,($tempstr.ToCharArray())

    }
        for($i = 0;$i -lt $newmaprotated.count -1;$i++){
            $newmap += ,($newmaprotated|%{$_[$i]})
        }
        
        #Set-Content .\day_14\TestOut.txt -Value $null
        #Foreach($rowofdata in $newmap){
        #    Add-Content .\day_14\TestOut.txt -Value ($rowofdata -join "")
        #}

        $score = 0
        for($i = 0;$i -le $maxrowindex;$i++){
            $roundrockcount = ($newmap[$i]|?{$_ -eq "O"}).count
            $dist = $maxrowindex + 1 -$i
            $rowscore = $roundrockcount * $dist
            $score += $rowscore
        }

        #set-Content .\day_14\TestOut.txt -Value $newmap
        Write-host("Answer Part 1: {0}" -f $score)
    }
}
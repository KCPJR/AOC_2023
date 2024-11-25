Function D19{
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
                $data = Get-Content .\Day_19\Input_test.txt
            }
            B {
                Write-host "ParameterSet B"
                $data = Get-Content .\Day_19\Input.txt
            }
            Default {}
        }
        $WFs = @{}
        $rawrules = @()
        $i = 0
        
        #region Parse Input

        while ($data[$i] -ne ""){
            $rawrules += $data[$i]
            
        
            $str = $data[$i]
            $wfname = $str.Substring(0,($str.IndexOf("{"))) -join ""
            
            
            $bloc = $str.substring($str.indexof("{") +1,($str.length - $wfname.length -2))
            $steps = $bloc.split(",")
            $stepobjscol = @()
            foreach($step in $steps){
                if($step.indexof(":")-gt 1){
                    #its a rule
                    $attrib = $step[0]
                    $Operator = $step[1]
                    $colindex = $step.indexof(":")
                    $val = $step.substring(2,($colindex - 2))
                    $finally = $step.substring($colindex +1)
                    #write-host("pause")
                    $stepobjscol += [PSCustomObject]@{
                        Attrib = $attrib
                        Operator = $Operator
                        Value = $val
                        Finally = $finally
                    }
                }
                else{
                    #its the default
                    $finally = $step
                    $stepobjscol += [PSCustomObject]@{
                        Attrib = $null
                        Operator = $null
                        Value = $null
                        Finally = $finally
                    }
                }
            }
            #create the WorkFlow
            $WFs.add($wfname,$stepobjscol)
            $i++
        }
        $i++
        #region parse Parts data
            $parts = @()
            for($i; $i -lt $data.count;$i++){
                $str = $data[$i]
                $str = $str[1..($str.length -2)] -join ""
                $strarr = $str.split(",")
                    $px = $strarr[0].substring(2)
                    $pm = $strarr[1].substring(2)
                    $pa = $strarr[2].substring(2)
                    $ps = $strarr[3].substring(2)
                    
                $parts += [PSCustomObject]@{
                    X = $px
                    M = $pm
                    A = $pa
                    S = $ps
                    Total = [int]$px + [int]$pm + [int]$pa + [int]$ps
                    Str = $data[$i]
                    }
            }
            #endregion 
        #endregion
        #Write-host ("Pause")
        
        #$p = $parts[0]
        Foreach($p in $parts){

        $CWFname = "in"
        $WFPath = @()
        
        Do{
            $WFPath += $CWFname
            $CWFSteps = $WFs[$CWFname]
        :steploop foreach($step in $CWFSteps){
            
                switch ($step.Operator) {
                    "<" {
                        if([int]$p.($step.attrib) -lt [int]$step.Value){
                            $next = $step.Finally;
                            Break steploop
                        }  
                    }
                    ">" {
                        if([int]$p.($step.attrib) -gt [int]$step.Value){
                            $next = $step.Finally;
                            Break steploop
                        }  
                    }
                    Default {
                        $next = $step.Finally
                    }
                } #operator Switch
            
            
            }
            switch ($next) {
                A {$CWFname = ""; $WFPath += "A" ; $Grandtotal += $p.Total  }
                R {$CWFname = ""; $WFPath += "R" }
                Default {$CWFname = $next}
            } #$next switch
        
        } While ($CWFname -ne "" )
        Write-host( "{0}: {1}"  -f $p.Str,($WFPath -join " -> "))
        }
        
        #Write-host ("Pause")
        write-host ("Answer Part 1: {0}" -f $Grandtotal)
    }
}
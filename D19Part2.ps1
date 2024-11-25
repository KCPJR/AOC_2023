Function D19P2{
    [CmdletBinding(DefaultParameterSetName = 'A')]
    Param(
        [Parameter(ParameterSetName = "A")]
        [Switch] $Test,

        # Parameter help description
        [Parameter(ParameterSetName = "B")]
        [Switch]
        $ForReals
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
        $results = @()
        $WFs = @{}
        $rawrules = @()
        $i = 0
        $limits = @()
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
                        Value = [int]$val
                        Finally = $finally
                    }
                    $limits += [PSCustomObject]@{
                        Attribute = $attrib
                        Limit = [int]$val
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
        


        $limits
        $i++
        <# #region parse Parts data
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
            #endregion  #>
        #endregion
        #Write-host ("Pause")
        
        #$p = $parts[0]

        
        $i = 0
        $o = [PSCustomObject]@{
            ID = $i
            WF = "in"
            Xs = 1
            Xf = 4000
            Ms = 1
            Mf = 4000
            As = 1
            Af = 4000
            Ss = 1
            Sf = 4000
            Result = ""
            Size = 1
        }
        $i++

        $Q = @()
        $Q += $o
        
        While($Q.count -gt 0){
            $cur = $Q[0]
            $cwf = $WFs[$Q[0].WF]    
            if($cur.WF -eq "A"){
                $cur.Result = $true
                $cur.Size = ($cur.xf - $cur.xs +1) * ($cur.Mf - $cur.Ms +1) * ($cur.Af - $cur.As +1) *($cur.Sf - $cur.Ss +1)
                $results += $cur
                $cwf = @()
            }   
            if($cur.WF -eq "R"){
                $cur.Result = $false
                $cur.Size = ($cur.xf - $cur.xs +1) * ($cur.Mf - $cur.Ms +1) * ($cur.Af - $cur.As +1) *($cur.Sf - $cur.Ss +1)
                $results += $cur
                $cwf = @()
            }

            foreach($rule in $cwf){
               
                switch ($rule.operator) {
                    "<" {
                        $attrib = $rule.attrib
                        $startA = $cur.("{0}s" -f $attrib)
                        $finishA = $rule.Value -1 
                        $startB = $rule.Value
                        $finishB = $cur.("{0}f" -f  $attrib)
                        if($Attrib -ne "X"){$xs = $cur.Xs; $xf = $cur.xf}Else{$xs = $starta;$Xf = $finisha}
                        if($attrib -ne "M"){$Ms = $cur.Ms; $Mf = $cur.Mf}Else{$Ms = $starta;$Mf = $finisha}
                        if($attrib -ne "A"){$As = $cur.As; $Af = $cur.Af}Else{$As = $starta;$Af = $finisha}
                        if($attrib -ne "S"){$Ss = $cur.Ss; $Sf = $cur.Sf}Else{$Ss = $starta;$Sf = $finisha}
                        $q += [PSCustomObject]@{
                            ID = $i
                            WF = $rule.Finally
                            Xs = $xs
                            Xf = $xf
                            Ms = $Ms
                            Mf = $Mf
                            As = $As
                            Af = $Af
                            Ss = $Ss
                            Sf = $Sf
                            Result = ""
                            Size = 0
                        }
                        $i++
                        
                        if($Attrib -ne "X"){$xs = $cur.Xs; $xf = $cur.xf}Else{$xs = $startb;$Xf = $finishb}
                        if($attrib -ne "M"){$Ms = $cur.Ms; $Mf = $cur.Mf}Else{$Ms = $startb;$Mf = $finishb}
                        if($attrib -ne "A"){$As = $cur.As; $Af = $cur.Af}Else{$As = $startb;$Af = $finishb}
                        if($attrib -ne "S"){$Ss = $cur.Ss; $Sf = $cur.Sf}Else{$Ss = $startb;$Sf = $finishb}
                        $cur.Xs = $xs
                        $cur.Xf = $xf
                        $cur.Ms = $Ms
                        $cur.Mf = $Mf
                        $cur.As = $As
                        $cur.Af = $Af
                        $cur.Ss = $Ss
                        $cur.Sf = $Sf
                        
                        }
                        #$p1 = $cur.("{0}f" -f $rule.attrib) = 
                      
                    ">" {
                        $attrib = $rule.attrib
                        $startB = $cur.("{0}s" -f $attrib)
                        $finishB = $rule.Value  
                        $startA = $rule.Value + 1
                        $finishA = $cur.("{0}f" -f  $attrib)
                        if($Attrib -ne "X"){$xs = $cur.Xs; $xf = $cur.xf}Else{$xs = $starta;$Xf = $finisha}
                        if($attrib -ne "M"){$Ms = $cur.Ms; $Mf = $cur.Mf}Else{$Ms = $starta;$Mf = $finisha}
                        if($attrib -ne "A"){$As = $cur.As; $Af = $cur.Af}Else{$As = $starta;$Af = $finisha}
                        if($attrib -ne "S"){$Ss = $cur.Ss; $Sf = $cur.Sf}Else{$Ss = $starta;$Sf = $finisha}
                        $q += [PSCustomObject]@{
                            ID = $i
                            WF = $rule.Finally
                            Xs = $xs
                            Xf = $xf
                            Ms = $Ms
                            Mf = $Mf
                            As = $As
                            Af = $Af
                            Ss = $Ss
                            Sf = $Sf
                            Result = ""
                            Size = 0
                        }
                        $i++
                        
                        if($Attrib -ne "X"){$xs = $cur.Xs; $xf = $cur.xf}Else{$xs = $startb;$Xf = $finishb}
                        if($attrib -ne "M"){$Ms = $cur.Ms; $Mf = $cur.Mf}Else{$Ms = $startb;$Mf = $finishb}
                        if($attrib -ne "A"){$As = $cur.As; $Af = $cur.Af}Else{$As = $startb;$Af = $finishb}
                        if($attrib -ne "S"){$Ss = $cur.Ss; $Sf = $cur.Sf}Else{$Ss = $startb;$Sf = $finishb}
                        $cur.Xs = $xs
                        $cur.Xf = $xf
                        $cur.Ms = $Ms
                        $cur.Mf = $Mf
                        $cur.As = $As
                        $cur.Af = $Af
                        $cur.Ss = $Ss
                        $cur.Sf = $Sf
                        
                        }
                    
                    Default {
                        $q += [PSCustomObject]@{
                            ID = $i
                            WF = $rule.Finally
                            Xs = $xs
                            Xf = $xf
                            Ms = $Ms
                            Mf = $Mf
                            As = $As
                            Af = $Af
                            Ss = $Ss
                            Sf = $Sf
                            Result = ""
                            Size = 0
                        }
                        $i++
                        #$q = @($q|?{$_.ID -ne $cur.ID})
                    }
                }#end operator switch
                #switch



            }
            $Q = $Q | ?{$_.ID -ne $Q[0].ID}

        }

        Write-host ("Tallying the results")
        $results | ?{$_.Result -eq $true}|% { $Grandtotal += $_.Size}
        

       foreach($r in $results){
        write-host ("{0}`t X:({1}..{2})`tM:({3}..{4})`tA:({5}..{6})`tS:({7}..{8})" -f $r.Result,$r.xs,$r.xf,$r.Ms,$r.mf,$r.as,$r.af,$r.ss,$r.sf)
       }        
       write-host ("Anwer Part 2: {0}" -f $Grandtotal)
       Write-host ("BIG PAUSE")
       $results
    }
}
Function D1{
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
                #$data = Get-Content .\Day_01\Input_test.txt
                
            }
            B {
                Write-host "ParameterSet B"
                $data = Get-Content .\Day_01\Input.txt
                #$data = Get-Content .\Day_01\Input_test2.txt
            }
            Default {}
        }
        
        $digits = ('0','1','2','3','4','5','6','7','8','9')
        
        $tally = 0
        #$rowarray = $data[1]
        $rowindex = 0
        foreach($rowarray in $data){
            $rawrow = $rowarray
            write-host ("Row Index: {0}" -f $rowindex)
            write-host ("{0}" -f $rawrow)
            $i = 0
            
            If($PsCmdlet.ParameterSetName -eq 'B'){
                $k = 0
                While ($k -le $rowarray.length){
                $substr = $rowarray.Substring($k)
                    switch -wildcard ($substr) {
                    "zero*" {$rowarray = $rowarray.Replace("zero","z0ro");break}
                    "one*" {$rowarray = $rowarray.Replace("one","o1e");break }
                    "two*" {$rowarray = $rowarray.Replace("two", "t2o");break}
                    "three*" {$rowarray = $rowarray.Replace("three","t3ree");break}
                    "four*" {$rowarray = $rowarray.Replace("four","f4ur");break}
                    "five*" {$rowarray = $rowarray.Replace("five","f5ve");break}
                    "six*" {$rowarray = $rowarray.Replace("six","s6x");break}
                    "seven*" {$rowarray = $rowarray.Replace("seven","s7ven");break}
                    "eight*" {$rowarray = $rowarray.Replace("eight","e8ght");break}
                    "nine*" {$rowarray = $rowarray.Replace("nine","n9ne");break}
                    Default {}
                }
                $k++         
                
                }
            }
            
            while ($rowarray[$i] -notin $digits){
                #Write-Verbose ("Character: {0} - Digit: False" -f $rowarray[$i])
                $i++
            }
            $first = $rowarray[$i]
            #write-host ("First: {0}" -f $first)
            
            $j = $rowarray.length -1
            While ($rowarray[$j] -notin $digits) {
                #Write-Verbose ("Char: {0} -Digit: False" -f $rowarray[$j])
                $j--
            }
            $last = $rowarray[$j]
           
            #Write-host ("Last: {0}" -f $last)
            [int32]$tempnumber = $first + $last
            
            write-host ("Number: {0}" -f $tempnumber)
            $tally += $tempnumber
            write-host ("Running Total: {0}" -f $tally)
            write-host ("")
            $rowindex++
        }   
        
        Write-host ("Answer: {0}" -f $tally)
    }
}
function test-scrap {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        
    $data = Get-Content .\Day_17\Input_test.txt
    $row = $data[0]

    $rowch = $row.tochararray()
    $arr = @()
    foreach($ch in $rowch){
        $temp = [int]($ch -join "") + 1
        #write-host ("{0}" -f $temp)
    
    $arr += [PSCustomObject]@{
         Orig = $ch
         Int = [int]($ch -join "")
         Intplus = [int]($ch -join "") + 1
         Intzero = [int]($ch -join "") + 1 -1
    }
    }

    foreach($item in $arr){
        Write-Host ("{0} -- {1} + 1 = {2}" -f $item.Orig, $item.int, ($item.int + 1))
    }
    write-host ("pause")
    }
    
    
}


function Helper-Sim {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        $x = 0; $y = 0;
        
        
        do{
            $i = $Host.UI.RawUI.ReadKey()
            switch ($i.Character) {
            "n" {$y--}
            "s" {$y++}
            "e" {$x++}
            "w" {$x--}
            Default {}
        }
        
        write-host ("{3} to ({0},{1}) : {2}" -f $x,$y,(($y * 13) + $x),"")
    }
    While($i.Character -ne "q")
    }
}

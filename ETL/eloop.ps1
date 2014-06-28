## Simple example of Excel cell loop over each cell auto determined by max row and column

$maxrow = $first.UsedRange.Cells | Select-Object -Last 1 | Select-Object -Property Row
$maxrow = $maxrow.Row
$maxcol = $first.UsedRange.Cells | Select-Object -Last 1 | Select-Object -Property Column
$maxcol = $maxcol.Column
#used = $ws.UsedRangs.Cells
#cols = $used.Columns.Count
#rows = $used.Rows.Count


for ($c = 1; $c -le $maxrow = $maxrow.Row; $c++)
{
    for ($r = 1; $r -le $maxrow; $r++)
    {
        if ($ws.Cells.Item($r,$c).Value() -like "*,*")  ## Or other character, like " ' |
        {
            ## Replace or change
        }
    }
}

## Windows 8 note/ending:

if (Get-Process -ProcessName EXCEL)
{
    Stop-Process -ProcessName EXCEL
}

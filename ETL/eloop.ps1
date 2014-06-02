## Simple example of Excel cell loop with 5 rows and columns of data (expand if larger)

for ($c = 1; $c -lt 5; $c++)
{
    for ($r = 1; $r -lt 5; $r++)
    {
        if ($ws.Cells.Item($r,$c).Value() -like "*,*")  ## Or other character, like " ' |
        {
            ## Replace or change
        }
    }
}

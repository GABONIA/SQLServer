## Simple example of Excel cell loop

for ($c = 1; $c -lt 5; $c++)
{
    for ($r = 1; $r -lt 5; $r++)
    {
        if ($first.Cells.Item($r,$c).Value() -like "*,*")  ## Or other character, like " ' |
        {
            ## Replace or change
        }
    }
}

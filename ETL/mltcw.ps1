Function TSQL_MultipleCaseWhens ($min, $max, $value, $equation, $field)
{
    $nl = [Environment]::NewLine
    $times = $max / $value
    $first = "CASE WHEN $equation < $min THEN 0" + $nl
    $end = "WHEN $equation > $max THEN " + ($times + 1).ToString() + " END AS $field" + $nl
    $between = ""

    for ($i = 1; $i -le $times; $i++)
    {
        if ($i -eq 1)
        { 
            $between += "WHEN $equation > $min AND $equation <= $value THEN $i" + $nl
        }
        else
        {
            $between += "WHEN $equation > $prev_value AND $equation <= $value THEN $i" + $nl
        }
        $prev_value = $value
    }
    $all = $first + $between + $end
    $all
}

MultipleStrings -min 0 -max 100000 -value 10000 -equation "(([ColumnOne]*[ColumnTwo])/[ColumnThree])" -field "OurFinalColumn"

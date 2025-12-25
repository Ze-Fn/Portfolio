# Excel/Spreadsheet Notes

## XLOOKUP in Microsoft Excel

`"\*"\&` -> for wildcard

```txt
=SUM(XLOOKUP(search,range\_to\_look,value\_to\_return):XLOOKUP(search,range\_to\_look,value\_to\_return))
```

## Conditional Formatting in Microsoft Excel

Simply choose the desired options for the formatting in the "Conditional Formatting" menu at Home > Conditional Formatting.

An alternative (tedious) way to conditional formatting is to use CONCAT, AVERAGE, and IF; and also a duplicate sheet containing the data.

```txt
=IF(ref\_cell > (AVERAGE(range\_in\_ref)+(AVERAGE(range\_in\_ref)\*0,25)); CONCATENATE("▲    "; ref\_cell); 
    IF(ref\_cell < (AVERAGE(range\_in\_ref)-(AVERAGE(range\_in\_ref)\*0,25)); CONCATENATE("▼    "; ref\_cell); 
    CONCATENATE("≈    "; ref\_cell)))
```


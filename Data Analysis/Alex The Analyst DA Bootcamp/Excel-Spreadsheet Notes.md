# Excel/Spreadsheet Notes
## XLOOKUP in Microsoft Excel
`"*"&` -> for wildcard

```txt
=SUM(XLOOKUP(search,range_to_look,value_to_return):XLOOKUP(search,range_to_look,value_to_return))
```

## Conditional Formatting in Microsoft Excel
Simply choose the desired options for the formatting in the "Conditional Formatting" menu at Home > Conditional Formatting.

An alternative (tedious) way to conditional formatting is to use CONCAT, AVERAGE, and IF; and also a duplicate sheet containing the data.

```txt
=IF(ref_cell > (AVERAGE(range_in_ref)+(AVERAGE(range_in_ref)*0,25)); CONCATENATE("▲    "; ref_cell); IF(ref_cell < (AVERAGE(range_in_ref)-(AVERAGE(range_in_ref)*0,25)); CONCATENATE("▼    "; ref_cell); CONCATENATE("≈    "; ref_cell)))
```
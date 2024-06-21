---
external help file: psNakivo-help.xml  
Module Name: psNakivo  
online version: https://github.com/we-mi/psNakivo/blob/main/docs/Get-NakivoJob.md  
schema: 2.0.0  
---

# Get-NakivoJobOverview

## SYNOPSIS
Get job overview for a nakivo tenant

## SYNTAX

### UUID (Default)
```
Get-NakivoJobOverview [-TenantUUID] <String> [<CommonParameters>]
```

### Name
```
Get-NakivoJobOverview [-TenantName] <String> [<CommonParameters>]
```

## DESCRIPTION
Get job overview for a nakivo tenant.
You can pipe the output of "Get-NakivoTenant" to this command.

## EXAMPLES

### BEISPIEL 1
```
Get-NakivoJobOverview -TenantName "Mordor"
```

List the job overview for the tenant "Mordor" (hey, Sauron needs backups too, you know?)

### BEISPIEL 2
```
Get-NakivoTenant "Mordor" | Get-NakivoJobOverview
```

Same as example above but with pipelines

### BEISPIEL 3
```
Get-NakivoTenant "Mordor","Gondor" | Get-NakivoJobOverview
```

You can also pipe multiple Tenants to this command

## PARAMETERS

### -TenantName
The name of the tenant you want to list the job overview for

```yaml
Type: System.String
Parameter Sets: Name
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -TenantUUID
The UUID of the tenant you want to list the job overview for

```yaml
Type: System.String
Parameter Sets: UUID
Aliases: UUID

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Nakivo.JobOverview
## NOTES

## RELATED LINKS

[https://github.com/we-mi/psNakivo/blob/main/docs/Get-NakivoJob.md](https://github.com/we-mi/psNakivo/blob/main/docs/Get-NakivoJob.md)


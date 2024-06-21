---
external help file: psNakivo-help.xml  
Module Name: psNakivo  
online version: https://github.com/we-mi/psNakivo/blob/main/docs/Get-NakivoTenant.md  
schema: 2.0.0  
---

# Get-NakivoTenant

## SYNOPSIS
List nakivo tenants

## SYNTAX

```
Get-NakivoTenant [[-TenantName] <String[]>] [<CommonParameters>]
```

## DESCRIPTION
List nakivo tenants.
Use the 'TenantName'-Parameter to filter the output

## EXAMPLES

### BEISPIEL 1
```
Get-NakivoTenant
```

List all available Nakivo tenants

### BEISPIEL 2
```
Get-NakivoTenant -TenantName "Customer1*"
```

List all available Nakivo tenants which names begins with \`Customer1\`

### BEISPIEL 3
```
Get-NakivoTenant "Test*","Dummy"
```

List all available Nakivo tenants which names contains \`Test\` or are named \`Dummy\`

## PARAMETERS

### -TenantName
One or more Tenant Names to filter for.
Can contain wildcards

```yaml
Type: System.String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Nakivo.Tenant
## NOTES

## RELATED LINKS

[https://github.com/we-mi/psNakivo/blob/main/docs/Get-NakivoTenant.md](https://github.com/we-mi/psNakivo/blob/main/docs/Get-NakivoTenant.md)


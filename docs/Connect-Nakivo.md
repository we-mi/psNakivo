---
external help file: psNakivo-help.xml
Module Name: psNakivo
online version: https://github.com/we-mi/psNakivo/blob/main/docs/Connect-Nakivo.md
schema: 2.0.0
---

# Connect-Nakivo

## SYNOPSIS
Connect to a nakivo instance

## SYNTAX

### Credential (Default)
```
Connect-Nakivo [-Server] <String> [-Port <Int32>] [-SSL <Boolean>] -Credential <PSCredential> [-Remember]
 [-SkipCertificateCheck] [-PassThru] [<CommonParameters>]
```

### User_Password
```
Connect-Nakivo [-Server] <String> [-Port <Int32>] [-SSL <Boolean>] -Username <String> -Password <SecureString>
 [-Remember] [-SkipCertificateCheck] [-PassThru] [<CommonParameters>]
```

## DESCRIPTION
Connect to a nakivo instance.
Use this function before using any other nakivo-function

## EXAMPLES

### BEISPIEL 1
```
Connect-Nakivo -Server nakivo.example.com -Username admin -Password ( "mysuperstrongpassword" | ConvertTo-SecureString -AsPlainText -Force)
```

Connect to the nakivo instance at \`nakivo.example.com\` as user \`admin\` with the provided password.
Use SSL (https) for the connection and check for a valid ssl certificate

### BEISPIEL 2
```
Connect-Nakivo -Server nakivo.example.com -Username admin -Password ( "mysuperstrongpassword" | ConvertTo-SecureString -AsPlainText -Force) -SkipCertificateCheck
```

Connect to the nakivo instance at \`nakivo.example.com\` as user \`admin\` with the provided password.
Use SSL (https) for the connection but skip ssl certificate validation

### BEISPIEL 3
```
Connect-Nakivo -Server nakivo.example.com -Credential $Credential -Port 80 -SSL $false -Remember
```

Connect to the nakivo instance at \`nakivo.example.com\` with the provided credentials.
Do not use SSL and connect to the custom port 80.
Remember the connection (default is being logged out after 10 minutes)

## PARAMETERS

### -Credential
Credential-Object which holds the user information for logging in

```yaml
Type: System.Management.Automation.PSCredential
Parameter Sets: Credential
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
Send the output object back to stdout

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Password
Password for the user as a SecureString-Object

```yaml
Type: System.Security.SecureString
Parameter Sets: User_Password
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Port
TCP Port number of the nakivo instance.
Defaults to 4443

```yaml
Type: System.Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 4443
Accept pipeline input: False
Accept wildcard characters: False
```

### -Remember
Keep the user logged in.
Default is logging out after 10 minutes

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Server
Server name or ip of the nakivo instance

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipCertificateCheck
Do not check the servers ssl certificate.
You should not use this in productive environments

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SSL
Use SSL (https) for the connection.
Defaults to $True

```yaml
Type: System.Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -Username
Username which will be used for the login

```yaml
Type: System.String
Parameter Sets: User_Password
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Nakivo.User
## NOTES

## RELATED LINKS

[https://github.com/we-mi/psNakivo/blob/main/docs/Connect-Nakivo.md](https://github.com/we-mi/psNakivo/blob/main/docs/Connect-Nakivo.md)


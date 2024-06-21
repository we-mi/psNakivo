---
external help file: psNakivo-help.xml  
Module Name: psNakivo  
online version: https://github.com/we-mi/psNakivo/blob/main/docs/Initialize-NakivoAdmin.md  
schema: 2.0.0  
---

# Initialize-NakivoAdmin

## SYNOPSIS
Sets the password for the nakivo admin if it has not been set before

## SYNTAX

### User_Password
```
Initialize-NakivoAdmin -Username <String> [-Password <SecureString>] -Mail <String> [-EC2ID <String>]
 [-ServerUri <String>] [<CommonParameters>]
```

### Credential
```
Initialize-NakivoAdmin -Credential <PSCredential> -Mail <String> [-EC2ID <String>] [-ServerUri <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Sets the password for the nakivo admin if it has not been set before.
This skips the "Create User" page on the first login

## EXAMPLES

### BEISPIEL 1
```
Initialize-NakivoAdmin -Username "admin" -Password ("nakivo" | ConvertTo-SecureString -AsPlainText -Force) -Mail "admin@localhost"
```

Creates the new admin with the corresponding values

## PARAMETERS

### -Credential
Credential-Object which holds the information for creating the new admin

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

### -EC2ID
ID of the Amazon EC2 Instance

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Mail
Mail-Address of the admin

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Password
Password for new admin as a SecureString-Object

```yaml
Type: System.Security.SecureString
Parameter Sets: User_Password
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServerUri
Override the Uri of the nakivo instance.
Use this if you do not want to use "Connect-Nakivo" before using this command.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Username
Username for the new admin

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

## NOTES
Although it is technically not neccessary to already be authenticated in order to use this command, this command assumes that you've called "Connect-Nakivo" before.
That is because "Connect-Nakivo" stores some internal values about the Nakivo-Servers Uri, so that you do not need to pass them to every command you execute.
If you want to workaround this and do not wish to call "Nakivo-Connect" before using this you can use the parameter "ServerUri" (see below).

## RELATED LINKS

[https://github.com/we-mi/psNakivo/blob/main/docs/Initialize-NakivoAdmin.md](https://github.com/we-mi/psNakivo/blob/main/docs/Initialize-NakivoAdmin.md)


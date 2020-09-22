#architecture du script
#try de se co à l'ADAzure
#suite du script
#catch La connexion a échoué, vérifiez si vous êtes connecté correctement à Internet ou si votre jeu login/password est correct.

function Menu
{
     
     cls
     Write-Host "================ MENU ================"
    
     Write-Host "1: Appuyer sur '1' pour afficher les utilisateurs AzureAD."
     Write-Host "2: Appuyer sur '2' pour créer un utilisateur AzureAD."
     Write-Host "3: Appuyer sur '3' pour modifier le mot de passe d'un utilisateur AzureAD."
     Write-Host "4: Appuyer sur '4' pour afficher les groupes AzureAD."
     Write-Host "5: Appuyer sur '5' pour créer un groupe AzureAD."
     Write-Host "6: Appuyer sur '6' pour intégrer un utilisateur à un groupe AzureAD."
     Write-Host "Q: Press 'Q' to quit."
}

function PrintUsers {
 Get-AzureADUser -All $true | Select DisplayName,Mail,ObjectId
}

function CreateUser {

    $Displayname = Read-Host "Renseigner un nom pour le compte"
    $mail = ($DisplayName + "@resoreso.onmicrosoft.com").ToLower()

    do{$MDP = Read-Host "Mot de passe  : " -AsSecureString
    $MDP2 = Read-Host "Confirmation" -AsSecureString
    #Conversion en chaîne de caractères cachés pour le mot de passe
    $pass1 = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($MDP))
    $pass2 = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($MDP2))
    }
    until ($pass1 -eq $pass2)
    #Création d'un nouveau profil de mot de passe pour l'utilisateur avec configuration de la variable password avec l'input utilisateur
    $PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
    $PasswordProfile.Password = "$MDP"




New-AzureADUser -DisplayName $DisplayName -PasswordProfile $PasswordProfile -UserPrincipalName $mail -AccountEnabled $true -MailNickName $DisplayName



}

function checkuser {
Get-ADUser -Filter 'SamAccountName -eq $login' -SearchBase $OU
}

function CreateFromCsv {

#Emplacement utilisateurs à importer
$userList = ".\listeGroupe.csv"

 

#Emplacement du fichier log
$fichier = "C:\Users\administrateur.API-REZOREZO7\Desktop\logs.txt"

$i = 0
$Users = Import-Csv -Path $userList -Delimiter ";"
foreach ($User in $Users) 
{ 
    $login = $User.prenom.substring(0,1)+"."+$User.nom

 

    #Si résultat ne créer pas l'utilisateur
    if (checkuser $login) {
     
     write-host "L'utilisateur $login existe déjà."

 

    } else {

 

    createuser $User.nom $User.prenom $login
    $i ++
    }

 


}
}

function PassChange {
Get-AzureADUser -All $true | Select DisplayName,Mail,ObjectId

 $ObjId = Read-Host "Renseigner l'ObjectId de l'utilisateur dont le mot de passe sera changé "

 $NewPass = Read-Host "Nouveau mot de passe : " -AsSecureString
 Set-AzureADUserPassword -ObjectId  "$ObjId" -Password $NewPass
 
}

function PrintGroup {
 Get-AzureADGroup
}

function UserToGroup {

$GroID = Read-Host "Renseigner l'ObjectID du groupe "
Get-AzureADUser -All $true | Select DisplayName,Mail,ObjectId
$UserID = Read-Host "Renseigner l'ObjectId de l'utilisateur à ajouter "

Add-AzureADGroupMember -ObjectId $GroID -RefObjectId $UserId | Select ObjectId,DisplayName
}

function CreateGroup {

$GroDesc = Read-Host "Renseigner une description pour le groupe"
$GroName = Read-Host "Renseigner un nom pour le groupe"
 New-AzureADGroup -Description "$GroDesc" -DisplayName "$GroName" -MailEnabled $false -SecurityEnabled $true -MailNickName "$GroName"

}



try {

$Tenant = Read-Host -Prompt 'Renseigner votre ID de locataire Azure AD'
Connect-AzureAD -TenantId $Tenant

}
catch{

 Write-Host "Impossible de se connecter à votre AzureADc, vérifiez que le couple login/password est correcte"

}
finally {
do
{
     Menu
     $input = Read-Host "Sélectionner un choix"
     switch ($input)
     {
           '1' {
                cls
                PrintUsers
           } '2' {
                cls
                CreateUser
           } '3' {
                cls
                PassChange
           } '4' {
                cls
                PrintGroup
           }'5' {
                cls
                CreateGroup
           }'6' {
                cls
                UserToGroup
           }
           
           
           
            'q' {
               # return
           }
     }
     pause
}
until (($input -eq 'q') -or ($input -eq 'Q'))



}


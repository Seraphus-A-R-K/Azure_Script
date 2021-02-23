
function Menu
{
     
     cls
     Write-Host "================ MENU ================"
    
     Write-Host "1: Appuyer sur '1' pour afficher les utilisateurs AD."
     Write-Host "2: Appuyer sur '2' pour créer des utilisateurs à partir d'un CSV."
     Write-Host "3: Appuyer sur '3' pour modifier le mot de passe d'un utilisateur AD."
     Write-Host "4: Appuyer sur '4' pour afficher les groupes AD."
     Write-Host "5: Appuyer sur '5' pour créer un groupe AD."
     Write-Host "6: Appuyer sur '6' pour intégrer un utilisateur à un groupe AD."
     Write-Host "Q: Press 'Q' to quit."
}

# Les informations du domaine Active Directory et le nom d'ordinateur sont écrit en tant qu'exemple, il faut les modifier.
# 

function CreateUserFromCsv {

#Ajouter un path vers le csv
$ADUsers = Import-csv C:\temp\newusers.csv -Delimiter ";"

foreach ($User in $ADUsers)
{

       $Username = $User.username
       $Password = $User.password
       $Firstname = $User.firstname
       $Lastname = $User.lastname
       $Department = $User.department
       $OU = $User.ou
       

       #Check if the user account already exists in AD
       if (Get-ADUser -F {SamAccountName -eq $Username})
       {
               #If user does exist, output a warning message
               Write-Warning "A user account $Username has already exist in Active Directory."
       }
       else
       {
              #Si un compte n'existe pas          
        
             New-ADUser `
            -SamAccountName $Username `
            -UserPrincipalName "$Username@resoreso.lan" `
            -Name "$Firstname $Lastname" `
            -GivenName $Firstname `
            -Surname $Lastname `
            -Enabled $True `
            -ChangePasswordAtLogon $True `
            -DisplayName "$Lastname, $Firstname" `
            -Department $Department `
            -Path $OU `
            -AccountPassword (convertto-securestring $Password -AsPlainText -Force)

       }
}
    Get-ADUser -Filter * | Select SamAccountName,UserPrincipalName
}



function PrintUsers {
Get-ADUser -Filter * | Select SamAccountName,UserPrincipalName
}

function PassChange {
Get-ADUser -Filter * | Select SamAccountName,UserPrincipalName
$User = Read-Host "Renseigner un nom d'utilisateur dont le mot de passe va être modifié"
$NewPass = Read-Host "Renseigner un mot de passe pour $User"
Set-ADAccountPassword -Identity $User -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "$NewPass" -Force)

}

function PrintGroups {
Get-ADGroup -Filter "*" |Select SamAccountName,Name,GroupScope,GroupCategory}

function CreaGroup {
$GroupName = Read-Host "Renseigner un nom de groupe"
$GroupScope = Read-Host "Renseigner une étendue de groupe parmi DomainLocal,Universal,Global"
New-ADGroup -GroupScope $GroupScope -Name $GroupName
}

function UserToGroup {
PrintUsers
$User = Read-Host "Renseigner un ou des nom(s) d'utilisateur(s= à ajouter à un groupe, sous ce format : user1, user2"
PrintGroups
$GroupName = Read-Host "Renseigner un nom de groupe auquel i lsera affecté"

Add-ADGroupMember -Identity $GroupName -Members $User 
}
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
                CreateUserFromCsv
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

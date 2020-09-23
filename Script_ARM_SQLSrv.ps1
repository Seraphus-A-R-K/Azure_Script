function Menu
{
     
     cls
     Write-Host "================ MENU ================"
    
     Write-Host "1: Appuyer sur '1' pour créer un serveur SQL."
     Write-Host "2: Appuyer sur '2' pour supprimer un groupe de ressources"
     Write-Host "3: Appuyer sur '3' pour supprimer un serveur SQl"
     Write-Host "Q: Press 'Q' to quit."
}

function CreaSqlServer {
 
 cls
#use this command when you need to create a new resource group for your deployment
Get-AzResourceGroup | Select ResourceGroupName,ResourceId
$ResoGrouName = Read-Host " Renseigner un nom pour le groupe de ressources"
New-AzResourceGroup -Name $ResoGrouName -Location eastus
New-AzResourceGroupDeployment -ResourceGroupName $ResoGrouName -TemplateUri https://raw.githubusercontent.com/Seraphus-A-R-K/Azure_Script/master/sqlazureconffile 
}


function RemResoGrou{

$resourceGroupName = Read-Host -Prompt "Nom du groupe de ressource"
Remove-AzResourceGroup -Name $resourceGroupName

}

function RemSqlServer{
cls
Get-AzResourceGroup | Select ResourceGroupName,ResourceId
$resourceGroupName = Read-Host -Prompt "Nom du groupe de ressource"
Get-AzResourceGroup | Get-AzSqlServer
$ServName = Read-Host -Prompt "Renseigner un ServerName"
Remove-AzSqlServer -ResourceGroupName "$resourceGroupName" -ServerName "$ServName"

}





try {

Connect-AzAccount

}
catch{

 Write-Host "Impossible de se connecter à votre compte Azure Account, vérifiez que le couple login/password est correcte"
 
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
                CreaSqlServer
           } '2' {
                cls
                RemResoGrou
           } '3' {
                cls
                RemSqlServer
           } 
           
           
           
            'q' {
               # return
           }
     }
     pause
}
until (($input -eq 'q') -or ($input -eq 'Q'))



}


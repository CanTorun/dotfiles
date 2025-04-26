#Aliases
new-alias e explorer
new-alias c code
new-alias cc clear
#Docker
new-alias d docker
new-alias dc docker-compose
#Git
new-alias g git




#CD Functions
function cdz { Set-Location (chezmoi source-path) }
function cdh { Set-Location "~" }
function cds { Set-Location "C:\1Sync" }
function cdd { Set-Location "C:\1Sync\Dev" }
function cdp { Set-Location "C:\1Sync\Personal" }
function cdl { Set-Location "C:\1Sync\Liva" }

#Git Functions
function gr { Set-Location (git rev-parse --show-toplevel) }

#Docker Functions
function dcu { docker-compose up -d $args }
function dcd { docker-compose down $args }
function dbash {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ContainerName
    )
    docker exec -it $ContainerName bash
}

function cz-push {
    cdz
    git add .
    git commit -m "Auto Push"
    git push -u origin main
}



# Init starship
Invoke-Expression (&starship init powershell)
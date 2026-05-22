param(
    [string]$TomcatHome = $env:CATALINA_HOME
)

$ErrorActionPreference = "Stop"

function Find-Maven {
    $mvn = Get-Command mvn.cmd -ErrorAction SilentlyContinue
    if ($mvn) {
        return $mvn.Source
    }

    $wrapperMaven = Get-ChildItem "$env:USERPROFILE\.m2\wrapper\dists" -Recurse -Filter mvn.cmd -ErrorAction SilentlyContinue |
        Select-Object -First 1 -ExpandProperty FullName
    if ($wrapperMaven) {
        return $wrapperMaven
    }

    throw "Maven was not found. Install Maven or run this project once from IntelliJ Maven so the wrapper cache exists."
}

function Find-JavaHome {
    if ($env:JAVA_HOME) {
        return $env:JAVA_HOME
    }

    $javaHomeLine = java -XshowSettings:properties -version 2>&1 | Select-String "java.home" | Select-Object -First 1
    if (-not $javaHomeLine) {
        throw "JAVA_HOME is not set and Java was not found on PATH."
    }

    return ($javaHomeLine.ToString() -replace "^\s*java\.home\s*=\s*", "").Trim()
}

function Find-TomcatHome {
    param([string]$ConfiguredTomcatHome)

    if ($ConfiguredTomcatHome -and (Test-Path (Join-Path $ConfiguredTomcatHome "bin\catalina.bat"))) {
        return $ConfiguredTomcatHome
    }

    $downloadTomcat = Get-ChildItem "$env:USERPROFILE\Downloads" -Recurse -Filter catalina.bat -ErrorAction SilentlyContinue |
        Select-Object -First 1 -ExpandProperty FullName
    if ($downloadTomcat) {
        return Split-Path (Split-Path $downloadTomcat -Parent) -Parent
    }

    throw "Tomcat was not found. Pass it explicitly: .\run-local-tomcat.ps1 -TomcatHome C:\path\to\tomcat"
}

$root = Split-Path $MyInvocation.MyCommand.Path -Parent
$maven = Find-Maven
$env:JAVA_HOME = Find-JavaHome
$env:CATALINA_HOME = Find-TomcatHome $TomcatHome
$env:CATALINA_BASE = Join-Path $root "tomcat-base-test"

Push-Location $root
try {
    & $maven clean package -DskipTests

    New-Item -ItemType Directory -Force -Path $env:CATALINA_BASE, "$env:CATALINA_BASE\logs", "$env:CATALINA_BASE\temp", "$env:CATALINA_BASE\webapps", "$env:CATALINA_BASE\work" | Out-Null
    if (-not (Test-Path "$env:CATALINA_BASE\conf")) {
        Copy-Item -Recurse -Force "$env:CATALINA_HOME\conf" $env:CATALINA_BASE
    }

    Copy-Item -Force "target\LaceBank.war" "$env:CATALINA_BASE\webapps\ROOT.war"

    Write-Host "Starting Ace Bank Lite at http://localhost:8080/"
    & "$env:CATALINA_HOME\bin\catalina.bat" run
}
finally {
    Pop-Location
}

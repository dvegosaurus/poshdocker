FROM mcr.microsoft.com/powershell:7.1.3-ubuntu-20.04
WORKDIR /build
# ADD script/main.ps1 main.ps1
RUN pwsh -c "Install-Module -Name powershell-yaml -Scope AllUsers -Force"
EXPOSE 9999
CMD ["pwsh","main.ps1"] 

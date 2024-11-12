FROM mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2019

SHELL ["powershell", "-NoProfile", "-Command"]

# delete the sample website
RUN Remove-Item -Recurse C:\inetpub\wwwroot\*

# install server side include
RUN Install-WindowsFeature -Name Web-Includes

# enable *.html for server side include
RUN New-WebHandler -Name "SSI-html" -Path "*.html" -Verb "*" -Modules "ServerSideIncludeModule" -ResourceType "File" -RequiredAccess "Script"
RUN Add-WebConfiguration "/system.webServer/handlers/@accessPolicy" -Value "Script"
# RUN Set-WebConfiguration "/system.webServer/caching/@enabled" -Value "False"
# RUN Set-WebConfiguration "/system.webServer/caching/@enableKernelCache" -Value "False"

# add webp MIME type
RUN Add-WebConfigurationProperty -PSPath 'MACHINE/WEBROOT/APPHOST' -Filter "system.webServer/staticContent" -Name "." -Value @{ fileExtension='.webp'; mimeType='image/webp' }

# copy the source code
WORKDIR /inetpub/wwwroot
COPY src/ .
COPY web.dev.config ./web.config

# download the URL rewrite module
ADD https://download.microsoft.com/download/1/2/8/128E2E22-C1B9-44A4-BE2A-5859ED1D4592/rewrite_amd64_en-US.msi /install/rewrite_amd64.msi
WORKDIR /install
COPY register_task.ps1 .
RUN ./register_task.ps1

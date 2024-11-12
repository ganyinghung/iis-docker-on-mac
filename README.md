# iis-docker-on-mac

For details, see my post here: http://yhg.io/update/2024/11/12/setting-up-iis-docker-on-mac.html

## To install:
1. Install Vagrant (https://developer.hashicorp.com/vagrant/install)
2. Install Virtual Box (https://www.virtualbox.org)
3. 
```console
$ git clone https://github.com/StefanScherer/windows-docker-machine
$ cd windows-docker-machine
$ vagrant up --provider virtualbox 2019-box
```

## To build and run:
```console
$ cd iis-docker-on-mac
$ docker context use 2019-box
$ docker compose up -d --build
$ docker exec iis-docker-on-mac-iis-1 powershell -NoProfile -Command "msiexec.exe /i C:\\install\\rewrite_amd64.msi /passive"
```

## To see the IP address of the container (so you can access the site `http://ipaddr:8000`):
```console
$ docker context inspect 2019-box
```

## When you have made changes to the source code:
```console
$ docker exec iis-docker-on-mac-iis-1 powershell -NoProfile -Command "robocopy C:\\WEBSITE C:\\INETPUB\\WWWROOT /S /XF .DS_Store /XD .git"
```

## To clean up
```console
$ cd windows-docker-machine
$ vagrant destroy -f
$ vagrant box remove StefanScherer/windows_2019_docker
$ docker context rm 2019-box
```
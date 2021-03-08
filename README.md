# sensOCampus | end-devices management #
______________________________________________________________

neOCampus IoT end-devices management.

This app. is responsible to manage all of the neOCampus IoT end-devices:

  - MQTT authentification and authorization (linked to mosquitto auth plugin)
  - send end-devices' specific JSON configuration
  - Prometheus end-point (internal monitoring)

### Environment variables ###
When you start this application (see below), you can pass several environment variables:

  - **DEBUG=1** this is our application debug feature
  - **SIM=1** this is our application simulation feature: kind of *read-only* mode (i.e no write to any database)
  - **DJANGO_DEBUG=1** this is debug to Django's internals
  - **MQTT_SERVER** and **MQTT_PORT**
  - **MQTT_USER** and **MQTT_PASSWD** are sensOCampus own MQTT credentials
  - **MQTT_TOPICS** json formated list of topics to subscribe to (usually #/device)
  - **MQTT_UNITID** is a neOCampus identifier fr msg filtering
  - **PGSQL_USER** and **PGSQL_PASSWD** are Postgres credentials for sensOCampus' internal database
  - **PGSQL_SERVER**=172.17.0.1   this is the docker gateway
  - **PGSQL_PORT**=5432
  - **PGSQL_DATABASE**=sensocampus    name of the database


### [HTTP] git clone ###
Only **first time** operation.

`git clone https://github.com/fthiebolt/sensOCampus.git`  

### git pull ###
```
cd sensOCampus
git pull
```

### git push ###
```
cd sensOCampus
./git-push.sh
```

**detached head case**
To commit mods to a detached head (because you forget to pull head mods before undertaking your own mods)
```
cd <submodule>
git branch tmp
git checkout master
git merge tmp
git branch -d tmp
```

### start container ###
```
cd /nfs/sensOCampus
DJANGO_DEBUG=1 SIM=1 DEBUG=1 MQTT_PASSWD='passwd' PGSQL_PASSWD='passwd' docker-compose up -d
```  

### fast update of existing running container ###
```
cd /nfs/sensOCampus
git pull
DEBUG=1 MQTT_PASSWD='passwd' PGSQL_PASSWD='passwd' docker-compose up --build -d
```  

### ONLY (re)generate image of container ###
```
cd /nfs/sensOCampus
docker-compose --verbose build --force-rm --no-cache
[alternative] docker build --no-cache -t sensOCampus -f Dockerfile .
```

### start container for maintenance ###
```
cd /nfs/sensOCampus
docker run -v /etc/localtime:/etc/localtime:ro -v "$(pwd)"/app:/opt/app:rw -it datacollector bash
```

### ssh root @ container ? ###
Yeah, sure like with any VM:
```
ssh -p xxxx root@locahost
```  


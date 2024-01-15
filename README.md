# pokeca_discord_bot
## fetures & commands
### coin
```
/coin toss [count(default: 1)]: toss coin
```
### dice
```
/dice roll [count(default: 1)]: roll dice
```
### time measurement
```
/time start [ minutes(default: 25) ]: measure [minutes] minutes
/time now: show current time
/time end: end to measure time
```
## development
### required
- docker
### build environment
#### build
```
cd pokeca_discord_bot
sudo docker compose build
sudo docker compose run api bundle install
sudo docker compose run bot bundle install
```

#### run
```
sudo docker compose up -d
```


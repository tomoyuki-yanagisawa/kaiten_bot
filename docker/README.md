# kaiten_bot_app

## Requirements

```
# Docker VM
brew install colima
```

```
# Docker CLI
brew install docker
```

## Sethup Docker VM

```
colima start # VM 立ち上げ
colima ls # VM 一覧
```

## Setup Docker CLI

```
docker context ls # 接続先ホスト一覧
docker context use colima
docker run hello-world # テスト
```

## Build

```
docker build ../ -f console/Dockerfile -t kaiten-bot/console
docker image ls
```

```
docker build ../ -f ruby/Dockerfile -t kaiten-bot/ruby
docker image ls
```

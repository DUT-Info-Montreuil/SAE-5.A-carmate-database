# Base de données du projet CARMATE
## Table des matières
- [**MCD**](#mcd)
- [**MLD**](#mld)
- [**Les variable d'environment**](#les-variables-denvironment)
- [**Lancer l'image Docker depuis votre machine**](#lancer-limage-docker-depuis-votre-machine)
- [**Se connecter à `postgres`**](#se-connecter-à-postgres)

## MCD
![MCD](MCD.png)

## MLD
![MLD](MLD.png)

## Les variables d'environment
Voici les variables d'environment set :
```yaml
POSTGRES_USER: postgres
POSTGRES_PASSWORD: postgres
```

## Lancer l'image Docker depuis votre machine
Pour lancer l'image Docker depuis votre machine, vous devez tous d'abord `pull` l'image :
```cmd
docker pull ghcr.io/dut-info-montreuil/sae-5.a-carmate-database:main
```
Ensuite, lancez l'image Docker : 
```cmd
docker run \
    --name carmate-database \
    -p 5432:5432 \
    -d ghcr.io/dut-info-montreuil/sae-5.a-carmate-database:main
```
Une fois executé, vous allez avoir en output de la commande un hash, exemple :
```cmd
b31435cfc19d294d565243e72b0170a184423dcf0914631e7f326c687e3ad5f6
```
Pour verifier, utilisez `docker ps` pour visualiser les images Docker qui tourne sur votre machine :
```cmd
CONTAINER ID   IMAGE                                                      COMMAND                  CREATED         STATUS          PORTS                                               NAMES
b31435cfc19d   ghcr.io/dut-info-montreuil/sae-5.a-carmate-database:main   "docker-entrypoint.s…"   7 seconds ago   Up 5 seconds    0.0.0.0:5432->5432/tcp, :::5432->5432/tcp           carmate-database
```
Si vous apercevez qu'il y a `carmate-database` dans la liste, c'est que votre image Docker tourne correctement

## Se connecter à `postgres`
Mot de passe: postgres
```cmd
psql \
    -h localhost \
    -p 5432 \
    -U postgres
```

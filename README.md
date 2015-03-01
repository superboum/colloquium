Etude Pratique
==============

Cette étude pratique porte sur la création d'un site web pour des conférences.

Il devra entre autre être utilisé pour la 30th Internation Workshop on Statistical Modeling.

[![Build Status](https://travis-ci.org/superboum/etude-pratique.svg?branch=master)](https://travis-ci.org/superboum/etude-pratique)

Installation
------------

Installer ruby & ses dépendances ainsi que npm

Pour RHEL/Fedora :

```bash
sudo yum install -y ruby sqlite-devel
sudo apt-get install libsqlite3-dev
```

Installer Ruby Make (rake).

```bash
sudo gem install rake
```

Installer les dépendances

```bash
rake server:install
rake assets:download
```

Lancement
---------

Générer les fichiers CSS et JS (à chaque modification du CSS ou du JS)

```bash
rake assets:generate
```

Lancer le serveur

```bash
rake server:run
```

Aide
----

```bash
rake -T
```

Tests
-----

Lancer les tests

```bash
rake
```

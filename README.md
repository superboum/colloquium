Etude Pratique
==============

Cette étude pratique porte sur la création d'un site web pour des conférences.

Il devra entre autre être utilisé pour la 30th Internation Workshop on Statistical Modeling.

[![Build Status](https://travis-ci.org/superboum/etude-pratique.svg?branch=master)](https://travis-ci.org/superboum/etude-pratique)

Installation
------------

Installer ruby & ses dépendances

Pour RHEL/Fedora :

```bash
sudo yum install -y ruby
```

Installer bundler, le gestionnaire de dépendances

```bash
gem install bundler
```

Installer les dépendances du projet listez dans le fichier Gemfile

```bash
bundle install
```

Lancement
---------

Lance le programme selon le fichier config.ru

```bash
rackup
```

Tests
-----

Lancer les tests

```bash
rake
```

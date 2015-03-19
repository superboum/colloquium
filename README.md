Etude Pratique
==============

[![Build Status](https://travis-ci.org/superboum/etude-pratique.svg?branch=master)](https://travis-ci.org/superboum/etude-pratique)
[![Dependency Status](https://gemnasium.com/superboum/etude-pratique.svg)](https://gemnasium.com/superboum/etude-pratique)
[![Code Climate](https://codeclimate.com/github/superboum/etude-pratique/badges/gpa.svg)](https://codeclimate.com/github/superboum/etude-pratique)
[![Test Coverage](https://codeclimate.com/github/superboum/etude-pratique/badges/coverage.svg)](https://codeclimate.com/github/superboum/etude-pratique)

Cette étude pratique porte sur la création d'un site web pour des conférences.

Il devra entre autre être utilisé pour la 30th Internation Workshop on Statistical Modeling.


Installation
------------

Installer ruby & ses dépendances ainsi que npm

Pour RHEL/Fedora :

```bash
sudo yum install -y ruby sqlite-devel rubygem-bundler
```
Pour Ubuntu

```bash
sudo apt-get install libsqlite3-dev ruby 
```

Installer les dépendances serveurs

```bash
bundle install
```

Installer les dépendances clients & la BDD

```bash
bundle exec rake assets:download
bundle exec rake assets:generate
bundle exec rake db:migrate
```

Lancement
---------

Générer les fichiers CSS et JS (à chaque modification du CSS ou du JS)

```bash
bundle exec rake assets:generate
```

Lancer le serveur

```bash
bundle exec rake server:run
```

Aide
----

```bash
bundle exec rake -T
```

Tests
-----

Lancer les tests

```bash
bundle exec rake
```

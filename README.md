Colloquium
==========

[![Build Status](https://travis-ci.org/superboum/colloquium.svg?branch=master)](https://travis-ci.org/superboum/etude-pratique)
[![Dependency Status](https://gemnasium.com/superboum/etude-pratique.svg)](https://gemnasium.com/superboum/etude-pratique)
[![Code Climate](https://codeclimate.com/github/superboum/colloquium/badges/gpa.svg)](https://codeclimate.com/github/superboum/colloquium)
[![Test Coverage](https://codeclimate.com/github/superboum/colloquium/badges/coverage.svg)](https://codeclimate.com/github/superboum/colloquium)
[![PullReview stats](https://www.pullreview.com/github/superboum/colloquium/badges/master.svg?)](https://www.pullreview.com/github/superboum/colloquium/reviews/master)

Colloquium is a simple tool to create a website for your conference or symposium.

It can handle :

  * Registration
  * Review of resume
  * Side events
  * Articles and pages
  * Many other things

Installation
------------

Install npm, ruby and its dependencies

RHEL/Fedora :

```bash
sudo yum install -y ruby sqlite-devel rubygem-bundler
```
Ubuntu

```bash
sudo apt-get install libsqlite3-dev ruby 
```

Install ruby gems with bundle

```bash
bundle install
```
Generate client-side assets and create database

```bash
bundle exec rake assets:download
bundle exec rake assets:generate
bundle exec rake db:migrate
```

Run
---

If you modify Colloquium CSS or JS, you must regenerate your assets:

```bash
bundle exec rake assets:generate
```

Create an admin account to test Colloquium (id: admin@admin.com, pw: admin):

```bash
bundle exec rake fixture:admin
```

Launch Colloquium:

```bash
bundle exec rake server:run
```

Help
----

```bash
bundle exec rake -T
```

Tests
-----

Launch tests

```bash
bundle exec rake
```

Launch tests with Selenium (works out of the box with firefox)

```bash
bundle exec rake test:selenium
```

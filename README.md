[![Build Status](https://travis-ci.org/mahcloud/KothmannBook.svg?branch=master)](https://travis-ci.org/mahcloud/KothmannBook)
# Kothmann Book
This app is dedicated to the Kothmanns of Texas. Found at www.kothmannsoftexas.org/

### Goals of this new site design:

1. Export family tree into pdf format for the Kothmann family book.

## SETUP

1) Clone repo
2) Install ruby 2.2.2
``` bash
  curl -sSL https://get.rvm.io
  rvm install ruby-2.2.2
```
3) Run `bundle install`
4) Make sure PostgreSQL is up and running
5) Initialize DB
``` bash
  rake db:create
  rake db:migrate
  rake db:seed
```
6) Run `rails server`
7) Open in browser (localhost:3000)
8) Import all people from CSV from FileMaker Pro at localhost:3000/people
9) Import all people descendants count from FileMaker Pro at localhost:3000/people
10) Import all relationships from FileMaker Pro at localhost:3000/relationships
11) Import all children from FileMaker Pro at localhost:3000/people
12) Export to PDF from FileMaker Pro at localhost:3000/books

Please feel free to help with suggestions or pull requests.

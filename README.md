[![Circle CI](https://circleci.com/gh/Kothmanns-of-Texas/KothmannBook.svg?style=svg)](https://circleci.com/gh/Kothmanns-of-Texas/KothmannBook)
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

  Seeded data gives you a login at `mike.hoffert@gmail.com` and `password`

8) Import all people from CSV from FileMaker Pro at localhost:3000/people

[Download CSV Here](all.csv)

9) Import all people descendants count from FileMaker Pro at localhost:3000/people

[Download CSV Here](all.csv)

10) Import all relationships from FileMaker Pro at localhost:3000/relationships

[Download CSV Here](relationships.csv)

11) Import all children from FileMaker Pro at localhost:3000/people

[Download CSV Here](children.csv)

12) Export to PDF from FileMaker Pro at localhost:3000/books


Please feel free to help with suggestions or pull requests.

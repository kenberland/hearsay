HEARSAY
=======

Setup:

```
rake db:drop db:create db:migrate db:seed
rake test
```


```
openssl pkcs12 -in ~/Desktop/bird-5.p12 -out ~/Desktop/ck.pem -nodes -clcerts
```


Run one test:

```
ruby -Itest test/foo.rb --name /some_thing_that_matches/
```

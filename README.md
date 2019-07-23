# explorer

TODO: Write a description here

## Installation

TODO: Write installation instructions here

## Usage

TODO: Write usage instructions here

## Development

### Build the mint webapp

    cd src/explorer/web/static
    mint build --skip-service-worker

### Run the explorer

    DEBUG=1 crystal run src/explorer.c

### RethinkDB docker doc

* https://docs.docker.com/samples/library/rethinkdb/

```bash
docker run --name rethinkdb -v "$PWD:/data" -d rethinkdb

# Connect the instance to an application

docker run --name some-app --link rethinkdb:rdb -d application-that-uses-rdb

# Connecting to the web admin interface on the same host

$BROWSER "http://$(docker inspect --format \
  '{{ .NetworkSettings.IPAddress }}' rethinkdb):8080"

# Connecting to the web admin interface on a remote / virtual host via SSH
# Where remote is an alias for the remote user@hostname:

# start port forwarding
ssh -fNTL 8080:$(docker inspect --format \
  '{{ .NetworkSettings.IPAddress }}' rethinkdb):8080 localhost

ssh -fNTL 28015:$(docker inspect --format \
  '{{ .NetworkSettings.IPAddress }}' rethinkdb):28015 localhost

# open interface in browser
xdg-open http://localhost:8080

# stop port forwarding
kill $(lsof -t -i @localhost:8080 -sTCP:listen)
kill $(lsof -t -i @localhost:28015 -sTCP:listen)
```

### Create RethinkDB database and user

```javascript
r.db('rethinkdb').table('users').insert({id: 'sushixplorer', password: 'sushixplorer'});
r.dbCreate('sushixplorer_test');
r.db('sushixplorer_test').grant('sushixplorer', {read: true, write: true, config: true});
```


## Contributing

1. Fork it (<https://github.com/your-github-user/explorer/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Christian Kakesa](https://github.com/your-github-user) - creator and maintainer

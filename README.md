# SushiChain Blockchain Explorer

SushiChain Explorer is an open source utility to browse activity on the Blockchain.

## Development

### Build the mint webapp

    cd src/explorer/web/static
    mint build
    cd ./../../../..

### Run the explorer

    DEBUG=1 crystal run src/explorer.cr -- -n http://testnet.sushichain.io:3000

### Compile the binary

    shards build --production

Start the compiled web application (static files are in binary)

    ./bin/explorer -n http://testnet.sushichain.io:3000 

### RethinkDB docker doc

[Link to RethinkDB docker documentation](https://docs.docker.com/samples/library/rethinkdb/)

    docker run -p 8080:8080 -p 28015:28015 --name rethinkdb -v "$PWD:/data" -d rethinkdb

    # Connecting to the web admin interface on the same host

    xdg-open http://localhost:8080

## Contributing

1. Fork it (<https://github.com/your-github-user/explorer/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

* [Christian Kakesa](https://github.com/your-github-user) - creator and maintainer

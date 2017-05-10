# sdx-compose

This repository allows you to spin up a local test environment for the ``sdx-`` suite of services.

### Prerequisites

 - make
 - docker
 - docker-compose
 - git

### Getting started

Export a ``SDX_HOME`` environment variable. This should point at a folder into
which you wish to clone the rest of the services (e.g. ``/home/my-user/sdx``)
[see [configuration](#configuration)]

Clone this repository somewhere and run ``make``

```shell
$ git clone git@github.com:ONSdigital/sdx-compose.git
$ cd sdx-compose
$ make
```

This will attempt to clone the repositories into ``SDX_HOME`` and run their ``Dockerfile``'s

Once built, you can bring the services up with:

```shell
$ make start
```

Rebuild services:

```shell
$ make build
```

### Configuration

``sdx-compose`` is not a service in itself, but requires an environment variable
to build and run other services.

| Environment variable | Default | Description
| -------------------- | ------- | -----------
| SDX_HOME             | _none_  | The folder to clone service repositories to
| PYTHON3              | _none_  | Path to python3 executable (e.g. ``/usr/local/bin/python3``). Used by receipt service keygen.

See the README files of each service for specific requirements they may have.
Each service is defaulted as best to run in the local environment using files
under [env](env)

### Logging

By default, all logging runs to the console. If you wish to re-enable ``syslog``
you can do so by uncommenting the ``logger`` lines in [docker-compose.yml](docker-compose.yml).

### License

Copyright ©‎ 2016, Office for National Statistics (https://www.ons.gov.uk)

Released under MIT license, see [LICENSE](LICENSE) for details.

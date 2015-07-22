# NAME

Mojolicious::Plugin::Log::Elasticsearch - Mojolicious Plugin to log requests to an Elasticsearch instance

# VERSION

version 1.152030

# SYNOPSIS

    # Config for your elasticsearch instance
    my $config = { elasticsearch_url => 'http://localhost:9200',
                   index             => 'webapps', 
                   type              => 'MyApp',
                   geo_ip_citydb     => 'some/path/here.dat',  # optional
                   log_stash_keys    => [qw/foo bar baz/],     # optional
    };

    # Mojolicious
    $self->plugin('Log::Elasticsearch', $config);

    # Mojolicious::Lite
    plugin 'Log::Elasticsearch', $config;

# DESCRIPTION

[Mojolicious::Plugin::Log::Elasticsearch](https://metacpan.org/pod/Mojolicious::Plugin::Log::Elasticsearch) logs all requests to your app to an elasticsearch
instance, allowing you to retroactively slice and dice your application performance in 
fascinating ways.

After each request (via `after_dispatch`), a non-blocking request is made to the elasticsearch
system via [Mojo::UserAgent](https://metacpan.org/pod/Mojo::UserAgent). This should mean minimal application performance hit, but does mean you
need to run under `hypnotoad` or `morbo` for the non-blocking request to work.

The new Elasticsearch index is created if necessary when your application starts. The following
data points will be logged each request:

- `ip` - IP address of requestor
- `path` - request path
- `code` - HTTP code of response
- `method` - HTTP method of request
- `time` - the number of seconds the request took to process (internally, not accounting for network overheads)

Additionally, if you supply a path to a copy of the GeoLiteCity.dat database file
in the config key '`geo_ip_citydb`', and have the [Geo::IP](https://metacpan.org/pod/Geo::IP) module installed, the
following keys will also be submitted to Elasticsearch:

- location - latitude and longitude of the city the IP address belongs to
- country\_code - two letter country code of the country the IP address belongs to

The city database can be obtained here: [http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz](http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz).

If you specify an arrayref of keys in the `log_stash_keys` configuration value, those
corresponding values will be pulled from the request's stash (if present) and also
sent to Elasticsearch.

When the index is created, appropriate types are set for the '`ip`', '`path`' and '`location`' fields - in particular
the '`path`' field is set to not\_analyzed so that it will not be treated as tokens separated by '/'.

# METHODS

[Mojolicious::Plugin::Log::Elasticsearch](https://metacpan.org/pod/Mojolicious::Plugin::Log::Elasticsearch) inherits all methods from
[Mojolicious::Plugin](https://metacpan.org/pod/Mojolicious::Plugin) and implements the following new ones.

## register

    $plugin->register(Mojolicious->new);

Register plugin in [Mojolicious](https://metacpan.org/pod/Mojolicious) application.

# SEE ALSO

[Mojolicious](https://metacpan.org/pod/Mojolicious), [Mojolicious::Guides](https://metacpan.org/pod/Mojolicious::Guides), [http://mojolicio.us](http://mojolicio.us), [https://www.elastic.co](https://www.elastic.co).

# AUTHOR

Justin Hawkins <justin@eatmorecode.com>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Justin Hawkins.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

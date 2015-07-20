# NAME

Mojolicious::Plugin::Log::Elasticsearch - Mojolicious Plugin to log requests to an Elasticsearch instance

# VERSION

version 1.152010

# SYNOPSIS

    # Config for your elasticsearch instance
    my $config = { elasticsearch_url => 'http://localhost:5600',
                   index             => 'webapps', 
                   type              => 'MyApp' };

    # Mojolicious
    $self->plugin('Log::Elasticsearch', $config);

    # Mojolicious::Lite
    plugin 'Log::Elasticsearch', $config;

# DESCRIPTION

[Mojolicious::Plugin::Log::Elasticsearch](https://metacpan.org/pod/Mojolicious::Plugin::Log::Elasticsearch) logs all requests to your app to an elasticsearch
instance, allowing you to retroactively slice and dice your application performance in 
fascinating ways.

After each request (via `after_dispatch`), a non-blocking request is made to the elasticsearch
system via Mojo::UserAgent. This should mean minimal application performance hit, but does mean you
need to run under `hypnotoad` or `morbo` for the non-blocking request to work.

# METHODS

[Mojolicious::Plugin::Log::Elasticsearch](https://metacpan.org/pod/Mojolicious::Plugin::Log::Elasticsearch) inherits all methods from
[Mojolicious::Plugin](https://metacpan.org/pod/Mojolicious::Plugin) and implements the following new ones.

## register

    $plugin->register(Mojolicious->new);

Register plugin in [Mojolicious](https://metacpan.org/pod/Mojolicious) application.

# SEE ALSO

[Mojolicious](https://metacpan.org/pod/Mojolicious), [Mojolicious::Guides](https://metacpan.org/pod/Mojolicious::Guides), [http://mojolicio.us](http://mojolicio.us).

# AUTHOR

Justin Hawkins <justin@eatmorecode.com>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Justin Hawkins.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

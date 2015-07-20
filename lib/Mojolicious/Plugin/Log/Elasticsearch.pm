package Mojolicious::Plugin::Log::Elasticsearch;
use Mojo::Base 'Mojolicious::Plugin';

use Time::HiRes qw/time/;
use Mojo::JSON  qw/encode_json/;

our $VERSION = '0.01';

sub register {
  my ($self, $app) = @_;
  $app->hook(before_dispatch => sub {
    my $c = shift;
    $c->stash->{'mojolicious-plugin-log-elasticsearch.start'} = time();
  });

  $app->hook(after_dispatch => sub {
    my $c = shift;
    my $dur = time() - $c->stash->{'mojolicious-plugin-log-elasticsearch.start'};
    
    my $json = encode_json { ip     => $c->tx->remote_address, 
                             path   => $c->req->url->to_abs->path, 
                             code   => $c->res->code,
                             method => $c->req->method,
                             time   => $dur };

    $c->app->ua->get('http://www.google.com' => sub {
      my ($ua, $tx) = @_;
      warn "GOOGS $json" . $tx->res->body;
    });
  });
}

  
1;
__END__

=encoding utf8

=head1 NAME

Mojolicious::Plugin::Log::Elasticsearch - Mojolicious Plugin

=head1 SYNOPSIS

  # Mojolicious
  $self->plugin('Log::Elasticsearch');

  # Mojolicious::Lite
  plugin 'Log::Elasticsearch';

=head1 DESCRIPTION

L<Mojolicious::Plugin::Log::Elasticsearch> is a L<Mojolicious> plugin.

=head1 METHODS

L<Mojolicious::Plugin::Log::Elasticsearch> inherits all methods from
L<Mojolicious::Plugin> and implements the following new ones.

=head2 register

  $plugin->register(Mojolicious->new);

Register plugin in L<Mojolicious> application.

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicio.us>.

=cut

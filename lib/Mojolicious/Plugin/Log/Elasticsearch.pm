package Mojolicious::Plugin::Log::Elasticsearch;

use Mojo::Base 'Mojolicious::Plugin';

use Time::HiRes qw/time/;
use Mojo::JSON  qw/encode_json/;

our $VERSION = '0.01';

sub register {
  my ($self, $app, $conf) = @_;

  my $index = $conf->{index} || die "no elasticsearch index provided";
  my $type  = $conf->{type}  || die "no elasticsearch type provided";
  my $es_url = $conf->{elasticsearch_url} || die "no elasticsearch url provided";

  my $tx_c = $app->ua->put("${es_url}/${index}");

  my $index_meta = {
    $type => {
      "_timestamp" => { enabled => 1, store => 1 },
      "properties" => { 
        'ip'   => { 'type' => 'ip', 'store' => 1 },
        'path' => { 'type' => 'string',  index => 'not_analyzed' } ,
      }
    }
  };

  my $url = "${es_url}/${index}/${type}/_mapping";
  my $tx = $app->ua->post($url, json => $index_meta);

  $app->hook(before_dispatch => sub {
    my $c = shift;
    $c->stash->{'mojolicious-plugin-log-elasticsearch.start'} = time();
  });

  $app->hook(after_dispatch => sub {
    my $c = shift;
    my @n = gmtime();
    my $t = sprintf("%04d-%02d-%02dT%02d:%02d:%02dZ", $n[5]+1900, $n[4]+1, $n[3],
                                                      @n[2,1,0]);
    my $dur = time() - $c->stash->{'mojolicious-plugin-log-elasticsearch.start'};
    
    my $data = { ip     => $c->tx->remote_address, 
                 path   => $c->req->url->to_abs->path, 
                 code   => $c->res->code,
                 method => $c->req->method,
                 time   => $dur,
                 # timestamp => $t,
                 # _timestamp => $t,
    };

    my $url = "${es_url}/${index}/${type}/?timestamp=${t}";
    $c->app->ua->post($url, json => $data, sub {
      my ($ua, $tx) = @_;
      if (! $tx) {
        $c->app->error("could not log to elasticsearch");
      }
      elsif ($tx->res->code !~ /^20./) {
        $c->app->error("could not log to elasticsearch - " . $tx->res->body);
      }
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

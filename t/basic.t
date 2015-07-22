use Mojo::Base -strict;

package Mock::UA;

use Test::More;

my $posts = [];

sub new { bless {}, __PACKAGE__ }
sub _posts_expected { $posts = $_[1]; } 
sub post { 
  my $exp_json = shift @$posts || fail "too many posts?";
  my $hash = $_[3];
  ok (defined $hash->{time}, 'has time');
  delete $hash->{time};
  is_deeply ($hash, $exp_json);
}

package main;

use Test::More;
use Mojolicious::Lite;
use Test::Mojo;

plugin 'Log::Elasticsearch', { elasticsearch_url => 'http://localhost:9200', index => 'foo', type => 'bar', log_stash_keys => [qw/foo/]  };

get '/' => sub {
  my $c = shift;
  $c->stash('foo' => 'bar');
  $c->render(text => 'Hello Mojo!');
};

my $t = Test::Mojo->new;
my $ua = Mock::UA->new;
$t->app->ua($ua);

$ua->_posts_expected([ { code => '200', method=>'GET', ip => '127.0.0.1', path => '/', foo => 'bar' } ]);
$t->get_ok('/')->status_is(200)->content_is('Hello Mojo!');

$ua->_posts_expected([ { code => '404', method=>'GET', ip => '127.0.0.1', path => '/floogle' } ]);
$t->get_ok('/floogle')->status_is(404);

done_testing();

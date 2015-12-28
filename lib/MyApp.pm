package MyApp;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
  my $self = shift;

  # Router
  my $r = $self->routes;
  $r->any('/')->detour('root#',name=>'Root');

}

1;

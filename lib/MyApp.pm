package MyApp;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
    my $self = shift;

  # Documentation browser under "/perldoc"
    $self->plugin('PODRenderer');

  # Router
    my $r = $self->routes;

  # Normal route to controller


    $r->get('/')->to('bbs#index');
    $r->post('/create')->to('bbs#create');
    $r->post('/thread')->to('bbs#thread');


}

1;

package MyApp::Controller::Example;
use Mojo::Base 'Mojolicious::Controller';

get'/'=>sub {
    my$c=shift;
    $c->render('index');
};

1;
__DATA__

@@index.html.ep
%my$url = url_for'title';
<div>My name is Yuki</div>


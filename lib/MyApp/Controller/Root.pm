package MyApp::Controller::Root;
use Mojo::Base 'Mojolicious::Controller';

sub index {
    my $self = shift;
    $self->render(template => 'root/index');
}

sub login {
    my $self = shift;
    my $user = $self->param('user') || '';
    my $pass = $self->param('pass') || '';

    $self->app->log->info("login check");

    # セッション確率済みなら認証通過（適当）
    if ($self->session('user')) {
	return 1;
    }

    # パスワードチェック（適当）
    $self->stash->{auth_failed} = 0;
    if ($user || $pass) {
	$self->app->log->info("pass check");
	if ($user eq "test" && $pass eq "test") {
	    $self->session(user => $user);
	    return 1;
	}
	$self->stash->{auth_failed} = 1;
    }

    # 認証画面を描画
    $self->render( template => 'root/auth');
    return undef;
}

sub logout {
    my $self = shift;
    # セッション削除
    $self->session(expires => 1);
    $self->redirect_to('index');
}

1;


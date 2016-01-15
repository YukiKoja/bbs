package MyApp::Controller::Root;
use Mojo::Base 'Mojolicious::Controller';
use strict;
use warnings;
use DBI;

sub login {
    my $self = shift;
    my $user = $self->param('user') || '';
    my $pass = $self->param('pass') || '';
    my $DB_NAME = "hoge";
    my $DB_HOST = "127.0.0.1";
    my $DB_USER = "koja";
    my $DB_PASSWD = "yuki";

    my $dbh = DBI->connect("dbi:Pg:dbname=$DB_NAME;host=$DB_HOST", $DB_USER, $DB_PASSWD)
        or die "$!\n Error: failed to connect to DB.\n";
    my $sql ="SELECT name, password from db_user";
    my $sth = $dbh->prepare($sql);
    $sth->execute;

    my $user_name = '';
    my $user_password = '';

    while (my $href = $sth->fetchrow_hashref) {

	if($user =~ /$href->{name}/ && $pass =~ /$href->{password}/){
	    $user_name = $href->{name};
	    $user_password = $href->{password};
	    say $user_name;
	    say $user_password;
	}
    }

    $dbh->disconnect;


    $self->app->log->info("login check");

    # セッション確率済みなら認証通過（適当）
    if ($self->session('user')) {
	return 1;
    }


    # パスワードチェック（適当）
    $self->stash->{auth_failed} = 0;
    if ($user || $pass) {
	$self->app->log->info("pass check");
	if ($user eq $user_name && $pass eq $user_password) {
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
    #$self->render(template => 'root/auth');
    $self->redirect_to('index');

}


sub join{
    my $self = shift;
    $self->render(template => 'root/join');
}



sub newjoin{
    my $self = shift; # ($self is Mojolicious::Controller object)
    my $user   = $self->param('user');
    my $pass   = $self->param('pass');
    my $DB_NAME = "hoge";
    my $DB_HOST = "127.0.0.1";
    my $DB_USER = "koja";
    my $DB_PASSWD = "yuki";

  return $self->render(template => 'root/join')
  unless $user;
  return $self->render(template => 'root/join')
  unless $pass;
  return $self->render(template => 'root/join')
  if length $user > 10;
  return $self->render(template => 'root/join')
  if length $pass > 8;



    my $dbh = DBI->connect("dbi:Pg:dbname=$DB_NAME;host=$DB_HOST", $DB_USER, $DB_PASSWD)
        or die "$!\n Error: failed to connect to DB.\n";
    my $sql = "select max(id) from db_user";    
    my  $sth = $dbh->prepare($sql);
    $sth->execute();
    my $data = $sth->fetch;
    my $id;
    if(defined $data){
	$id = $data->[0] +1;
    } else {
	$id = 1;
    }
    say $id;
    $sql = "INSERT into db_user (id,name,password) values (?,?,?)";
    $sth = $dbh->prepare($sql);
    $sth->execute($id,$user,$pass);
    $dbh->disconnect;
    $self->redirect_to('index');

}





1;


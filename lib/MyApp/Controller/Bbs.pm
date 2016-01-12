package MyApp::Controller::Bbs;
use Mojo::Base 'Mojolicious::Controller';

use strict;
use warnings;
use DBI;
#use Mojolicious::Lite;
use URI::Find;
use Encode qw/encode decode/;
use File::Basename;

#my $file = "$0";
#my $a = basename($file, ".pl");


sub thread{
    my $self = shift; # ($self is Mojolicious::Controller object)
    my $title   = $self->param('title');
    my $DB_NAME = "hoge";
    my $DB_HOST = "127.0.0.1";
    my $DB_USER = "koja";
    my $DB_PASSWD = "yuki";
    my $dbh = DBI->connect("dbi:Pg:dbname=$DB_NAME;host=$DB_HOST", $DB_USER, $DB_PASSWD)
	or die "$!\n Error: failed to connect to DB.\n";

    my  $sth = $dbh->prepare("
    INSERT into thread (name)
    values (?)
    ");
    $sth->execute($title);

    $dbh->disconnect;
  # Redirect
    $self->redirect_to('index');

}







sub create {
    my $self = shift; # ($self is Mojolicious::Controller object)

  # Form data(This data is Already decoded)
    my $name   = $self->param('name');
    my $message = $self->param('message');
    my $youtube = $self->param('youtube');
    my $tag   = $self->param('tag');
    my $tag2  = $self->param('tag2');
    my $thread_id = $self->param('thread_id');

    $youtube =~ s/http\:\/\/(?:www\.)?youtube\.com\/watch\?v\=([a-zA-Z0-9\_\-]{1,})/http\:\/\/www.youtube.com\/embed\/$1/;
    $youtube =~ s/https\:\/\/(?:www\.)?youtube\.com\/watch\?v\=([a-zA-Z0-9\_\-]{1,})/http\:\/\/www.youtube.com\/embed\/$1/;
    if ( $youtube =~ /youtube/ ) {
        $ tag = '<iframe width="390" height="300" src="';
        $ tag2 = '" frameborder="0" allowfullscreen></iframe>';
    }

  # Display error page if title is not exist.
  return $self->render(template => 'error', message  => 'Please input name')
      unless $name;

  # Display error page if message is not exist.
  return $self->render(template => 'error', message => 'Please input message')
      unless $message;

  # Check title length
  return $self->render(template => 'error', message => 'Name is too long')
      if length $name > 30;

  # Check message length
  return $self->render(template => 'error', message => 'Message is too long')
      if length $message > 200;
  
    my $DB_NAME = "hoge";
    my $DB_HOST = "127.0.0.1";
    my $DB_USER = "koja";
    my $DB_PASSWD = "yuki";

my $dbh = DBI->connect("dbi:Pg:dbname=$DB_NAME;host=$DB_HOST", $DB_USER, $DB_PASSWD)
    or die "$!\n Error: failed to connect to DB.\n";
my $sth = $dbh->prepare("
INSERT into test
(name,comment,create_timestamp,youtube,tag,tag2,thread_id)
values
(?,?,now(),?,?,?,?)
");
$sth->execute($name,$message,$youtube,$tag,$tag2,$thread_id);


$dbh->disconnect;

  # Redirect
    $self->redirect_to('/?thread_id='.$thread_id);

}






sub index {

my $self = shift;

my $thread = $self->param('thread_id');
say $thread;
my $DB_NAME = "hoge";
my $DB_HOST = "127.0.0.1";
my $DB_USER = "koja";
my $DB_PASSWD = "yuki";

my $dbh = DBI->connect("dbi:Pg:dbname=$DB_NAME;host=$DB_HOST", $DB_USER, $DB_PASSWD)
    or die "$!\n Error: failed to connect to DB.\n";
my $sth = $dbh->prepare("
SELECT test.name,
test.comment,
test.create_timestamp,
test.youtube,
test.tag,
test.tag2,
thread.name as thread_name
FROM test inner join thread on (test.thread_id = thread.thread_id)
where thread.thread_id = ?
");
$sth->execute($thread);

    my $entry_infos = [];
my $current_thread_name = '';
while (my $href = $sth->fetchrow_hashref) {

    print $href->{name},"\n";
    print $href->{comment},"\n";
    print $href->{create_timestamp},"\n";
    print $href->{youtube},"\n";
    print $href->{tag},"\n";
    print $href->{tag2},"\n";
    print $href->{thread_name},"\n";
    $current_thread_name = $href->{thread_name};    
        my $entry_info = {};
        $entry_info->{datetime} = $href->{create_timestamp};
        $entry_info->{name}    = $href->{name};
        $entry_info->{message}  = $href->{comment};
        $entry_info->{youtube}  = $href->{youtube};
        $entry_info->{tag}  = $href->{tag};
        $entry_info->{tag2}  = $href->{tag2};
        $entry_info->{thread_name} = $href->{thread_name};

        push @$entry_infos, $entry_info;

}

$sth = $dbh->prepare("
    SELECT name, thread_id from thread
   ");
$sth->execute;


my $thread_infos = [];

while (my $href = $sth->fetchrow_hashref) {

    print $href->{name},"\n";
   print $href->{thread_id},"\n";

        my $thread_info = {};
        $thread_info->{name}    = $href->{name};
        $thread_info->{thread_id}    = $href->{thread_id};
        push @$thread_infos, $thread_info;

}

$dbh->disconnect;

  # Render index page
  $self->render(entry_infos => $entry_infos, thread_infos => $thread_infos ,current_thread_id => $thread, current_thread_name => $current_thread_name);

} 



1;






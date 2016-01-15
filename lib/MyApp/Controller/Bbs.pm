package MyApp::Controller::Bbs;
use Mojo::Base 'Mojolicious::Controller';

use strict;
use warnings;
use DBI;
use URI::Find;
use Encode qw/encode decode/;
use File::Basename;
use File::Path 'mkpath';

sub thread{
    my $self = shift; # ($self is Mojolicious::Controller object)
    my $title   = $self->param('title');
    my $DB_NAME = "hoge";
    my $DB_HOST = "127.0.0.1";
    my $DB_USER = "koja";
    my $DB_PASSWD = "yuki";
    my $dbh = DBI->connect("dbi:Pg:dbname=$DB_NAME;host=$DB_HOST", $DB_USER, $DB_PASSWD)
	or die "$!\n Error: failed to connect to DB.\n";
    my  $sql = "INSERT into thread (name) values (?)";
    my  $sth = $dbh->prepare($sql);
    $sth->execute($title);

    $dbh->disconnect;
  # Redirect
    $self->redirect_to('index');

}



sub create {
    my $self = shift; # ($self is Mojolicious::Controller object)







# Directory to save image files
# (app is Mojolicious object. static is MojoX::Dispatcher::Static object)
    my $IMAGE_DIR  = '/public';


  # Uploaded image(Mojo::Upload object)
    my $image = $self->req->upload('image');
  
  
  # Check file type
    my $image_type = $image;
    my %valid_types = map {$_ => 1} qw(image/gif image/jpeg image/png);
  
  
  # Extention
    my $exts = {'image/gif' => 'gif', 'image/jpeg' => 'jpg',
		'image/png' => 'png'};
    my $ext = $exts->{$image_type};

my $id = 0;
    if(defined $id){
	$id = +1;
    } else {
	$id = 1;
    
    }
  
  # Image file
    my $image_file = "$IMAGE_DIR/" .$id. "jpg";
  
  # If file is exists, Retry creating filename
    while(-f $image_file){
	$image_file = "$IMAGE_DIR/" .$id. "jpg";
    }
  






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
    my $sql = "INSERT into test (name,comment,create_timestamp,youtube,tag,tag2,thread_id) values (?,?,now(),?,?,?,?)";
    my $sth = $dbh->prepare($sql);
    $sth->execute($name,$message,$youtube,$tag,$tag2,$thread_id);
    $dbh->disconnect;

    # Redirect
    $self->redirect_to('/?thread_id='.$thread_id);

}


sub index {

    my $self = shift;





    my $thread = $self->param('thread_id');
    #say $thread;
    my $DB_NAME = "hoge";
    my $DB_HOST = "127.0.0.1";
    my $DB_USER = "koja";
    my $DB_PASSWD = "yuki";

    my $dbh = DBI->connect("dbi:Pg:dbname=$DB_NAME;host=$DB_HOST", $DB_USER, $DB_PASSWD)
    or die "$!\n Error: failed to connect to DB.\n";
    my $sql ="
SELECT test.name,
test.comment,
test.create_timestamp,
test.youtube,
test.tag,
test.tag2,
thread.name as thread_name
FROM test inner join thread on (test.thread_id = thread.thread_id)
where thread.thread_id = ?
";
    my $sth = $dbh->prepare($sql);
    $sth->execute($thread);

    my $entry_infos = [];
    my $current_thread_name = '';
    while (my $href = $sth->fetchrow_hashref) {

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

    $sql = "SELECT name, thread_id from thread";
    $sth = $dbh->prepare($sql);
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

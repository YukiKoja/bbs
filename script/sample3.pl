#!/usr/bin/env perl

use Mojolicious::Lite;
use utf8;
use URI::Find;
use Encode qw/encode decode/;

# Data file (app is Mojolicious object. home is Mojo::Home object)
my $data_file = app->home->rel_file('bbs-data1.txt');

# Create entry
post '/create' => sub {
    my $self = shift; # ($self is Mojolicious::Controller object)
  
  # Form data(This data is Already decoded)
    my $title   = $self->param('title');
    my $message = $self->param('message');
    my $youtube = $self->param('youtube');
    my $tag   = $self->param('tag');
    my $tag2  = $self->param('tag2');



$youtube =~ s/http\:\/\/(?:www\.)?youtube\.com\/watch\?v\=([a-zA-Z0-9\_\-]{1,})/http\:\/\/www.youtube.com\/embed\/$1/;
$youtube =~ s/https\:\/\/(?:www\.)?youtube\.com\/watch\?v\=([a-zA-Z0-9\_\-]{1,})/http\:\/\/www.youtube.com\/embed\/$1/;
    if ( $youtube =~ /youtube/ ) {
	$ tag = '<iframe width="300" height="300" src="';
        $ tag2 = '" frameborder="0" allowfullscreen></iframe>';
    }

   #$youtube =~ s/http\:\/\/(?:www\.)?youtube\.com\/watch\?v\=([a-zA-Z0-9\_\-]{1,})/http\:\/\/www.youtube.com\/embed\/$1/;
  
=come
    my $finder = URI::Find->new(sub{
        my($uri, $orig_uri) = @_;
        return qq|<iframe width="300" height="360" src="$uri" frameborder="0" allowfullscreen><\/iframe>|;});

    $finder->find(\$message);
=cut




  # Display error page if title is not exist.
  #return $self->render(template => 'error', message  => 'Please input title')
   #   unless $title;




  # Display error page if message is not exist.
  return $self->render(template => 'error', message => 'Please input message')
      unless $message;
  
  # Check title length
  return $self->render(template => 'error', message => 'Title is too long')
      if length $title > 30;
  
  # Check message length
  return $self->render(template => 'error', message => 'Message is too long')
      if length $message > 200;

  return $self->render(template => 'error', message => 'Message is script')
      if ($message =~ /<script>/);




  #return $self->render(template => 'error', message => 'Message is too ')
      #if ($youtube =~ /a/);
  
  # Data and time
    my ($sec, $min, $hour, $day, $month, $year) = localtime;
    $month = $month + 1; 
    $year = $year + 1900;
  
  # Format date (yyyy/mm/dd hh:MM:ss)
  my $datetime = sprintf(
    "%04s/%02s/%02s %02s:%02s:%02s", 
    $year,
    $month,
    $day,
    $hour,
    $min,
    $sec
      );
  
  # Delete line breakes
    $message =~ s/\x0D\x0A|\x0D|\x0A//g;
  
  # Writing data
    my $record = join("\t", $datetime, $title, $message, $youtube, $tag, $tag2) . "\n";
  
  # File open to write
  open my $data_fh, ">>", $data_file
      or die "Cannot open $data_file: $!";
  
  # Encode
    $record = encode('UTF-8', $record);
  
  # Write
    print $data_fh $record;
  
  # Close
    close $data_fh;
  
  # Redirect
    $self->redirect_to('index');
  
} => 'create';


get '/' => sub {
    my $self = shift;
  





  # Open data file(Create file if not exist)
    my $mode = -f $data_file ? '<' : '+>';
  open my $data_fh, $mode, $data_file
      or die "Cannot open $data_file: $!";
  
  # Read data
    my $entry_infos = [];
    while (my $line = <$data_fh>){
	$line = decode('UTF-8', $line);
    
	chomp $line;
	my @record = split /\t/, $line;
    
	my $entry_info = {};
	$entry_info->{datetime} = $record[0];
	$entry_info->{title}    = $record[1];
	$entry_info->{message}  = $record[2];
	$entry_info->{youtube}  = $record[3];
	$entry_info->{tag}  = $record[4];        
	$entry_info->{tag2}  = $record[5];        

	push @$entry_infos, $entry_info;
    }
  
  # Close
    close $data_fh;
  
  # Reverse data order
    @$entry_infos = reverse @$entry_infos;
  
  # Render index page
    $self->render(entry_infos => $entry_infos);

} => 'index';

app->start;

__DATA__

@@ index.html.ep

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" >
    <title>Short Message BBS</title>
  

</head>
  <body>
    <h1>Short Message BBS</h1>

    <form method="post" action="<%= url_for('create') %>">
      <div>
        Title
        <input type="text" name="title" >
      </div>
      <div>Message</div>
      <div>
        <textarea name="message" cols="50" rows="10" ></textarea>
      </div>
      <div>
        youtube
        <input type="text" name="youtube" >
      </div>

      <div>
        <input type="submit" value="Post" >
      </div>
    </form>
    <div>
  <% for my $entry_info (@$entry_infos) { %>
      <div>
        <hr>
        <div>Title: <%= $entry_info->{title} %> (<%= $entry_info->{datetime} %>)</div>
        <div>Message</div>
        <div><%== $entry_info->{message} %>
        </div>
        <div>
            <%== $entry_info->{tag} %>
              <%= $entry_info->{youtube} %>
            <%== $entry_info->{tag2} %>
        </div>
         
      <div>
  <% } %>
    </div>
  </body>
</html>


@@ error.html.ep
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" >
    <title>Error</title>
  </head>
  <body>
    <%= $message %>
  </body>
</html>

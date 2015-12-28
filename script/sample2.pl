#!/usr/bin/env perl

use Mojolicious::Lite;
use utf8;
use Encode qw/encode decode/;
use File::Basename 'basename';
use File::Path 'mkpath';

# Data file (app is Mojolicious object. home is Mojo::Home object)
my $data_file = app->home->rel_file('bbs-data.txt');



# Image base URL
my $IMAGE_BASE = '/image-bbs/image';

# Directory to save image files
# (app is Mojolicious object. static is MojoX::Dispatcher::Static object)
my $IMAGE_DIR  = app->home->rel_file('/public') . $IMAGE_BASE;

# Create directory if not exists
unless (-d $IMAGE_DIR) {
    mkpath $IMAGE_DIR or die "Cannot create dirctory: $IMAGE_DIR";
}

# Display top page
get '/' => sub {
    my $self = shift;
  
    # Get file names(Only base name)
    my @images = map {basename($_)} glob("$IMAGE_DIR/*");
  
  # Sort by new order
    @images = sort {$b cmp $a} @images;
  
    
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

    
	push @$entry_infos, $entry_info;
    }
  
  # Close
    close $data_fh;
  
  # Reverse data order
    @$entry_infos = reverse @$entry_infos;
  
  

  # Render
    return $self->render(images => \@images, image_base => $IMAGE_BASE, entry_infos => $entry_infos);

} => 'index';

# Upload image file
post '/upload' => sub {
    my $self = shift;

 # Form data(This data is Already decoded)
    my $title   = $self->param('title');
    my $message = $self->param('message');
  
  # Display error page if title is not exist.
  return $self->render(template => 'error', message  => 'Please input title')
      unless $title;
  
  # Display error page if message is not exist.
  return $self->render(template => 'error', message => 'Please input message')
      unless $message;
  
  # Check title length
  return $self->render(template => 'error', message => 'Title is too long')
      if length $title > 30;
  
  # Check message length
  return $self->render(template => 'error', message => 'Message is too long')
      if length $message > 100;
  
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
    my $record = join("\t", $datetime, $title, $message) . "\n";
  
  # File open to write
  open my $data_fh, ">>", $data_file
      or die "Cannot open $data_file: $!";
  
  # Encode
    $record = encode('UTF-8', $record);
  
  # Write
    print $data_fh $record;
  
  # Close
    close $data_fh;
  

  # Uploaded image(Mojo::Upload object)
    my $image = $self->req->upload('image');
  
  # Not upload
    unless ($image) {
    return $self->render(
      template => 'error', 
      message  => "Upload fail. File is not specified."
	);
    }
  
  # Upload max size
    my $upload_max_size = 3 * 1024 * 1024;
  
  # Over max size
    if ($image->size > $upload_max_size) {
    return $self->render(
      template => 'error',
      message  => "Upload fail. Image size is too large."
	);
    }
  
  # Check file type
    my $image_type = $image->headers->content_type;
    my %valid_types = map {$_ => 1} qw(image/gif image/jpeg image/png);
  
  # Content type is wrong
    unless ($valid_types{$image_type}) {
    return $self->render(
      template => 'error',
      message  => "Upload fail. Content type is wrong."
	);
    }
  
  # Extention
    my $exts = {'image/gif' => 'gif', 'image/jpeg' => 'jpg',
		'image/png' => 'png'};
    my $ext = $exts->{$image_type};
  
  # Image file
    my $image_file = "$IMAGE_DIR/" . create_filename(). ".$ext";
  
  # If file is exists, Retry creating filename
    while(-f $image_file){
	$image_file = "$IMAGE_DIR/" . create_filename() . ".$ext";
    }
  
  # Save to file
    $image->move_to($image_file);
  
  # Redirect to top page
    $self->redirect_to('index');
  
} => 'upload';

sub create_filename {
  
  # Date and time
    my ($sec, $min, $hour, $mday, $month, $year) = localtime;
    $month = $month + 1;
    $year = $year + 1900;
  
  # Random number(0 ~ 99999)
    my $rand_num = int(rand 100000);

  # Create file name form datatime and random number
  # (like image-20091014051023-78973)
  my $name = sprintf(
    "image-%04s%02s%02s%02s%02s%02s-%05s",
    $year,
    $month,
    $mday,
    $hour,
    $min,
    $sec,
    $rand_num
      );
  
    return $name;
}

app->start;

__DATA__

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

@@ index.html.ep
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" >
    <title>Image BBS</title>
  </head>
  <body>
    <h1>Image BBS</h1>
    <form method="post" action="<%= url_for('upload') %>" enctype ="multipart/form-data">
      <div>
        File name
        <input type="file" name="image" >
              <div>
        Title
        <input type="text" name="title" >
      </div>
      <div>Message</div>
      <div>
        <textarea name="message" cols="50" rows="10" ></textarea>
      </div>
        <input type="submit" value="Upload" >
      </div>
    </form>
    <div>
  <% for my $entry_info (@$entry_infos) { %>
  <% for my $image (@$images) { %>
      <div>
        <hr>
        <div>Title: <%= $entry_info->{title} %> (<%= $entry_info->{datetime} %>)</div>
        <div>Message</div>
        <div><%= $entry_info->{message} %>
                          <div>
                <img src="<%= "$image_base/$image" %>">
              </div>
            <div>
              <hr>
            <div>
      <% } %>
    </div>
      <div>
  <% } %>
    </div>
    
  </body>
</html>

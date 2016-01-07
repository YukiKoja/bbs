#!/usr/bin/env perl

use strict;
use warnings;
use DBI;
use Mojolicious::Lite;
use URI::Find;

use Encode qw/encode decode/;

post '/new' => sub {
    my $self = shift; # ($self is Mojolicious::Controller object)
    my $file = "$0";
    my $title   = $self->param('title');
    my $a = $title;


    my $DB_NAME = "hoge";
    my $DB_HOST = "127.0.0.1";
    my $DB_USER = "koja";
    my $DB_PASSWD = "yuki";

my $dbh = DBI->connect("dbi:Pg:dbname=$DB_NAME;host=$DB_HOST", $DB_USER, $DB_PASSWD)
    or die "$!\n Error: failed to connect to DB.\n";
my $sth = $dbh->prepare("

CREATE TABLE $a
    (name text,
     comment text,
     create_timestamp timestamp without time zone,
     youtube text,
     tag text,
     tag2 text)

");
$sth->execute;


$dbh->disconnect;


  # Redirect
    $self->redirect_to('index');



} => 'new';

=come

post '/create' => sub {
    my $self = shift; # ($self is Mojolicious::Controller object)

  # Form data(This data is Already decoded)
   # my $title   = $self->param('title');



=come
    my $message = $self->param('message');
    my $youtube = $self->param('youtube');
    my $tag   = $self->param('tag');
    my $tag2  = $self->param('tag2');


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
  

=coment
$message =~ s/http\:\/\/(?:www\.)?youtube\.com\/watch\?v\=([a-zA-Z0-9\_\-]{1,})/<iframe width\=\"500\" height\=\"300\" src\=\"http\:\/\/www.youtube.com\/embed\/$1\" frameborder\=\"0\" allowfullscreen><\/iframe>/;

    my $finder = URI::Find->new(sub{
	my($uri, $orig_uri) = @_;
	return qq|iframe width="300" height="360" src="$uri" frameborder="0" allowfullscreen|;});

    $finder->find(\$message);

 
    my $DB_NAME = "hoge";
    my $DB_HOST = "127.0.0.1";
    my $DB_USER = "koja";
    my $DB_PASSWD = "yuki";

my $dbh = DBI->connect("dbi:Pg:dbname=$DB_NAME;host=$DB_HOST", $DB_USER, $DB_PASSWD)
    or die "$!\n Error: failed to connect to DB.\n";
my $sth = $dbh->prepare("

CREATE TABLE test
    (name text,
     comment text,
     create_timestamp timestamp without time zone,
     youtube text,
     tag text,
     tag2 text)

");
$sth->execute;


$dbh->disconnect;


  # Redirect
    $self->redirect_to('index');

} => 'create';
=cut


get '/' => sub {
    my $self = shift;


my $DB_NAME = "hoge";
my $DB_HOST = "127.0.0.1";
my $DB_USER = "koja";
my $DB_PASSWD = "yuki";

my $dbh = DBI->connect("dbi:Pg:dbname=$DB_NAME;host=$DB_HOST", $DB_USER, $DB_PASSWD)
    or die "$!\n Error: failed to connect to DB.\n";
my $sth = $dbh->prepare("select * from $a");
$sth->execute();

    my $entry_infos = [];

while (my $href = $sth->fetchrow_hashref) {

    print $href->{name},"\n";

        my $entry_info = {};
        $entry_info->{name}    = $href->{name};

        push @$entry_infos, $entry_info;

}


$dbh->disconnect;


  # Render index page
    $self->render(entry_infos => $entry_infos);

} => 'index';

app->start;


__DATA__

@@ index.html.ep
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" >
    <link rel="stylesheet" type="text/css" href="/mainstyle.css" />
    <title>掲示板</title>

  <style type="text/css">


    body{
    text-align:center;
    background:#f0f0f0;
    }

    h1 {
    color:blue;
    font-size:300%;
   }

h1:before {
    content: url(https://cdn3.iconfinder.com/data/icons/blue-ulitto/128/Developer_files_Perl_Sc\
ript-128.png);
    margin: 10px;
    position: relative;
    top: 8px;
}

h1:after {
    content: url(https://cdn3.iconfinder.com/data/icons/blue-ulitto/128/Developer_files_Perl_Sc\
ript-128.png);
    margin: 10px;
    position: relative;
    top: 8px;
}

   div#back {
 width:560px; margin:10px 20px 10px 0px;
float:right;

}

  div#bbs {
   padding-top: 30px;
   width: 390px;
   margin-left: auto;
   margin-right: auto;
   text-align:left;

}


   div#form {
   width: 390px;
   height : 390px;
   }




div#pagebody{
 width:796px; margin:0 auto;
text-align:left;
background-color:#727272;
}


div#submenu {
width:160px;/*幅の指定*/
margin:10px 10px 10px 25px;/*位置調整（IE6のバグに注意）*/
display:inline;/*IE6のマージン算出のバグ対策*/
float:left;/*サブメニューのカラムを左寄せにする*/
}

/*サブメニューのヘッダ部分（余白調整・背景画像・背景色・文字サイズなど）*/
div#submenu_header {
height:26px; padding:4px 0px 0px 0px;
background-image:url("images/bg_submenu_header.gif");
background-repeat:no-repeat; background-position:top;
background-color:#cccccc;
font-size:90%; font-weight:bold; text-align:center;
}

/*サブメニューのボディ部分（余白調整・背景画像・背景色）*/
ul#submenu_body {
padding-bottom:6px;
background-image:url("images/bg_submenu_footer.gif");
background-repeat:no-repeat; background-position:bottom;
background-color:#cccccc;
}
ul#submenu_body li {
font-size:90%;/*文字サイズを90%にする*/
list-style-type:none;/*リストマーカー無しにする*/
display:inline;/*リスト項目をインライン表示にする*/
}
ul#submenu_body li a {
display:block;/*リンクをブロック表示にする*/
margin:0px 4px 0px 4px;/*サブメニュー項目のマージン*/
padding:2px 0px 2px 20px;/*サブメニュー項目のパディング*/
background-color:#eeeeee;/*サブメニュー項目の背景色*/
text-decoration:none;/*リンクの下線を無くす*/
}

div#main {
width:390px; margin-right:5px; padding-top:10px;
float:left;
}



  </style>


  </head>


<body>

<div id ="pagebody">

<header>
<div align="center">
<h1>掲 示 板</h1>
<hr width="90%">
[<a href="">リンク</a>]
[<a href="">リンク</a>]
[<a href="">リンク</a>]
[<a href="">リンク</a>]
<hr width="90%">
</header>



<div id="submenu">
    <div id="submenu_header">リンク</div>
    <ul id="submenu_body">
    <li><a href="xxx.html">リンク</a></li>
    <li><a href="xxx.html">リンク</a></li>
    <li><a href="xxx.html">リンク</a></li>
    <li><a href="xxx.html">リンク</a></li>
    <li><a href="xxx.html">リンク</a></li>
    <li><a href="xxx.html">リンク</a></li>
    <li><a href="xxx.html">リンク</a></li>
    <li><a href="xxx.html">リンク</a></li>
    <li><a href="xxx.html">リスト</a></li>
    <li><a href="xxx.html">リンク</a></li>
    <li><a href="xxx.html">リンク</a></li>
    <li><a href="xxx.html">リンク</a></li>
    <li><a href="xxx.html">リンク</a></li>
    <li><a href="xxx.html">リンク</a></li>
    <li><a href="xxx.html">リンク</a></li>
    <li><a href="xxx.html">リンク</a></li>
    </ul>
</div>

<div id ="back">




<div id ="main">

<div id ="bbs">
    <form method="post" action="<%= url_for('new') %>">
      <div>
        Name
        <input type="text" name="title">
      </div>
      <div>
        <input type="submit" value="Post">
      </div>
    </form>
</div>


   <div id="form">

     <% for my $entry_info (@$entry_infos) { %>

     <div>
     <div style="background-color:#016BFF;">Name: <%= $entry_info->{name} %>
     (<%= $entry_info->{datetime} %>)</div>
     <div style="background-color:#a4a4a4;">Message</div>
     <div style="background-color:#a4a4a4;"><%= $entry_info->{message} %></div>
 
     <div>
<%== $entry_info->{tag} %>
<%= $entry_info->{youtube} %>
<%== $entry_info->{tag2} %>
     </div>

     <hr>
     </div>

    <% } %>

   </div>



   </div>
  </div>
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



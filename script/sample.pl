#!/usr/bin/env perl

use strict;
use warnings;
use DBI;
use Mojolicious::Lite;
use URI::Find;
use Encode qw/encode decode/;
use File::Basename;

#my $file = "$0";
#my $a = basename($file, ".pl");


post '/thread' =>sub {
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

} => 'thread';







post '/create' => sub {
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

} => 'create';








get '/' => sub {

my $self = shift;

my $thread = $self->param('thread_id');
say $thread;
my $DB_NAME = "hoge";
my $DB_HOST = "127.0.0.1";
my $DB_USER = "koja";
my $DB_PASSWD = "yuki";

my $dbh = DBI->connect("dbi:Pg:dbname=$DB_NAME;host=$DB_HOST", $DB_USER, $DB_PASSWD)
    or die "$!\n Error: failed to connect to DB.\n";
my $sth = $dbh->prepare("SELECT * FROM test where thread_id = $thread");
$sth->execute();

    my $entry_infos = [];

while (my $href = $sth->fetchrow_hashref) {

    print $href->{name},"\n";
    print $href->{comment},"\n";
    print $href->{create_timestamp},"\n";
    print $href->{youtube},"\n";
    print $href->{tag},"\n";
    print $href->{tag2},"\n";
    
        my $entry_info = {};
        $entry_info->{datetime} = $href->{create_timestamp};
        $entry_info->{name}    = $href->{name};
        $entry_info->{message}  = $href->{comment};
        $entry_info->{youtube}  = $href->{youtube};
        $entry_info->{tag}  = $href->{tag};
        $entry_info->{tag2}  = $href->{tag2};

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
    $self->render(entry_infos => $entry_infos, thread_infos => $thread_infos ,current_thread_id => $thread);

} 

=> 'index';






app->start;


__DATA__

@@ index.html.ep
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" >

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
background-repeat:no-repeat; background-position:top;
background-color:#cccccc;
font-size:90%; font-weight:bold; text-align:center;
}

/*サブメニューのボディ部分（余白調整・背景画像・背景色）*/
ul#submenu_body {
padding-bottom:6px;
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

    <div id="submenu_header">スレッド</div>
    <ul id="submenu_body">
    <% for my $thread_info (@$thread_infos) { %>
    <li><a href="?thread_id=<%= $thread_info->{thread_id} %>"><%= $thread_info->{name} %></a></li>
    <% } %>
    </ul>
</div>



<div id ="back">




<div id ="main">

<div id ="bbs">
    <form method="post" action="<%= url_for('thread') %>">
      <div>
        新規
        <input type="text" name="title">
        <input type="submit" value="作成">
      </div>
    </form>


    <hr>
    <form method="post" action="<%= url_for('create') %>">
    <input type="hidden" name="thread_id" value="<%= $current_thread_id %>">
      <div>
        Name
        <input type="text" name="name">
      </div>
      <div>Message</div>
      <div>
        <textarea name="message" cols="50" rows="10" ></textarea>
      </div>
      <div>
        youtube
        <input type="text" name="youtube" size="40" placeholder="http://www.youtube.com/watch?v=8Q2uzIv4nhg" >
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
<%== $entry_info->{tag} || '' %>
<%= $entry_info->{youtube} || '' %>
<%== $entry_info->{tag2} || '' %>
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

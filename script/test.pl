#!perl


use URI::Find;


my $text = <<"END";

https://youtu.be/w2gIB5wKWsY

END

#$text = escapeHTML($text);

    my $finder = URI::Find->new(sub{
        my($uri, $orig_uri) = @_;
        return qq|<%=iframe width="300" height="360" src="$uri" frameborder="0" allowfullscreen%>;<%=/\
iframe%>|;});

$finder->find(\$text);



print $text;

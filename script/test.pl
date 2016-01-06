#!perl


use URI::Find;


my $text = <<"END";

https://youtu.be/w2gIB5wKWsY

END

#$text = escapeHTML($text);

my $finder = 
  URI::Find->new( #newにコールバック関数を渡す
		  sub{    #@_にURI::URLオブジェクト, 元のURIテキスト
		      my($uri, $orig_uri) = @_; 
		      print "The text '$orig_uri' represents '$uri'\n";
		      return "<" . $orig_uri . ">";
                                        #元のURIがreturnの値に置き換わる
		  });
$finder->find(\$text); #テキストのリファレンスを渡し実行
                                    #findは見つかったURIの数を返す


print $text;

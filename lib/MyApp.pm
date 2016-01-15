package MyApp;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
    my $self = shift;
    $self->secrets(['secretword']);

  # Documentation browser under "/perldoc"
    $self->plugin('PODRenderer');

  # Router
    my $r = $self->routes;

  # ブリッジでどこにアクセスするにも認証チェック
      $r->get('/join')->to('root#join');
      $r->post('/newjoin')->to('root#newjoin');
      $r = $r->under->to('root#login');
    
  # '/'は'index'に飛ぶようにする
    $r->any('/')->to('bbs#index')->name('index');

  # ログアウトはまぁそのまま
    
    $r->get('/logout')->to('root#logout');

    #$r->get('/')->to('bbs#index');
    $r->post('/create')->to('bbs#create');
    $r->post('/thread')->to('bbs#thread');




}

1;

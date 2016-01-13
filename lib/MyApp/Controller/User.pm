package MyApp::Controller::User;
use Mojo::Base 'Mojolicious::Controller';

# ログイン共通
sub init {
  my $self = shift;


  # ログイン処理独自のcssを設定
  $self->stash->{cssfiles} = ["user"];

}

# ログインページ
sub index {
  my $self = shift;

  # セッションをすべて破棄
  $self->session(expires => 1);

  # view適用
  $self->render();

}

# ログイン処理
sub login {
  my $self = shift;

  my $login = $self->param('login');
  my $password = $self->param('password');

  # きちんとした認証処理はそのうち実装
  if($login eq "root" && $password eq "password"){
    # session
    $self->session->{auth} = {
        user => 'root'
    };

    # ログイン成功後はTOPへ遷移
    $self->redirect_to('/');

  }else{
    # ログイン画面へ戻る
    $self->redirect_to('/login');
  }

}

# ログアウト処理
sub logout {
  my $self = shift;

  # セッションをすべて破棄
  $self->session(expires => 1);

  # ログイン成功後はTOPへ遷移
  $self->redirect_to('/login');

}

1;

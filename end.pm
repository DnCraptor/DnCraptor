# ver 1.0.0
package End {
use strict;
sub close {
my ($temp,$data)=@_;
my %data=%{$data};
my $browser=$data{'browser'};
my $params=$data{'params'};
my $headers=$data{'headers'};
my $id=$data{'id'};
my $url ="http://www.the-game.ru/logoff/$id";
my $response = $browser->get($url, $params, $headers);
}
1;
}
# logovo10,logovo,Fleete
# ver 2.0.0
package Info_rasa {
use strict;
sub rasa {
my ($temp,$data)=@_;
my %info_rasa=();
my %data=%{$data};
my $id=$data{'id'};
my $browser=$data{'browser'};
my $params=$data{'params'};
my $headers=$data{'headers'};
my ($industry_nature,$unused_resource,$id_rasa,$name_rasa,$t_optimal_min,$t_optimal_max,$t_optimal,$t_delta,$bonus_speed,$bonus_price,$bonus_iq,$bonus_build_peace,$bonus_build_war,$bonus_hp,$bonus_multiply,$bonus_inviz,$bonus_detect,$bonus_attack,$bonus_defender,$bonus_popul,$food_resource,$sred_temp,$info_race);
my $url="http://www.the-game.ru/blackframes/res_count/on/1/";
my $response = $browser->get($url, $params, $headers);
my $res = $response->as_string;
if ($res =~ m#mn:\'(.*?)\',#){$industry_nature=$1;}
if ($res =~ m#sn:\'(.*?)\',#){$unused_resource=$1;}
$url ="http://www.the-game.ru/frames/playerinfo/on/$id";
$response = $browser->get($url, $params, $headers);
$res = $response->as_string;
if ($res =~ m#raceinfo/on/(.*?)"#){$id_rasa=$1;}
$url ="http://www.the-game.ru/frames/raceinfo/on/$id_rasa";
$response = $browser->get($url, $params, $headers);
$res = $response->as_string;
if ($res =~ m#h1\>(.*?)\<#){$name_rasa=$1;}
if ($res =~ m#информация о расе (.*?)\<#){$name_rasa=$1;}
if ($res =~ m#температура\</td\>\<td align="right"\>(.*?)°#){$t_optimal_min=$1;}
if ($res =~ m#– (.*?)°#){$t_optimal_max=$1;}
$t_optimal=($t_optimal_max+$t_optimal_min)/2;
$t_delta=($t_optimal_max-$t_optimal_min)/2;
if ($res =~ m#полета(.*?)nobr\>(.*?)%#){$bonus_speed=$2;}
if ($res =~ m#Цены(.*?)nobr\>(.*?)%#){$bonus_price=$2;}
if ($res =~ m#Наука(.*?)nobr\>(.*?)%#){$bonus_iq=$2;}
if ($res =~ m#мирного производства(.*?)nobr\>(.*?)%#){$bonus_build_peace=$2;}
if ($res =~ m#военного производства(.*?)nobr\>(.*?)%#){$bonus_build_war=$2;}
if ($res =~ m#построек(.*?)nobr\>(.*?)%#){$bonus_hp=$2;}
if ($res =~ m#Добыча ресурсов(.*?)nobr\>(.*?)%#){$bonus_multiply=$2/100;} # new
if ($res =~ m#Невидимость(.*?)nobr\>(.*?)%#){$bonus_inviz=$2;}
if ($res =~ m#Обнаружение невидимок(.*?)nobr\>(.*?)%#){$bonus_detect=$2;}
if ($res =~ m#Повреждения(.*?)nobr\>(.*?)%#){$bonus_attack=$2;}
if ($res =~ m#системы(.*?)nobr\>(.*?)%#){$bonus_defender=$2;}
if ($res =~ m#популяции(.*?)nobr\>(.*?)%#){$bonus_popul=$2;}
$food_resource='m'; 
if ("$industry_nature,$unused_resource,$food_resource" !~ 'o' )  {$food_resource='o';}
if ("$industry_nature,$unused_resource,$food_resource" !~ 'e' )  {$food_resource='e';}
$sred_temp=($t_optimal_min+$t_optimal_max)/2;
%info_rasa = 		(industry_nature =>$industry_nature,
					unused_resource=>$unused_resource,
					id_rasa=>$id_rasa,
					name_rasa=>$name_rasa,
					t_optimal_min=>$t_optimal_min,
					t_optimal_max=>$t_optimal_max,
					t_optimal=>$t_optimal,
					t_delta=>$t_delta,
					bonus_speed=>$bonus_speed,
					bonus_price=>$bonus_price,
					bonus_iq=>$bonus_iq,
					bonus_build_peace=>$bonus_build_peace,
					bonus_build_war=>$bonus_build_war,
					bonus_hp=>$bonus_hp,
					bonus_multiply=>$bonus_multiply,
					bonus_inviz=>$bonus_inviz,
					bonus_detect=>$bonus_detect,
					bonus_attack=>$bonus_attack,
					bonus_defender=>$bonus_defender,
					bonus_popul=>$bonus_popul,
					food_resource=>$food_resource,
					sred_temp=>$sred_temp,
 );
return(\%info_rasa);
 }
 1;
 }
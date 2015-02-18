# ver 2.0.0
package Empire{        
use strict;

 sub fake {
  my ($url,$browser,$id); 
 my $referer = 'http://www.the-game.ru';
 my %empire=();
 my ($nic,$hw,$turn,$nam,$planet,$people,$mail,$war,$tu,$etu,$perv,$pervp,$pervm,$sec,$secp,$secm,$money,$moneyp,$moneym,$industry_nature,$unused_resource);
 my ($temp,$user,$pass) = @_;
use LWP::UserAgent;
use HTTP::Cookies;
 $browser = LWP::UserAgent->new();
 my %params = (
    'action' => 'login',
    'login'  => $user,
    'pwd'    => $pass,
);
my $cont_len = length(\%params)+19;
 $browser->agent('User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Firefox/24.0');
my %headers = (
    'Accept-Language' => 'ru-RU,ru;q=0.8,en-US;q=0.5,en;q=0.3',
    'Accept-Encoding' => 'gzip, deflate',
    'Referer'         => $referer,
    'Cache-Control'   => 'max-age=0',
    'Accept-Charset'  => 'windows-1251,utf-8;q=0.7,*;q=0.3',
    'Content-Type'    => 'application/x-www-form-urlencoded',
	'Content-Length'  => $cont_len,
);
 my ($params,$headers)=(\%params, \%headers);
 my $response = $browser->post("$referer/overview", $params,$headers);
 my $res = $response->as_string;
if ($res =~ m#var PlayerId=(.*?);#){$id=$1;}
if ($res =~ m#planetid=(.*?)\&amp#){$hw=$1;} # формат через :
if ($res =~ m#var TurnN=(.*?)\;#){ $turn=$1;}
if ($res =~ m#D&C :: Разделяй и властвуй :: (.*?)\n#) {$nic=$1;}
$browser->cookie_jar(HTTP::Cookies->new(file => "temp.txt", autosave => 1, ignore_discard => 1));
%headers = (
     'Accept-Language' => 'ru-RU,ru;q=0.8,en-US;q=0.5,en;q=0.3',
     'Accept-Charset'  => 'windows-1251,utf-8;q=0.7,*;q=0.3',
	 "Referer"  => "Referer: $referer.overview/",
	 "Cache-Control"   => 'max-age=0',
	 "Connection"      => "keep-alive", 
 );
  ($params,$headers)=(\%params, \%headers);
$url ="$referer/communicator/$id";
$response = $browser->post($url, $params,$headers);
$res = $response->as_string;
if ($res =~ m#var TitleStr=\{m:\'(.*?)\', s:'(.*?)\', c:'(.*?)\'#) {
	if ($1 eq 'Минералы') {$industry_nature='m';}
	if ($1 eq 'Энергия') {$industry_nature='e';}
	if ($1 eq 'Органика') {$industry_nature='o';}
	if ($2 eq 'Минералы') {$unused_resource='m';}
	if ($2 eq 'Энергия') {$unused_resource='e';}
	if ($2 eq 'Органика') {$unused_resource='o';}
	}
if ($res =~ m#inbox_num_100(\d+)\)#){$mail=$1;}
if ($res =~ m#inbox_num_4(\d+)\)#){$war=$1;}
$url="http://www.the-game.ru/frames/userplanets/on/$id/?planetid=$hw&p=$id._0";
$response = $browser->get($url, \%params, \%headers);
$url="http://www.the-game.ru/frames/playerstats/on/$id/?planetid=$hw&p=$id._0";
$response = $browser->get($url, \%params, \%headers);
$res = $response->as_string;
if (($res =~ m#наместников\)\</td\>\<td class=\"reporttable\" align=\"right\"\>(.*?)\<#) or ($res =~ m#наместников\)\</span\>\</div\>\</div\>\<div class=\"gp-wdcr-right-column\"\>\<div class=\"gp-thin-blackbg-row\"\>\<div class=\"gp-tbr-content\"\>\<span\>(.*?)\<#)) {$nam=$1;}
if (($res =~ m#контролем\</td\>\<td class=\"reporttable\" align=\"right\"\>(.*?)\<#) or ($res =~ m#контролем\</span\>\</div\>\</div\>\<div class=\"gp-wdcr-right-column\"\>\<div class=\"gp-thin-blackbg-row\"\>\<div class=\"gp-tbr-content\"\>\<span\>(.*?)\<#)) {$planet=$1;}
if (($res =~ m#население\</td\>\<td class=\"reporttable\" align=\"right\"\>(.*?)\<#) or ($res =~ m#население\</span\>\</div\>\</div\>\<div class=\"gp-wdcr-right-column\"\>\<div class=\"gp-thin-blackbg-row\"\>\<div class=\"gp-tbr-content\"\>\<span\>(.*?)\<#)) {$people=$1; $people=~(s/\D//g);}
if (($res =~ m#уровень\</td\>\<td class=\"reporttable\" align=\"right\"\>(.*?)\<#) or ($res =~ m#Технологический уровень\</span\>\</div\>\</div\>\<div class=\"gp-wdcr-right-column\"\>\<div class=\"gp-thin-blackbg-row\"\>\<div class=\"gp-tbr-content\"\>\<span\>(.*?)\<#)){$tu=$1;}
if (($res =~ m#технология\</td\>\<td class=\"reporttable\" align=\"right\"\>(.*?)\<#) or ($res =~ m#технология\</span\>\</div\>\</div\>\<div class=\"gp-wdcr-right-column\"\>\<div class=\"gp-thin-blackbg-row\"\>\<div class=\"gp-tbr-content\"\>\<span\>(.*?)\<#)){$etu=$1;}
$url="$referer/blackframes/res_count/on/1/";
$response = $browser->get($url, $params, $headers);
$res = $response->as_string;
if ($res =~ (m#m0:\'(.*?)\',#)){$perv=$1; $perv=~(s/\D//g);}
if ($res =~ (m#m1:\'(.*?)\',#)){$pervp=$1; $pervp=~(s/\D//g);}
if ($res =~ (m#m2:\'(.*?)\',#)){$pervm=$1; $pervm=~(s/\D//g);}
if ($res =~ (m#s0:\'(.*?)\',#)){$sec=$1; $sec=~(s/\D//g);}
if ($res =~ (m#s1:\'(.*?)\',#)){$secp=$1; $secp=~(s/\D//g);}
if ($res =~ (m#s2:\'(.*?)\',#)){$secm=$1; $secm=~(s/\D//g);}
if ($res =~ (m#c0:\'(.*?)\',#)){$money=$1; $money=~(s/\D//g);}
if ($res =~ (m#c1:\'(.*?)\',#)){$moneyp=$1; $moneyp=~(s/\D//g);}
if ($res =~ (m#c2:\'(.*?)\',#)){$moneym=$1; $moneym=~(s/\D//g);}
print "acc $nic, hw $hw, turn $turn \n";
print "nam=$nam ; planet=$planet ; people=$people ; mail=$mail ; war=$war ; tu=$tu ; etu=$etu \n ";
print "$perv+$pervp-$pervm $sec+$secp-$secm $money+$moneyp-$moneym $industry_nature $unused_resource \n";
if ($war or $mail) {print "WARNING!!!!!!! \n";}
 %empire = 		(perv =>$perv,
				pervp=>$pervp,
				pervm=>$pervm,
				sec=>$sec,
				secp=>$secp,
				secm=>$secm,
				money=>$money,
				moneyp=>$moneyp,
				moneym=>$moneym,
				nic=>$nic,
				hw=>$hw,
				turn=>$turn,
				planet=>$planet,
				people=>$people,
				mail=>$mail,
				war=>$war,
				tu=>$tu,
				etu=>$etu,
				browser=>$browser,
				params=>$params,
				headers=>$headers,
				id=>$id
				);
return \%empire;
} 
 1;
 }

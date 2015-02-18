# ver 1.0.0
package Planet {
use strict;
#use info_rasa;
sub colony {
my @sorted_lengh;
my %geo_baza=();
my ($temp,$lengh_user,$dobyca_user,$prirost_user,$hw,$t_optimal,$t_delta,$industry_nature,$food_resource,$bonus_multiply,$second_resource)=@_;
my ($hwx,$hwy)=split /:/, $hw;
open FILE_s, "<d:/riv/w.csv"; 
my $csv = '';
$csv .= $_ while <FILE_s>;
my @str_geo = split /\n/, $csv; # разбиваем на строки 
close FILE_s;
foreach  (@str_geo){ # создаем базу планет	
my ($xy1,$x1,$y1,$o,$e,$m,$t,$s,$owner,$turn_geo) = undef;
	($x1,$y1,$o,$e,$m,$t,$s,$owner,$turn_geo)= split /;/,$_;
	if (($owner) or ($t<1) or ($s<70)) {next;}
	$xy1=join ";",($x1,$y1);
	$xy1=~s/;/:/;
	$geo_baza{$xy1} = { 	s=> $s,
							o=> $o,
							e=> $e,
							m=> $m,
							t=> $t,
							x=> $x1,
							y=> $y1,
	};   
}
foreach (keys %geo_baza){
	my $lengh=sqrt((($hwx-$geo_baza{$_}{'x'})**2)+($hwy-$geo_baza{$_}{'y'})**2);
	my $prirost=(2-abs($t_optimal-$geo_baza{$_}{'t'})/$t_delta)*$geo_baza{$_}{$food_resource}*0.05*(1+1.055)/4;
	my $dobyca=$geo_baza{$_}{'s'}*2000*(($geo_baza{$_}{$industry_nature}/900)**3)*(1+(0,4*$geo_baza{$_}{'s'}/50)*(1+$bonus_multiply/100));	
	print "$_ $lengh $prirost $dobyca\n";
	#Формула добычи на планете =население*СТЕПЕНЬ(ресурс/900;3)*(1+кол-во_добывалок*0,2)*(1+бонус_добычи/100)
	if (($geo_baza{$_}{$industry_nature}<$geo_baza{$_}{$food_resource}) or ($geo_baza{$_}{$industry_nature}<$geo_baza{$_}{$second_resource}) or ($prirost<$prirost_user) or ($dobyca<$dobyca_user) or ($lengh>$lengh_user) ) {delete($geo_baza{$_}); next;}
	
#	Начальный прирост населения на планете с температурой A1 и количеством еды A2:
#=ОКРУГЛ(МИН(1; 2-ABS(B2-A1)/B3)*A2*0,05*(1+B1/100)/ЕСЛИ(ABS(B2-A1)>2*B3; 2; 1);2)
#где B1, B2 и B3 – бонус прироста, средняя температура и комфортное отклонение от средней температуры соответственно. Прирост на планете размера A4 с населением A5:
#=ОКРУГЛ(МИН(1; 2-A5/A4/1000)*МИН(1; 2-ABS(B2-A1)/B3)*A2*0,05*(1+B1/100);2)
	$geo_baza{$_} = {dobyca => $dobyca,
						prirost=>$prirost,
						lengh=>$lengh,
						};							
}	
 @sorted_lengh = (sort {$geo_baza{$a}{'lengh'} <=>  $geo_baza{$b}{'lengh'}} keys %geo_baza);
return (\@sorted_lengh);
}
sub my_Planet {
my ($temp,$data)=@_;
my %data=%{$data};
my $id=$data{'id'};
my $browser=$data{'browser'};
my $params=$data{'params'};
my $headers=$data{'headers'};
my $hw=$data{'hw'};
my $url="http://www.the-game.ru/frames/userplanets/on/$id/?planetid=$hw&p=$id"."_0";
my $response = $browser->get($url, $params, $headers);
my $res = $response->as_string;
my @my_xy; 
my @str = split / \{/, $res; # пилим на строки
foreach (@str){
	while ($_ =~ m#x:(.*?),y:(.*?)}#g){push @my_xy,"$1,$2";}
}
return @my_xy;				
}
sub Open_Planet {
my ($temp,$data)=@_;
my %data=%{$data};
my $id=$data{'id'};
my $browser=$data{'browser'};
my $params=$data{'params'};
my $headers=$data{'headers'};
my $turn=$data{'turn'};
my $url="http://www.the-game.ru/blackframes/jumpable_planets/on/$id/?seed=$turn";
my $response = $browser->get($url, $params, $headers);
my $res = $response->as_string;
my @xy; 
my @str = split /1,a/, $res; # пилим на строки
foreach (@str){
	while ($_ =~ m#(\d+)_(\d+):#g){push @xy,"$1,$2";}
}
# {x:413,y:185}, {x:408,y:191}
return @xy;				
}
sub building {
my ($temp,$data)=@_;
my %data=%{$data};
my $id=$data{'id'};
my $browser=$data{'browser'};
my $params=$data{'params'};
my $headers=$data{'headers'};
my $url="http://www.the-game.ru/frames/my_buildings_in_progr/on/$id";
my $response = $browser->get($url, $params, $headers);
my $res = $response->as_string;
my @str = split /\n/, $res; # пилим на строки
my %building=(); 
foreach (@str){
	my $xy=0; my $how=0; my $turn=0; my $name=0;
	if ($_ =~ m#p(.*?):\{c:(\d+),dl:(\d+),n:\'(.*?)\'},#){
	
	#,n:'(.*?)'},#){
	 $xy=$1;  $how=$2;  $turn=$3;  $name=$4;
	print "my $xy=$1;  my $how=$2; my $turn=$3; my $name=$4; \n";
	$building{$xy}={
				how => $how,
				turn => $turn,
				name => $name
				};
	}
}
return (\%building);
}
# 	http://www.the-game.ru/frames/planet_buildings/on/planet/?planetid={XY_PLANET}&p={ID_PLAYER}_0
sub garrison {
my ($temp,$data,$planet)=@_;
my %data=%{$data};
my $id=$data{'id'};
my $browser=$data{'browser'};
my $params=$data{'params'};
my $headers=$data{'headers'};
my $planet='0:';
my $url="http://www.the-game.ru/frames/planet_buildings/on/planet/?planetid=$planet&p=$id"."_0";
my $response = $browser->get($url, $params, $headers);
my $res = $response->as_string;
return $res;
}
1;
}
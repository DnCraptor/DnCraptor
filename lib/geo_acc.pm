# ver 2.0.0
package Geo_acc {
use strict;

sub planets{
my ($temp,$data,$lengh_user,$point,$gigant,$mapa_adress)=@_;
my %data=%{$data};
my $browser=$data{'browser'};
my $params=$data{'params'};
my $headers=$data{'headers'};
my $id=$data{'id'};
my $turn=$data{'turn'};
my $nic=$data{'nic'};
my %geo_acc=();
my ($hwx,$hwy)=split /:/ ,$point; 
my $url ="http://www.the-game.ru/frames/skymap/on/army/?planetid=$point&p=$id"."_0";
my $response = $browser->get($url, $params, $headers);
my $res = $response->as_string;
my @str= split /\n/ , $res;
my $j2=0; my @sorted_keys;
 foreach (@str){
my ($o,$e,$m,$t,$s,$owner,$caption,$turn_geo,$xy_geo,$razmer,$ico)=0;
 $turn_geo=0;
 if ($str[$j2+6] =~ m#SelectPlanet\(\"(.*?)\"#){$xy_geo=$1; $xy_geo=~s/:/;/;}
 if ($str[$j2+6] =~ m#planets/(.*?)\.gif#){$razmer=substr($1,2)*10;}
 if ($str[$j2+6] =~ m#planets/(.*?)\.gif#){$ico=$1;}
  my ($x,$y)=split /;/ , $xy_geo;
 if ($str[$j2] =~ /(O:)(\d+)(; E:)(\d+)(; M:)(\d+)/){$o=$2; $e=$4; $m=$6;}
 if ($str[$j2+1] =~ /(T:)(\d+)(; S:)(\d+)(\" onclick)/){$t=$2; $s=$4;}
 if (($str[$j2+1] =~ m/whitedot/ ) or ($str[$j2+1] =~ m/Это/)){$turn_geo=$turn;}
 if ($str[$j2+1] =~m/не заселен/) {$owner=0;}
 if ($str[$j2+1] =~m#static\/img\/ico_dip_(.*).gif\" alt=\"(.*?) \(#) {$owner=$2;}
 if ($str[$j2+1] =~ m/Это ваша планета/) {$owner=$nic;}
  $geo_acc{$xy_geo} = { 		s=> $s,
							o=> $o,
							e=> $e,
							m=> $m,
							t=> $t,
							owner => $owner,
							turn_geo => $turn_geo,
							x=> $x,
							y=>$y,
							razmer=>$razmer,
							ico=>$ico
	};  
$j2++;
}
foreach my $geo (keys %geo_acc){	
if (!$geo)  {delete $geo_acc{$geo};}
if ($geo_acc{$geo}{'ico'} >910 and $geo_acc{$geo}{'ico'}<969) {delete $geo_acc{$geo};}
if ($geo_acc{$geo}{'razmer'} ==110) {delete $geo_acc{$geo};}
}
open FILE_baza, "<$mapa_adress";
 my $csv = '';
$csv .= $_ while <FILE_baza>;
close FILE_baza;
my @str = split /\n/, $csv; # разбиваем на строки 
my %geo_baza=();
foreach  (@str){ # создаем базу планет
my ($x1,$y1,$o,$e,$m,$t,$s,$owner,$turn_geo,$xy1,$lengh)=0;	
	 ($x1,$y1,$o,$e,$m,$t,$s,$owner,$turn_geo)= split /;/,$_;
	 $xy1=join ";",($x1,$y1);
	$geo_baza{$xy1} = { lengh => $lengh, 
							s=> $s,
							o=> $o,
							e=> $e,
							m=> $m,
							t=> $t,
							owner=> $owner,
							turn_geo=> $turn_geo,
							x=> $x1,
							y=> $y1,
	}; 
}
#----------запись в го базу новых данных 
open FILE_s, ">$mapa_adress"; 
# -------------ускорялка -----------------
foreach my $geo_b(keys %geo_baza){
my $lengh=sqrt((($hwx-$geo_baza{$geo_b}{'x'})**2)+(($hwy-$geo_baza{$geo_b}{'y'})**2));
#print "$lengh=sqrt((($hwx-$geo_baza{$geo_b}{'x'})**2)+(($hwy-$geo_baza{$geo_b}{'y'})**2)); \n";
#print "($lengh>10 or $geo_baza{$geo_b}{t}>1 or $geo_baza{$geo_b}{'s'}<$gigant ) \n";
	if ($lengh>$lengh_user or !$geo_baza{$geo_b}{t} or $geo_baza{$geo_b}{'s'}<$gigant ){
		print FILE_s "$geo_b;$geo_baza{$geo_b}{o};$geo_baza{$geo_b}{e};$geo_baza{$geo_b}{m};$geo_baza{$geo_b}{s};$geo_baza{$geo_b}{t};$geo_baza{$geo_b}{'owner'};$geo_baza{$geo_b}{'turn_geo'}\n";
		delete $geo_baza{$geo_b};
	}
}
#----------------------------------------
foreach my $geo (keys %geo_acc){
	foreach my $geo_b(keys %geo_baza){	
		if (($geo eq $geo_b) and ($geo_acc{$geo}{t})){	
			print FILE_s "$geo;$geo_acc{$geo}{o};$geo_acc{$geo}{e};$geo_acc{$geo}{m};$geo_acc{$geo}{s};$geo_acc{$geo}{t};$geo_acc{$geo}{owner};$geo_acc{$geo}{turn_geo} \n";
			delete $geo_baza{$geo_b};
			delete $geo_acc{$geo};
			last;
		}
	}
	if ($geo) {
		print FILE_s "$geo;$geo_acc{$geo}{o};$geo_acc{$geo}{e};$geo_acc{$geo}{m};$geo_acc{$geo}{s};$geo_acc{$geo}{t};$geo_acc{$geo}{owner};$geo_acc{$geo}{turn_geo} \n";
		push (@sorted_keys,$geo);
	}
}
close FILE_s;
@sorted_keys = (sort {$geo_acc{$b}{razmer} <=>  $geo_acc{$a}{razmer}} keys %geo_acc);
	foreach (keys %geo_acc){
		my $lengh=sqrt(($geo_acc{$_}{x}-$hwx)*($geo_acc{$_}{x}-$hwx)+($geo_acc{$_}{y}-$hwy)*($geo_acc{$_}{y}-$hwy));
		if ($lengh==0) {delete $geo_acc{$_};} # убираем ХВ
		$geo_acc{$_}{'lengh'}=$lengh;
	#	print "razmer, $xy_geo, $geo_acc{$xy_geo}{'razmer'} ,$geo_acc{$xy_geo}{'lengh'} \n";
@sorted_keys = (sort {$geo_acc{$a}{'lengh'} <=>  $geo_acc{$b}{'lengh'}} keys %geo_acc);
	}
#---------------------------------------
	return (@sorted_keys);
 }
 1;
 sub colony {
my ($temp,$data,$lengh_user,$dobyca_user,$prirost_user,$point,$mapa_adress,$info_rasa)=@_;
my %info_rasa=%{$info_rasa};
my $t_optimal=$info_rasa{'t_optimal'};
my $t_delta=$info_rasa{'t_delta'};
my $industry_nature=$info_rasa{'industry_nature'};
my $food_resource=$info_rasa{'food_resource'};
my $bonus_multiply=$info_rasa{'bonus_multiply'};
my $second_resource=$info_rasa{'second_resource'};
my @sorted_lengh;
my %geo_baza=();
my ($hwx,$hwy)=split /:/, $point;
open FILE_s, "<$mapa_adress"; 
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
	my $prirost=(2-abs($t_optimal-$geo_baza{$_}{'t'})/$t_delta)*$geo_baza{$_}{$food_resource}*0.05*(1+1.055)/4; # !!!! исправить бонус прироста
	my $dobyca=$geo_baza{$_}{'s'}*2000*(($geo_baza{$_}{$industry_nature}/900)**3)*(1+(0,4*$geo_baza{$_}{'s'}/50)*(1+$bonus_multiply/100));	
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
return (@sorted_lengh);
}
1;
 }
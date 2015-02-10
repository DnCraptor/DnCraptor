# ver 1.0.0
#!/usr/bin/perl
use lib ( 'd:\riv\lib','d:\riv\script','d:\riv\baza','d:\riv\pwd','d:\riv' );
my $dobyca_user=1300;
my $prirost_user=2;
my $adress_geo='d:\riv\pwd\w.csw';
my $pwd_adress='d:\riv\pwd\pwd.ini';
open FILE_baza, "<$adress_geo";
 $csv = '';
$csv .= $_ while <FILE_baza>;
close FILE_baza;
@str_geo = split /\n/, $csv; # разбиваем на строки 
#----------логин пароль--------
open FILE_PWD, '<pwd.ini';
my $str = '';
$str .= $_ while <FILE_PWD>;
my @qqq= split /\n/, $str; #  на строки
close(FILE_PWD);
my $counter= scalar @qqq;
$counter++;
foreach (@qqq){
print "accov $counter\n";
$counter--;
my @sorted_lengh=();
$_=~m/(\w+)(\,)(\w+)(\,)(\w+)/;
 $user=$1;
 $pass=$3;
 $col=$5;
 print "-- $user $pass $col \n";
#----------------------------------------                           
use Empire;
use Units;
use Fleets;
use Planet;
my ($data,$id)=Empire->fake($user,$pass);
my %data=%{$data};
my $id=$data{'id'};
my $units=Units->getProp();
my %units=%{$units};
my $fleet=Fleets->getProp($data,$id);
my %fleet=%{$fleet};
fleet: foreach $id_fleet (keys  %fleet){  # хэш флотов
	if (($fleet{$id_fleet}{'name_fleet'}!~$col) or ($fleet{$id_fleet}{turns_till_arrival} != 0)) {delete $fleet{$id_fleet}; next;}
	$fleet_xy="$fleet{$id_fleet}{'fleet_x'}:$fleet{$id_fleet}{'fleet_y'}";
	$lengh_user=$fleet{$id_fleet}{'fly_range'};	
	if (($fleet_xy ne $hw)and ($fleet{$id_fleet}{free_transport_capacity}==0)){ #не на ХВ и нет свободных ТЯ
		my @qq= split /,/, $fleet{$id_fleet}{'unit_fleet'}; #  на строки
		foreach $id_unit (@qq) {
			if (($unit{$id_unit}{'name_unit'}=~'Колония') or ($unit{$id_unit}{'name_unit'}=~'Ковчег'))			
		# тут нажать кнопку колонизация
		Units->colony($fleet_xy,$id_unit);				
				print "colonim planet $fleet_xy \n";
				last fleet;
				}
			}
		}		
		if (($fleet_xy ne $hw)and ($fleet{$id_fleet}{free_transport_capacity}!=0)){ #не на ХВ и есть свободные ТЯ
		# тут летим на хв
Fleets->jump($id_fleet,$hw);
		last fleet;
		}
if (($fleet_xy eq $hw)and ($fleet{$id_fleet}{free_transport_capacity}==0)){ #на ХВ и есть свободные ТЯ
	# тут погрузка колонии и вылет к планете колонизации
	foreach $id_unit (keys  %unit){ # хэш юниты, садим во флоты
		if ($unit{$id_unit}{name_unit}=~'Ко') {	
			foreach $id_fleet (keys  %fleet){  # хэф флотов		
				$url ="$referer/planet/?planetid=$hw&action=move_unit_to_fleet&fleet_id=$id_fleet&unit_id=$id_unit";
				$response = $browser->get($url, $params, $headers);
				$url ="$referer/planet/?planetid=$hw&action=move_fleet&fleet_id=$id_fleet&move_to=$sorted_lengh[0]";
				$response = $browser->get($url, \%params, \%headers);
				print "vylet colonit $sorted_lengh[0] \n";
				last fleet;
				# тут вылет к планете колонизации с максимальной добычей
			}
		}
	}
}
}
$url ="http://www.the-game.ru/logoff/";
 $response = $browser->get($url, \%params, \%headers);
}
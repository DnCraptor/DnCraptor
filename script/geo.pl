# Ver 1.0.1
#!/usr/bin/perl
my $pwd_adress='d:\riv\pwd\pwd41.ini';
my $mapa_adress='d:/riv/w.csv';
use strict;
use lib ( 'd:\riv\lib','d:\riv\script','d:\riv\baza','d:\riv\pwd','d:\riv' );
my $sorted=1; # если 1, то сортировка по размеру, иначе, сортировка по дальности
my $portal="port"; # должно содержаться в названии флота-мамки флот должен быть один, если его нет, то разведка вокруг ХВ
my $gigant=10; # минимальный размер планеты
my $name_zond='Зонд'; # маска для имени прототипа геолога, все флоты должны быть одинаковы
use Empire;
use Units;
use Fleets;
use Geo_acc;
use End;
#----------логин пароль--------
open FILE_PWD, "<$pwd_adress";
my $str = '';
$str .= $_ while <FILE_PWD>;
my @qqq= split /\n/, $str; #  на строки
my $count=(scalar @qqq)+1;
close(FILE_PWD);
foreach (@qqq){ # открываем список файлов
print "<> $count <>";
$count--;
$_=~m/(\w+)(\,)(\w+)(\,)(\w+)/;
my $user=$1;
my $pass=$3;
my $perv_name=$5;
#----------------------------------------                           
my ($data)=Empire->fake($user,$pass);
my %data=%{$data};
my $hw=$data{'hw'};
my $point=$hw;
#--------------определяем точку сбора--------------
my $fleets=Fleets->getProp($data);
my %fleets=%{$fleets};
foreach my $id_fleet (keys  %fleets){  # хэш флотов
	if ($fleets{$id_fleet}{'name_fleet'}=~$portal){ 	
		$point=$fleets{$id_fleet}{'point'};
		last;
	} 
}
# --------создаем флоты-----------------
my $units=Units->getProp($data);
my %units=%{$units};
my $fl=0;
uni: foreach my $id_unit (keys %units){ 
foreach my $id_fleet (keys  %fleets){  
		if ($fleets{$id_fleet}{unit_fleet} =~($id_unit)) { next uni; }} # если флот не пустой
	if ($units{$id_unit}{name_unit}=~$name_zond) { # имя юнита зонд
	Fleets->createNewFleet($data,$hw,$perv_name);
	$fl++;
		}
}
print "\n sozdano $fl fleet \n";
#----------------переносим юниты во флот------------------
my $uni=0;
$fleets=Fleets->getProp($data);
%fleets=%{$fleets};
foreach my $id_unit (keys %units){ 
	if ($units{$id_unit}{name_unit}=~$name_zond) {	
		foreach my $id_fleet (keys  %fleets){ 		
			if (($fleets{$id_fleet}{name_fleet} eq $perv_name) and ($fleets{$id_fleet}{turns_till_arrival}==0) and ($fleets{$id_fleet}{point} eq $hw) and !$fleets{$id_fleet}{unit_fleet}) {
			Units->moveUnitToFleet($data,$hw,$id_fleet,$id_unit);
$uni++;
		delete($fleets{$id_fleet});
		last;
		}	
	}
	}
}
print "pereneseno $uni unit vo fleet \n";
# определяем дальность полета флотов
my $lengh_user;
fleet: foreach my $id_fleet (keys  %fleet){  # хэш флотов
	if (($fleet{$id_fleet}{'name_fleet'}!~$perv_name) or ($fleet{$id_fleet}{turns_till_arrival} != 0)) {delete $fleet{$id_fleet}; next;}
	$lengh_user=$fleet{$id_fleet}{'fly_range'};		
}	
my @sorted_keys=Geo_acc->planets($data,$lengh_user,$point,$gigant,$mapa_adress);
my $ge=0;
my $j1=1;
foreach my $id_fleet (keys  %fleets){ 	# перебираем флоты
	if (($fleets{$id_fleet}{name_fleet} eq $perv_name) and ($fleets{$id_fleet}{turns_till_arrival}==0)){ # совпадает имя и стоит
#-----------георазведка и вылет домой--------------
		if  ($fleets{$id_fleet}{point} ne $point){ # если не на точке сбора разведываем и летим на точку сбора
			Units->geo($data,$fleets{$id_fleet}{'point'},$fleets{$id_fleet}{unit_fleet});
			Fleets->jump($data,$id_fleet,$fleets{$id_fleet}{point});
			$ge++;
		} 
		#  летим к новой планете
		$sorted_keys[$j1]=~s/;/:/;
		if (!$sorted_keys[$j1]) {last;}
		if  ($fleets{$id_fleet}{point} eq $point){ # если не на точке сбора разведываем и летим на точку сбора		
			Fleets->jump($data,$id_fleet,$sorted_keys[$j1]);
			$j1++;
		}
	}
}
$j1--;
print "razvedano $ge planet $hw\n";
print "vyleteli k $j1 planet \n ";
Empire->end($data);
}
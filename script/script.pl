#!/usr/bin/perl
use strict;
use lib ( 'd:\riv\lib','d:\riv\script','d:\riv\baza','d:\riv\pwd','d:\riv' );
my $portal='zzz';
my $name_zond='Пп'; # маска для имени прототипа геолога, все флоты должны быть одинаковы
use Empire;
use Units;
use Fleets;
use Colony;
my ($data,$id)=Empire->fake($user,$pass);
my %data=%{$data};
#----------логин пароль--------
open FILE_PWD, '<d:\riv\pwd.ini';
my $str = '';
$str .= $_ while <FILE_PWD>;
my @qqq= split /\n/, $str; #  на строки
close(FILE_PWD);
foreach (@qqq){
$_=~m/(\w+)(\,)(\w+)(\,)(\w+)/;
my $user=$1;
my $pass=$3;
my $perv_name=$5;
#----------------------------------------                           
my $point=my $hw=$data{$id}{'hw'};
my $units=Units->getProp($data,$id);
my %units=%{$units};
my $fleet=Fleets->getProp($data,$id);
my %fleet=%{$fleet};
#--------------определяем точку расселения--------------
foreach my $id_fleet (keys  %fleet){  # хэш флотов
	if ($fleet{$id_fleet}{'name_fleet'}=~$portal){ 	
		$point="$fleet{$id_fleet}{'fleet_x'}:$fleet{$id_fleet}{'fleet_y'}";
		last;
	} 
}
# --------создаем флоты-----------------
my $fl=0;
foreach my $id_unit (keys %units){ 
foreach my $id_fleet (keys  %fleets){  
		if ($fleets{$id_fleet}{unit_fleet} =~($id_unit)) { last; }} # если флот не пустой
	if ($units{$id_unit}{name_unit}=~$name_zond) { # имя юнита зонд
	my $url="http://www.the-game.ru/frames/planet_fleets/on/planet/?planetid=$hw&action=create_new_fleet&new_fleet_name=$perv_name";
	my $response = $browser->get($url, $params, $headers);
	$fl++;
		}
}
print "\n sozdano $fl fleet \n";
#----------------переносим юниты во флот------------------
my $uni=0;
$fleet=Fleets->getProp($data,$id);
%fleet=%{$fleet};
foreach my $id_unit (keys %units){ 
	if ($units{$id_unit}{name_unit}=~$name_zond) {	
		foreach my $id_fleet (keys  %fleets){ 		
			if (($fleets{$id_fleet}{name_fleet} eq $perv_name) and ($fleets{$id_fleet}{turns_till_arrival}==0) and ($fleets{$id_fleet}{point} eq $hw) ) {
		my $url ="http://www.the-game.ru/planet/?planetid=$hw&action=move_unit_to_fleet&fleet_id=$id_fleet&unit_id=$id_unit";
		my $response = $browser->get($url, $params, $headers);
$uni++;
		delete($fleets{$id_fleet});
		last;
		}	
	}
	}
}
print "pereneseno $uni unit vo fleet \n";
Empire->end;
}
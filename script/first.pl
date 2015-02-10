#!/usr/bin/perl
use lib ( 'd:\riv\lib','d:\riv\script','d:\riv\baza','d:\riv\pwd','d:\riv' );
use Empire;
use Units;
use Fleets;
use Geo_acc;
use Info_rasa;
use End;
my $pwd_adress='d:\riv\pwd.ini';
my $mapa_adress='d:\riv\w.csv';
my $prirost_user=2; # задаем минимальный прирост
my $dobyca_user=1000; # задаем минимальную добычу
#----------логин пароль--------
open FILE_PWD, "<$pwd_adress";
my $str = '';
$str .= $_ while <FILE_PWD>;
my @qqq= split /\n/, $str; #  на строки
my $count=scalar @qqq;
close(FILE_PWD);
foreach (@qqq){ # открываем список 
print "<> $count <>";
$count--;
$_=~m/(\w+)(\,)(\w+)(\,)(\w+)/;
my $user=$1;
my $pass=$3;
my $perv_name=$5;
#----------------------------------------  
my $data=Empire->fake($user,$pass);
my %data=%{$data};
my $point=$data{'hw'};
#--------------определяем дальность поиска планет--------------
my $fleet=Fleets->getProp($data);
my %fleet=%{$fleet};
my $units=Units->getProp($data);
my %units=%{$units};
foreach my $id_fleet (keys  %fleet){  # хэш флотов
print "next if (($fleet{$id_fleet}{turns_till_arrival}!=0) or ($fleet{$id_fleet}{'name_fleet'}!=$perv_name))$id_fleet \n";
}






}
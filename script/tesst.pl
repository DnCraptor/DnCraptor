#!/usr/bin/perl

use lib ( 'd:\riv\lib','d:\riv\script','d:\riv\baza','d:\riv\pwd','d:\riv' );
use Empire;
use Units;
use End;
my $pwd_adress='d:\riv\pwd.ini';
my $mapa_adress='d:\riv\w.csv';
#----------логин пароль--------
open FILE_PWD, "<$pwd_adress";
my $str = '';
$str .= $_ while <FILE_PWD>;
my @qqq= split /\n/, $str; #  на строки
my $count=scalar @qqq;
close(FILE_PWD);
foreach (@qqq){ # открываем список файлов
print "<> $count <>";
$count--;
$_=~m/(\w+)(\,)(\w+)(\,)(\w+)/;
my $user=$1;
my $pass=$3;
my $perv_name=$5;
#----------------------------------------  
my $data=Empire->fake($user,$pass);
open FILEs, '>ww.csv';
my $planet=Units->prototype($data);
my %planet=%{$planet};
foreach (keys %planet) {
#foreach (@planet) {
	print FILEs "!!  $_    | $planet{$_}{koord}  \n";
	}
  close FILEs;                      
End->close($data);
}

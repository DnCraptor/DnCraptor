package Fleets {
use strict;
sub getProp{ 
my ($temp,$data)=@_;
my %data=%{$data};
my $browser=$data{'browser'};

my $params=$data{'params'};
my $headers=$data{'headers'};
my $id=$data{'id'};
my %fleet=();
my $url="http://www.the-game.ru/frames/fetch_fleets/on/$id/";
my $response = $browser->get($url, $params, $headers);
my $res = $response->as_string;
my @str = split /\n/, $res; # пилим на строки
my ($unit_fleet,$id_fleet,$behaviour,$name_fleet,$fly_speed,$free_transport_capacity,$name_planet,$fly_range,$turns_till_arrival,$fleet_x,$fleet_y)=undef;
	foreach (@str){
		if ($_ =~ m#i:(.*?),#){ $id_fleet = $1;} else {next;}
		if ($_ =~ m#b:\'(.*?)\'#){ $behaviour = $1;}  # поведение флота
		if ($_ =~ m#\,n:\'(.*?)\'#){ $name_fleet=$1;} # имя флота
		if ($_ =~ m#sp:(.*?),#){ $fly_speed=$1;} # сорость флота
		if ($_ =~ m#tc:(.*?),#){  $free_transport_capacity=$1;} # свободные транспортные ячейки turns_till_arrival
		if ($_ =~ m#pn:\'N(.*?)\',#){ $name_planet=$1} # имя планеты назначения
		if ($_ =~ m#,r:(.*?),#){ $fly_range=$1;} # дальность полета
		if ($_ =~ m#ta:(.*?),#){ $free_transport_capacity=$1;} # время до прибытия	
		if ($_ =~ m#,x:(.*?),#){ $fleet_x=$1;} # координата x планеты прибытия
		if ($_ =~ m#,y:(.*?),#){ $fleet_y=$1;} # координата y планеты прибытия
		if ($_ =~ m#un:\[0,(.*?)],#){$unit_fleet=$1;} else {$unit_fleet=0;} # список юнитов
		$fleet{$id_fleet}=$id_fleet;
		my $point="$fleet_x:$fleet_y";
		$fleet{$id_fleet} = { 	behaviour => $behaviour, 
								free_transport_capacity => $free_transport_capacity, 
								name_fleet => $name_fleet, 
								xy_fleet => $name_planet, 
								turns_till_arrival => $turns_till_arrival, 
								unit_fleet =>$unit_fleet,
								fly_speed=>$fly_speed,
								fly_range=>$fly_range,
								fleet_x=>$fleet_x,
								fleet_y=>$fleet_y,	
								point=>$point,
		}; 
	}
	return (\%fleet);
}
 1;
 sub jump {
my ($temp,$data,$id_fleet,$point)=@_;
my %data=%{$data};
my $browser=$data{'browser'};
my $params=$data{'params'};
my $headers=$data{'headers'};
print "jump $id_fleet na $point \n";
my $url ="http://www.the-game.ru/planet/?planetid=$point&action=move_fleet&fleet_id=$id_fleet&move_to=$point";
my $response = $browser->get($url, $params, $headers);
 }
 1;
sub createNewFleet {
my ($temp,$data,$point,$perv_name)=@_;
my %data=%{$data};
my $browser=$data{'browser'};
my $params=$data{'params'};
my $headers=$data{'headers'};
print "sozdali na $point fleet $perv_name \n";
my $url="http://www.the-game.ru/frames/planet_fleets/on/planet/?planetid=$point&action=create_new_fleet&new_fleet_name=$perv_name";
my $response = $browser->get($url, $params, $headers);
}
1;
}
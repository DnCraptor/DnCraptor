# ver 1.0.0
package Units {
use strict;
sub getProp {
my ($temp,$data)=@_;
my %data=%{$data};
my $browser=$data{'browser'};
my $params=$data{'params'};
my $headers=$data{'headers'};
my $id=$data{'id'};
my %units=();
my $url="http://www.the-game.ru/overview/frames/fetch_units/on/$id/";
my $response = $browser->get($url, $params, $headers);
my $res = $response->as_string;
my @str = split /\n/, $res; # пилим на строки
my ($id_unit,$name_unit,$transport_capacity)=undef;
foreach (@str){
	if ($_ =~ m#i:(.*?),#){ $id_unit=$1;} else {next;}
	if ($_ =~ m#n:(.*?),#){ $name_unit=$1;}
	if ($_ =~ m#tc:(.*?),#){ $transport_capacity=$1;}
	$units{$id_unit}=$id_unit;
	$units{$id_unit} = { name_unit		=> $name_unit, 
						transport_capacity 	=> $transport_capacity,				
		}
}
return (\%units);
}
 1;
 sub colony {
my ($temp,$data,$fleet_xy,$id_unit)=@_;
my %data=%{$data};
my $browser=$data{'browser'};
my $params=$data{'params'};
my $headers=$data{'headers'};
my $id=$data{'id'};
my $url ="http://www.the-game.ru/planet/?planetid=$fleet_xy&action=store_action&unit_id=$id_unit&action_id=2&target=/frames/planet_fleets/on/planet/";
my $response = $browser->get($url, $params, $headers);
 }
 1;
sub moveUnitToFleet {
my ($temp,$data,$point,$id_fleet,$id_unit)=@_;
my %data=%{$data};
my $id=$data{'id'};
my $browser=$data{$id}{'browser'};
my $params=$data{$id}{'params'};
my $headers=$data{$id}{'headers'};
my $url ="http://www.the-game.ru/planet/?planetid=$point&action=move_unit_to_fleet&fleet_id=$id_fleet&unit_id=$id_unit";
my $response = $browser->get($url, $params, $headers);
}
1;
sub geo {
my ($temp,$data,$point,$id_unit)=@_;
my %data=%{$data};
my $id=$data{'id'};
my $browser=$data{$id}{'browser'};
my $params=$data{$id}{'params'};
my $headers=$data{$id}{'headers'};
my $url="http://www.the-game.ru/planet/?planetid=$point&action=store_action&unit_id=$id_unit&action_id=1&target=_top";
my $response = $browser->get($url, $params, $headers);
}
1;


sub prototype{ 
my ($temp,$data)=@_;
my %data=%{$data};
my $browser=$data{'browser'};
my $params=$data{'params'};
my $headers=$data{'headers'};
my $id=$data{'id'};
my $hw=$data{'hw'};


my %prototype=();
my $url="http://www.the-game.ru/frames/economyunits/on/$id/";
my $response = $browser->get($url, $params, $headers);
my $res = $response->as_string;
# my $res = $response->as_string;
my @str = split /\n/, $res; # пилим на строки
my $prototype; my $koord; my $id_prototype;
my %id_prototype=();
foreach (@str){
$koord='';
	if ($_ =~ m#HiddenUnits\[(.*?)]#){ 
		$prototype=$1;
		
		while ($_ =~ m#x:(\d+),y:(\d+)#g){
			 $koord="$koord $1,$2";
			}
$id_prototype{$prototype}=$prototype;
$id_prototype{$prototype} = { koord		=> $koord, 
#						transport_capacity 	=> $transport_capacity,				
		}
		}
		print $prototype;
}
return (\%id_prototype);
}
1;
}

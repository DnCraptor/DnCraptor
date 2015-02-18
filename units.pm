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
$url="http://www.the-game.ru/frames/planetinfo/on/planet/?planetid=$point&p=$id"."_0";
$response = $browser->get($url, $params, $headers);
$response = $response->as_string;
my @str = split /\n/, $response; # пилим на строки
my ($o,$m,$e,$s,$t,$owner);
my %geo=();
foreach (@str){
	if ($_ =~ m#Органика: (\d+)"#){ $o=$1;} 
	if ($_ =~ m#Энергия: (\d+)"#){ $e=$1;} 
	if ($_ =~ m#Минералы: (\d+)"#){ $m=$1;} 
	if ($_ =~ m#Температура: (\d+)"#){ $t=$1;} 
	if ($_ =~ m#Поверхность: (\d+)"#){ $s=$1;} 
#	if ($_ =~ m#frames/playerinfo/on/(\d+)\')\"\>(?*.)\<#){ $owner=$2;} 
#	frames/playerinfo/on/601272')">Помощникнейтрала<
	$geo{$point} = { 	s=> $s,
							o=> $o,
							e=> $e,
							m=> $m,
							t=> $t,
							owner=>$owner,
	};   			
}
return (\%geo);
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
my %prototypes=();
foreach (@str) {
my ($koord,$fleet_name,$fleet_id,$id_prototype)=undef;
  if ($_ =~ m#HiddenUnits\[(\d+)]#) { 
    my $prototype_id = $1;
    while ($_ =~ m#x:(\d+),y:(\d+)(,fleet:'(.*?)',fleet_id:(\d+))*#g) {
       $koord="$1:$2,$koord";
       $fleet_name="$4,$fleet_name";
       $fleet_id="$5,$fleet_id";      
    }
	 $prototypes{$prototype_id} = {
         koord       => $koord, 
         fleet_id    => $fleet_id,
         fleet_name  => $fleet_name
      };
  }
}
return (\%prototypes);
	#{planet:'N569:100',x:569,y:100},{planet:'N569:100',x:569,y:100},
	#{planet:'N523:147',x:523,y:147,fleet:'кол',fleet_id:318796},{planet:'N522:149',x:522,y:149,fleet:'кол',fleet_id:325552},
#return @str;
}
1;
}

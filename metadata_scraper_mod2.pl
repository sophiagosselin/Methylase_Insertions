#!/usr/bin/perl

my $input= $ARGV[0];
my @allnames;
open(IN, "< $input");
while(<IN>){
    my($phagename)=($_);
    $phagename =~ s/\s//g;
    push(@allnames, $phagename);

}
print "@allnames";
close IN;

open(OUT, "+> metadata.table");
foreach my $pname (@allnames){
  print "\n$pname in progress\n";
  system("curl https://phagesdb.org/api/phages/$pname/ > temp_api.out");
  open(API, "< temp_api.out");
  while(<API>){
  #print "$_\n";
    my($name)=($_=~/"phage_name"\:(.*?)[\,\}]/);
    my($cluster)=($_=~/"cluster"\:(.*?)[\,\}]/);
    my($subcluster)=($_=~/"subcluster"\:(.*?)[\,\}]/);
    my($city)=($_=~/"found_city"\:(.*?)[\,\}]/);
    my($state)=($_=~/"found_state"\:(.*?)[\,\}]/);
    my($country)=($_=~/"found_country"\:(.*?)[\,\}]/);
    my($lat)=($_=~/"found_GPS_lat"\:(.*?)[\,\}]/);
    my($long)=($_=~/"found_GPS_long"\:(.*?)[\,\}]/);
    print OUT "$name\t$cluster\t$subcluster\t$city\t$state\t$country\t$lat\t$long\n";
  }
  close API;
  #unlink(temp_api.out);
}
close OUT;

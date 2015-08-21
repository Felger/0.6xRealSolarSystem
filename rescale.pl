#!/usr/bin/perl

use strict;
use warnings;

#Purpose of this file is to rescale the Real Solar System by the set amount.
sub RSSKopernicus;
my $scale = 0.6;
my $atmscale = 92/130;
my @scalevars = ("radius",
                 "semiMajorAxis",
                 "flyingAltitudeThreshold",
                 "spaceAltitudeThreshold",
                 "fadeStart",
                 "fadeEnd",
                 "innerRadius",
                 "innerRadius");
my $regex = "(".join('|',@scalevars).")";

#Do this file-by-file.

#PhysicsModifier.cfg
#RSSKopernicus.cfg

RSSKopernicus;


sub RSSKopernicus
{
    my ($RSScfg,$scalecfg);
    open($RSScfg,"<../RealSolarSystem/GameData/RealSolarSystem/RSSKopernicus.cfg");
    open($scalecfg,">RealSolarSystem_x_".$scale."/RSSKopernicus.cfg");
    while (my $line = <$RSScfg>)
    {
        #If line contains radius =, multiply by rad_scale

        if ($line =~ /$regex\s*=/)
        {
            my ($old) = $line =~ /=\s*(\d*).*$/;
            my $new = $old*$scale;
            $line =~ s/$old/$new/;
        }
        elsif ($line =~ /maxAltitude\s*=/)
        {
            my ($old) = $line =~ /=\s*(\d*).*$/;
            my $new = $old*$atmscale;
            $line =~ s/$old/$new/;
        }
        elsif ($line =~ /key\s*=/)
        {
            my ($key) = $line =~ /=(.*)$/;
            #print $key."\n";
            $key =~ s/\/\/.*$//g; #Remove comments
            $key =~ s/^\s*|\s*$//g; #Remove leading/trailing whitespace.
            my @key = split(/\s+/,$key);
            my @newkey;
            $newkey[0] = $key[0]*$atmscale;
            $line =~ s/$key[0]/$newkey[0]/;
            if (scalar(@key)>2)
            {
                #Only run if key has slopes.
                $newkey[2] = $key[2]/$atmscale;
                $newkey[3] = $key[3]/$atmscale;
                $line =~ s/$key[2]/$newkey[2]/;
                $line =~ s/$key[3]/$newkey[3]/;
            }
        }
        print $scalecfg $line;
    }
    close $RSScfg;
    close $scalecfg;
}
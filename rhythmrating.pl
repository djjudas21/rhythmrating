#!/usr/bin/perl -wT
use strict;
use warnings;
use Data::Dumper;
use XML::Hash;

my $path = '/home/jonathan/.local/share/rhythmbox/rhythmdb.xml';

# load
open my $fh, '<', $path;
binmode $fh; # drop all PerlIO layers possibly created by a use open pragma

my $xml_converter = XML::Hash->new();

# Convertion from a XML String to a Hash
my $xml_hash = $xml_converter->fromXMLStringtoHash($fh);
 
# Go through $doc and sort each track into a tree like
# album => track => rating
# skip any without an album or a rating
#
# <rhythmdb>
#   <entry type="song">
#    <title>Bridge Over Troubled Water</title>
#    <genre>Teen Pop</genre>
#    <artist>Hear'Say</artist>
#    <album>[non-album tracks]</album>
#    <track-number>15</track-number>
#    <disc-number>1</disc-number>
#    <disc-total>1</disc-total>
#    <duration>291</duration>
#    <file-size>4673468</file-size>
#    <location>file:///home/jonathan/Music/Hear'Say/%5Bnon-album%20tracks%5D/15%20Bridge%20Over%20Troubled%20Water.mp3</location>
#    <mtime>1530819647</mtime>
#    <first-seen>1483479600</first-seen>
#    <last-seen>1561971479</last-seen>
#    <rating>3</rating>
#    <play-count>1</play-count>
#    <last-played>1535012639</last-played>
#    <bitrate>128</bitrate>
#    <date>730486</date>
#    <media-type>audio/mpeg</media-type>
#    <mb-trackid>b9c7cf5c-c736-4d8f-93ad-37ff3eff74bd</mb-trackid>
#    <mb-artistid>7e95e908-bc59-4881-a5f6-b545acc56154</mb-artistid>
#    <mb-artistsortname>Hear'Say</mb-artistsortname>
#    <comment>000004EC 00000554 0000162C 0000196F 00029855 00029827 00004D2A 0000516A 0003F7A0 0003F7E5</comment>
#    <album-artist>Hear'Say</album-artist>
#    <composer>Paul Simon</composer>
#  </entry>
# </rhythmdb>
#
#print Dumper($xml_hash);

#slice
my $entries = %$xml_hash{rhythmdb}->{entry};
#foreach my $key (keys %$xml_hash{rhythmdb}) {
#	print "$key\n";
#}

foreach my $key (keys %$entries) {
        print "$key\n";
}



# Then go through the new hash tree and calculate the mean rating for each album
# and store this in a new tree

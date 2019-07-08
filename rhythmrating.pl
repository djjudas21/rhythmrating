#!/usr/bin/perl -wT
use strict;
use warnings;
use Data::Dumper;
use XML::Simple;

my $path = '/home/jonathan/.local/share/rhythmbox/rhythmdb.xml';

# XML::Simple
my $ref = XMLin($path, KeyAttr => { entry => 'location' } );

# Slice
my $entries= $ref->{entry};
#print Dumper($entries);

my $rowcount = scalar keys %$entries;
print "Found $rowcount rows\n";

# Go through XML import and sort each track into a hash, keyed on album name, containing an
# array of valid ratings for that album. Skip any without an album or a rating.
my %ratingsbyalbum = ();
foreach my $entry (keys %$entries) {
	if ($entries->{$entry}->{title} && $entries->{$entry}->{album} && $entries->{$entry}->{rating}) {
		next if $entries->{$entry}->{album} eq '[non-album tracks]';
		my $title = $entries->{$entry}->{title};
		my $album = $entries->{$entry}->{album};
		my $rating = $entries->{$entry}->{rating};

		push (@{$ratingsbyalbum{$album}}, $rating);
	}
}

# Then go through the new hash and calculate the mean rating for each album and store this in a new hash
# as a simple key-value
my %averages = ();
while (my ($album, $ratings) = each %ratingsbyalbum) {

	my $num_ratings = @$ratings;

	my $sum_ratings = 0;
	foreach (@$ratings) {
		$sum_ratings += $_;
	}

	my $ave_rating = $sum_ratings / $num_ratings;

	$averages{$album} = $ave_rating;
}

# Finally print the sorted hash
foreach my $key (sort { $averages{$b} <=> $averages{$a} } keys %averages) {
	printf "%.2f %s\n", $averages{$key}, $key;
}

#!/usr/bin/perl -wT
use strict;
use warnings;
use XML::Simple;
use Getopt::Long;

# Parse command line arguments
my $top = 0;
my $bottom = 0;
my $normalise = 0;
GetOptions (
	'top=i' => \$top,
	'bottom=i' => \$bottom,
	'normalise' => \$normalise,
);

# Path to Rhythmbox config
my $path = $ENV{"HOME"} . '/.local/share/rhythmbox/rhythmdb.xml';

# XML::Simple
print "Reading Rhythmbox database...\n";
my $ref = XMLin($path, KeyAttr => { entry => 'location' } );

# Slice
my $entries= $ref->{entry};

my $rowcount = scalar keys %$entries;
print "Found $rowcount tracks. Processing...\n";

# Go through XML import and sort each track into a hash, keyed on album name, containing an
# array of valid ratings for that album. Skip any without an album or a rating.
my %ratingsbyalbum = ();
foreach my $entry (keys %$entries) {
	if ($entries->{$entry}->{title} && $entries->{$entry}->{album} && $entries->{$entry}->{rating}) {
		next if $entries->{$entry}->{album} eq '[non-album tracks]';
		next if $entries->{$entry}->{album} eq 'Unknown';
		next if $entries->{$entry}->{comment} eq 'Single';
		my $title = $entries->{$entry}->{title} // 'Unknown title';
		my $album = $entries->{$entry}->{album} // 'Unknown album';
		my $albumartist = $entries->{$entry}->{'album-artist'} // 'Unknown artist';
		my $rating = $entries->{$entry}->{rating};
		push (@{$ratingsbyalbum{"$albumartist - $album"}}, $rating);
	}
}
my $albumcount = scalar keys %ratingsbyalbum;
print "Sorted these tracks into $albumcount albums\n\n";

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

	if ($normalise) {
		$averages{$album} = &normalise($ave_rating);
	} else {
		$averages{$album} = $ave_rating;
	}
}

if ($top) {
	# Finally print the sorted hash
	my $i = 0;
	foreach my $key (sort { $averages{$b} <=> $averages{$a} } keys %averages) {
		printf "%.2f %s\n", $averages{$key}, $key;
		$i++;
		last if ($i == $top);
	}
} elsif ($bottom) {
	# Finally print the sorted hash
	my $i = 0;
	foreach my $key (reverse sort { $averages{$b} <=> $averages{$a} } keys %averages) {
		printf "%.2f %s\n", $averages{$key}, $key;
		$i++;
		last if ($i == $bottom);
	}
} else {
	# Finally print the sorted hash
	foreach my $key (sort { $averages{$b} <=> $averages{$a} } keys %averages) {
		printf "%.2f %s\n", $averages{$key}, $key;
	}
}

# Rhythmbox lets you rate 1-5 stars so we can expand this range out to 0-10
sub normalise {
	my $in = shift;
	return ($in-1) / 4 * 10;
}

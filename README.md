# RhythmRating

Calculate average album ratings from Rhythmbox metadata

Rhythmbox allows users to rate individual tracks from 1-5 stars. It allows users to sort and filter their collection by track rating. However it does not offer
a way to sort and filter the collection by average album rating.

This is not a Rhythmbox plugin, but just a helper script that can calculate and display average album ratings, to help you make decisions about your music
library.

RhythmRating must be run on the same system that Rhythmbox is installed on. It will automatically locate the Rhythmbox database in `~/.local/share/rhythmbox/rhythmdb.xml`.

## Requirements

This script does not need to be installed and can be run from anywhere on your system. It requires the `XML::Simple` and `Getopt::Long` Perl modules.

On Fedora, these can be installed with:

```sh
sudo dnf install perl-XML-Simple perl-Getopt-Long
```

On Ubuntu, they can be installed with:

```sh
sudo apt-get install libxml-simple-perl
```

## Usage

List the average ratings of all albums, descending
```sh
./rhythmrating
5.00 Vangelis - L'Apocalypse des animaux
5.00 Queen - Greatest Hits
4.80 Lange feat. Skye - Drifting Away
...
1.57 Egg - The Civil Surface
1.50 Blue Mink - Melting Pot
1.00 Choir of St Mary's, Fishponds - The Way of the Cross
```

List the average ratings of the top 10 albums, descending
```sh
./rhythmrating.pl --top 10
Reading Rhythmbox database...
Found 11944 tracks. Processing...
Sorted these tracks into 725 albums

5.00 Vangelis - L'Apocalypse des animaux
5.00 Queen - Greatest Hits
4.80 Lange feat. Skye - Drifting Away
4.71 Yes - Going for the One
4.50 Apathy Point - Resolve EP
4.50 Moby - Natural Blues Promo 1
4.50 Delerium feat. Sarah McLachlan - Silence: Remixes by Airscape and DJ Ti�sto
4.50 Amy Winehouse - Lioness: Hidden Treasures
4.33 SuReal - You Take My Breath Away
4.33 Alice DeeJay - Celebrate Our Love
```

List the average ratings of the bottom 20 albums, ascending
```
./rhythmrating.pl --bottom 5
Reading Rhythmbox database...
Found 11944 tracks. Processing...
Sorted these tracks into 725 albums

1.00 Choir of St Mary's, Fishponds - The Way of the Cross
1.50 Blue Mink - Melting Pot
1.57 Egg - The Civil Surface
1.62 Various Artists - Now That's What I Call Music! 32
1.67 Playing for Change - Songs Around the World
```

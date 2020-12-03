#!/usr/bin/perl
# Usage: assemblystats.pl inputfile > outputfile
# use wildcards to get stats for many files
# Output: FileName FileSize AssemblySize NumContigs N50 N90

use strict; 
if (@ARGV == ()) {die "Usage: assemblystats.pl inputfile \n    use wildcards to get stats for many files\n"}

my ( $Filename, $len, $total, @x, $countcontigs, $j, $count,$half ) ;
print "FileName\tFileSize\tAssemblySize\tNumContigs\tN50\tN90\n" ;

foreach $Filename(@ARGV) {
	($len,$total)=(0,0);
	@x = () ; $countcontigs = 0;
	open (INFILE, "<$Filename") or die "Cannot open file $Filename \n" ; my $Fsize = -s "$Filename" ;
	while(<INFILE>){
		chomp($_) ;
		if(/^[\>\@]/){ $countcontigs = $countcontigs + 1; 
			if($len>0){ $total+=$len; push @x,$len; }
			$len=0; 
		} else { s/\s//g; $len+=length($_); }
	}

	if ($len>0){ $total+=$len; push @x,$len; }

	@x=sort{$b<=>$a} @x;
	($count,$half)=(0,0);
	for ($j=0;$j<@x;$j++){
		$count+=$x[$j];
		if (($count>=$total/2)&&($half==0)){ 
			print "$Filename\t$Fsize\t$total\t$countcontigs\t$x[$j]\t";
			# prints out input_filename, filesize and N50 label and value
			$half=$x[$j]
		}elsif ($count>=$total*0.9){ print "$x[$j]\n"; last; }
} 
close INFILE ;
}

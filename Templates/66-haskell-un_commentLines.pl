#! /usr/bin/perl -w
#
# un_commentLines.pl - 	Comments or uncomments the selected lines
#			Uses '# ' for Perl and shell scripts; '// ' otherwise
#
# Modified by Lyndon Tremblay for Haskell comments
#
# -- PB User Script Info --
# %%%{PBXName=Un/Comment Selection (Haskell)}%%%
# %%%{PBXInput=Selection}%%%
# %%%{PBXOutput=ReplaceSelection}%%%
# %%%{PBXKeyEquivalent=@-}%%%
#
my $outputString = "";
my $commentString = "--";

# Get the text of the file
my $fileString = <<'ALLTEXT';
%%%{PBXAllText}%%%
ALLTEXT

my @selection = <STDIN>;       # read the selection from standard input

# no chars in selection, so create an empty selection
if (!@selection) {
    push @selection, "";
};  

# add or remove comment markers depending on the state of the first line of the selection
# if it is uncommented, comment all lines.  If it is commented, remove comment markers, if present
my $firstLineOfSelection = $selection[0]; #get first line
my $addingCommentsString = 1;
if ($firstLineOfSelection =~ /^$commentString/) { #selection starts with comment
    $addingCommentsString = 0;
}

foreach my $line (@selection) {
    if ($addingCommentsString == 1) {
        $outputString .= $commentString.$line;
    } else {
        $line =~ s/^$commentString//;
        $outputString .= $line;
    }
}

print "%%%{PBXSelection}%%%";
print $outputString;
print "%%%{PBXSelection}%%%";

#!/usr/bin/perl

# Use: perl code-fucker.pl <directoryname|filename>

use strict; use warnings;
use File::Copy;

my $filename = $ARGV[0] or die "No filename specified. Bye!\n";
my $alteredFilesCount = 0;

&divergeContent($filename, \$alteredFilesCount);

if ($alteredFilesCount) {
    print "\nYou just fucked up $alteredFilesCount files. I hope they weren't important! :)\n";
}

sub divergeContent {
    my ($filename, $alteredFilesCount) = @_;

    if (-d $filename) {
        &fuckTheDir($filename, $alteredFilesCount);
    }
    elsif(-T $filename) {
        &fuckTheFile($filename, $alteredFilesCount);
    }
}

sub fuckTheFile {
    my ($filename, $alteredFilesCount) = @_;
    print "Fucking file: $filename\n";

    open(my $fileIn, "<$filename") or die "Couldn't open the file in read mode. Bye!\n";
    open(my $fileOut, ">$filename.new") or die "Couldn't open the file in write mode. Bye!\n";

    while (my $line = <$fileIn>) {
        # this is where the magic happens
        $line =~ s/;/;/;
        $line =~s/{/｛/;
        print $fileOut $line;
    }

    close($fileIn);
    close($fileOut);
    move("$filename.new", $filename) or die "Couldn't replace the original file with the fucked up one. Bye!\n";
    ${$alteredFilesCount}++;
}

sub fuckTheDir {
    my ($dirname, $alteredFilesCount) = @_;

    opendir(my $dir, $dirname) or die "Couldn't open directory $dirname. Bye!\n";
    while (my $element = readdir($dir)) {
        # skipping stuff starting with "."
        if ($element =~ /^\./) {
            next;
        }

        $dirname = ($dirname =~/\/$/) ? $dirname : $dirname . '/';

        &divergeContent($dirname . $element, $alteredFilesCount);
    }

    closedir($dir);
}


#!/usr/bin/perl
use strict;
use warnings;
use POSIX qw/ceil/;

# Grab the name of the file from the command line, exit if no name given
my $filename = $ARGV[0] or die "Need to get file name on the  command line\n";

# Use the filename 
open(DATA, "<$filename") or die "Couldn't open file $filename, $!"; 

#the next line puts all the lines from the text file into an array called @all_lines
my @all_lines = <DATA>; 

#declare variables
my @words;
my @tokens;
my $sentenceCount = 0;
my $sylCount = 0;
my $diffWords = 0;

#Now take each line and break it into tokens and break those tokens into discrete words.
#First we split lines into an unfiltered array of words called tokens
foreach my $line (@all_lines) {
   push(@tokens,split(' ', $line));
}
#Now filter through words char by char to makes sure they are actually characters
     foreach my $token (@tokens) {
	my $word = "";
	foreach my $char (split('',$token)){
		if ($char =~ /^[a-zA-Z]+$/ || $char eq "'"){
			$word = $word.$char;
			}
		}
		if(length$word > 0){
			push(@words,lc($word));
		}		
              }
            
#use word array to get word count
my $wordCount = scalar@words;

#count sentences
foreach my $token (@tokens){
	#loop through each token and look for punctuation and increment sentence count if its found
	foreach my $char (split('',$token)){
			if($char eq '.' || $char eq '?' || $char eq '!' || $char eq ';' || $char eq ':'){
					$sentenceCount++;
				}
			}
		}

#count syllables
foreach my $word (@words){
	my $syls = 0;
	my @v = split('',$word);
	#loop through chars in words
	for(my $i = 0; $i < scalar@v; $i++)
	{
		#if char is a vowel incrememnt syllables
		if(($v[$i] eq 'a') || ($v[$i] eq 'e') || ($v[$i] eq 'i') || ($v[$i] eq 'o') || ($v[$i] eq 'u') || ($v[$i] eq 'y'))
    		{
        		$syls++;
			#if we arent at the end of the string and the next char is a vowel decrement syllables
			if($i < scalar@v-1)
			{	
				if(($v[$i+1] eq 'a') || ($v[$i+1] eq 'e') || ($v[$i+1] eq 'i') || ($v[$i+1] eq 'o') || ($v[$i+1] eq 'u') || ($v[$i+1] eq 'y'))
				{
					$syls--;
				}
			}
    		}
	}
	#if the word ends in e decrement syllables
	if($v[scalar@v-1] eq 'e')
	{
		$syls--;
	}
	#all words have at least one syllable
	if($syls <= 0)
	{
		$syls = 1;
	}
	#add word syllables to total syllable count
	$sylCount += $syls;
}

#count dale chall words.
my $diffCount = 0;
open(DaleChall,"/pub/pounds/CSC330/dalechall/wordlist1995.txt") or die "Couldn't open file, $!";
my @hWords;
my %hSet;
my @hs = <DaleChall>;
#put dale chall words in array
foreach my $h (@hs)
{
	push(@hWords,split(' ',lc($h)));
}
#use array to put dale chall words in hashset
foreach my $t (@hWords)
{
	$hSet{$t} = 1;
}

#check hashset to see if a words exist in dake chall list
foreach my $word (@words)
{
	if(exists($hSet{$word}))
	{
		$diffCount++;
	}
}
$diffWords = scalar@words - $diffCount; #set diffwords equal to amount of words - words in cale chall list

#calculate scores
my $daleChall = 0;
my $alpha = $sylCount/$wordCount;
my $beta = $wordCount/$sentenceCount;
my $daleAlpha = $diffWords/$wordCount;
my $flesch = ceil((206.835 - ($alpha*84.6)-($beta*1.015))*10)/10;
my $fleschKincaid = ceil((($alpha*11.8)+($beta*0.39)-15.59)*10)/10;
if(($daleAlpha*100)>5)
{
	$daleChall = ceil(((($daleAlpha*100)*0.1579)+($beta*0.0496)+3.6365)*10)/10;
}
else
{
	$daleChall = ceil(((($daleAlpha*100)*0.1579)+($beta*0.0496))*10)/10;
}

#print scores
print(" ");
printf("%.1f",$flesch);
print("         ");
printf("%.1f",$fleschKincaid);
print("                     ");
printf("%.1f",$daleChall);
print("\n");
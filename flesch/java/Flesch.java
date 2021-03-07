import java.util.*;
import java.io.*;
import java.util.ArrayList;
import java.util.Collections;
import java.lang.Math;

public class Flesch
{
	public static void main(String[] args)
	{
		//get filename from command line argument and declare variables
		Scanner in = new Scanner(System.in);
		String fileName = args[0];
		ArrayList<String> words = new ArrayList<String>();
		ArrayList<String> tokens = new ArrayList<String>();
		int wordCount = 0;
		int sentenceCount = 0;
		int sylCount = 0;
		int diffWords = 0;

		//count words, sentences, syllables, and hard words
		countWords(tokens,words,fileName);
		wordCount = words.size();
		sentenceCount = countSentences(tokens);
		sylCount = countSyls(words);
		diffWords = countDiffs(words);

		//calculate scores
		double daleChall = 0;
		double alpha = (double)sylCount/(double)wordCount;
		double beta = (double)wordCount/(double)sentenceCount;
		double daleAlpha = (double)diffWords/(double)wordCount;
		double flesch = Math.ceil((206.835-(alpha*84.6)-(beta*1.015))*10)/10;
		double fleschKincaid = Math.ceil(((alpha*11.8)+(beta*0.39)-15.59)*10)/10;
		if((daleAlpha*100)>5)
			daleChall = Math.ceil((((daleAlpha*100)*0.1579)+(beta*0.0496)+3.6365)*10)/10;
		else
			daleChall = Math.ceil((((daleAlpha*100)*0.1579)+(beta*0.0496))*10)/10;

		//print scores
		System.out.println(" " + flesch + "         " + fleschKincaid + "                     " + daleChall);
	}

	//method to count words
	public static void countWords(ArrayList<String> tokens, ArrayList<String> words, String fileName)
	{	
		File myFile = new File(fileName);
		String word2;
		try
		{
			//use buffered reader to read through bible
			BufferedReader fIn = new BufferedReader(new FileReader(fileName));
			while(fIn.ready())
			{
				String line = fIn.readLine();
				String word[] = line.split(" ");
				for(int i = 0; i < word.length; i++)
				{
					tokens.add(word[i]);
				
				word2 = "";
				//strip out non alphanumeric characters and add them to word arraylist
				for(int j = 0; j < word[i].length(); j++)
				{
					if(Character.isLetter(word[i].charAt(j)))
						word2 += (Character.toLowerCase(word[i].charAt(j)));
				}
				if(!word2.isEmpty())
				{	
					words.add(word2);
				}
				}
			}
		}	
		catch(FileNotFoundException e)
		{
			System.err.println("File not found");
		}
		catch(IOException e)
		{
			System.err.println(e.getMessage());
		}
	}

	//method to count sentences
	public static int countSentences(ArrayList<String> tokens)
	{
		int sentenceCount = 0;
		//loop through words char by char checking for punctiatin, if found increment sentence count
		for(int i = 0; i < tokens.size(); i++)
		{
			for(int j = 0; j < tokens.get(i).length(); j++)
			{
				if(tokens.get(i).charAt(j)=='.'||tokens.get(i).charAt(j)=='?'||tokens.get(i).charAt(j)=='!'||tokens.get(i).charAt(j)==':'||tokens.get(i).charAt(j)==';')
					sentenceCount++;
			}
		}
		return sentenceCount;
	}

	//method to count syllables
	public static int countSyls(ArrayList<String> words)
	{
		int sylCount = 0;
		//loop through words
		for(int i = 0; i < words.size(); i++)
		{
			int syls = 0;
			//loop through chars in word
			for(int j = 0; j < words.get(i).length(); j++)
			{
				//if char is vowel add to syllables
				if(words.get(i).charAt(j)=='a'||words.get(i).charAt(j)=='e'||words.get(i).charAt(j)=='i'||words.get(i).charAt(j)=='o'||words.get(i).charAt(j)=='u'||words.get(i).charAt(j)=='y')
				{
					syls++;
				//if we arent at the end of the string and the next char is a vowel decrement syllables	
				if(j < words.get(i).length()-1){
					if(words.get(i).charAt(j+1)=='a'||words.get(i).charAt(j+1)=='e'||words.get(i).charAt(j+1)=='i'||words.get(i).charAt(j+1)=='o'||words.get(i).charAt(j+1)=='u'||words.get(i).charAt(j+1)=='y')
					{
						syls--;
					}
				}
				}		
			}
			//if word ends in e decrement syllables
			if(words.get(i).charAt(words.get(i).length()-1) == 'e')
				syls--;
			//all words have at least one syllable
			if(syls <= 0)
				syls = 1;
			//add syllables of word to total syllable count
			sylCount += syls;
		}
		return sylCount;
	}

	//method to count difficult words in file
	public static int countDiffs(ArrayList<String> words)
	{
		int diffCount = 0;
		ArrayList<String> hWords = new ArrayList<String>();
		File dFile = new File("/pub/pounds/CSC330/dalechall/wordlist1995.txt");
		try{
			Scanner dIn = new Scanner(dFile);
			//read dale chall words into an arraylist
			while(dIn.hasNext())
			{
				hWords.add(dIn.nextLine().toLowerCase());
			}
			//sort arraylist of dale chall words
			Collections.sort(hWords);
			//binary search for dale chall words, if found increment dale chall words
			for(int i = 0; i < words.size(); i++)
			{
				if(Collections.binarySearch(hWords,words.get(i)) >= 0)
				{
					diffCount++;
				}
			}
		}
		catch(FileNotFoundException e)
		{
			System.err.println("file not found");
		}
		return words.size()-diffCount;
	}
}

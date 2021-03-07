#include <fstream>
#include <iostream>	
#include <string>
#include <sstream>	//to parse through bible
#include <vector>	//to hold words/tokens
#include <math.h>	//for math.ceil
#include <algorithm>	//for sorting
#include <iomanip>	//to format output
using namespace std;

int countWords(vector<string> &tokens, vector<string> &words, string fileName);

int countSents(vector<string> words);

int countSyls(vector<string> words);

int countDiffs(vector<string> words);

int main(int argc, char** argv)
{
	//get filename from command line argument
	string fileName = argv[1];
	vector<string> words;
	vector<string> tokens;
	int wordCount = 0;
	int sentenceCount = 0;
	int sylCount = 0;
	int diffWords = 0;
	
	//count words sentences and syllables
	wordCount = countWords(tokens,words,fileName);
	sentenceCount = countSents(tokens);
	sylCount = countSyls(words);	
	diffWords = countDiffs(words);
	
	//calculate scores
	float daleChall = 0;
	float alpha = (float)sylCount/(float)wordCount;
	float beta = (float)wordCount/(float)sentenceCount;
	float daleAlpha = (float)diffWords/(float)wordCount;
	float flesch = ceilf((206.835-(alpha*84.6)-(beta*1.015))*10)/10;
	float fleschKincaid = ceilf(((alpha*11.8) + (beta*0.39) -15.59)*10)/10;
	if((daleAlpha*100)>5)	
		 daleChall = ceilf((((daleAlpha*100)*0.1579)+(beta*0.0496)+3.6365)*10)/10;
	else
		 daleChall = ceilf((((daleAlpha*100)*0.1579)+(beta*0.0496))*10)/10;

	//print scores
	cout << showpoint;
	cout << setprecision(3) << flesch << "         " << setprecision(2) << fleschKincaid << "                     " << setprecision(2) << daleChall << endl;
}

//method to count words in a file
int countWords(vector<string> &tokens, vector<string> &words, string fileName)
{
	int wordCount = 0;
	int x = 0;
	string word;
	string word2;
	string line;
	ifstream myFile;
	myFile.open(fileName);

	while(getline(myFile,line))
	{
		stringstream ss(line);		
		while(getline(ss, word, ' '))	
		{
			tokens.push_back(word);	
			word2 = "";
			//strip out non alphanumeric characters in token
			for(int i = 0; i < word.length(); i++)
			{
				if(isalpha(word[i]))
					word2 += tolower(word[i]);
			}
			//if there were alphanumeric characters in token add token to words and increase wordCount
			if(!word2.empty())
			{
				words.push_back(word2);
				wordCount++;
			}
		}
	}
	myFile.close();
	return wordCount;
}

//method to count sentences in a text file 
int countSents(vector<string> tokens)
{
	int sentenceCount = 0;
	for(int i = 0; i < tokens.size(); i++)
	{
		for(int j = 0; j < tokens[i].length(); j++)
		{
			//if character in tokens is punctuation increase sentence count
			if(tokens[i][j] == '.' || tokens[i][j] == '?' || tokens[i][j] == '!' || tokens[i][j] == ';' || tokens[i][j] == ':')
				sentenceCount++;
		}
	}
	return sentenceCount;	
}

//method to count syllables in a text file
int countSyls(vector<string> words)
{
	int sylCount = 0;
	for(int i = 0; i < words.size(); i++)
	{
		int syls = 0;
		for(int j = 0; j < words[i].length(); j++)
		{
			//check if character in word is a vowel, if so increment syllables
			if((words[i])[j] == 'a' || (words[i])[j] == 'e' || (words[i])[j] == 'i' || (words[i])[j] == 'o' || (words[i])[j] == 'u' || (words[i])[j] == 'y')		
			{
				syls++;
				//check if the next char is a vowel, if so decrement syllables
				if((words[i])[j+1] == 'a' || (words[i])[j+1] == 'e' || (words[i])[j+1] == 'i' || (words[i])[j+1] == 'o' || (words[i])[j+1] == 'u' || (words[i])[j+1] == 'y')
				{
					syls--;
				}
			}
		}
		//decrement syllables if word ends with e
		if((words[i])[words[i].length()-1] == 'e')
			syls--;
		//all words have at least 1 syllable
		if(syls <= 0)
			syls = 1;
		//add syllables for word to total syllable count
		sylCount += syls;
	}
	return sylCount;
}

//method to count difficult words
int countDiffs(vector<string> words)
{
	int diffCount = 0;
	ifstream hardWords;	
	string hWord;
	vector<string> hWords;
	hardWords.open("/pub/pounds/CSC330/dalechall/wordlist1995.txt");
	//add hardwords to arraylist
	while(getline(hardWords,hWord))
	{	
		string push = "";
		for(int i = 0; i < hWord.length(); i++)
		{
			push += tolower(hWord[i]);
		}
		hWords.push_back(push);
	}
	hardWords.close();	
	//sort arraylist of hardwords
	sort(hWords.begin(),hWords.end());
	//binary search for hard words
	for(int i = 0; i < words.size(); i++)
	{
		if(binary_search(hWords.begin(),hWords.end(),words[i]))
			diffCount++;
	}	
	return words.size()-diffCount;
}


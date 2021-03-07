import sys
import math

fileName = sys.argv[1]
f = open(fileName,"r", encoding="cp1250")
tokens = []
words = []
word = ""
worCount = 0
sentenceCount = 0
sylCount = 0
diffWords = 0
vowels = "aeiouy"

#tokenize input file
for line in f:
	for w in line.split():
		tokens.append(w)

#count words in file
for token in tokens:
	word = ""
	for c in token:
		if (c.lower()).isalpha():
			word+=c
	if len(word) > 0:
		words.append(word.lower())
wordCount = len(words)

#count sentences in file
for token in tokens:
	for c in token:
		if c == '.' or c == ':' or c == ';' or c == '?' or c == '!':
			sentenceCount+=1  	

#count syllables in file
for i in range(0,len(words)):
	syls = 0;	
	for j in range(0,len(words[i])):
		#if char is syllable increment dale syllables
		if (words[i])[j] in vowels:
			syls+=1
			#if we arent at the end of the string and next char is vowel decrement syllables
			if j < len(words[i])-1 and (words[i])[j+1] in vowels:
				syls-=1
	#if word ends with e decrement syllables
	if words[i].endswith('e'):
		syls-=1
	#all words have one syllable at least
	if syls <= 0:
		syls = 1
	sylCount += syls

#count difficult words
diffCount = 0
hWords = set() #create hashset for dale chall words
hF = open("/pub/pounds/CSC330/dalechall/wordlist1995.txt","r") 
#read dale chall words and input each one into a hashset
for line in hF: 
	for w in line.split():
		hWords.add(w.lower())
#check if word in bible is in hashset for dale chall words
for word in words:
	if word in hWords:
		diffCount+=1	
diffWords = len(words) - diffCount

#calculate scores
daleChall = 0
alpha = float(sylCount)/float(wordCount)
beta = float(wordCount)/float(sentenceCount)
daleAlpha = float(diffWords)/float(wordCount)
flesch = math.ceil((206.835 - (alpha*84.6)-(beta*1.015))*10)/10
fleschKincaid = math.ceil(((alpha*11.8)+(beta*0.39)-15.59)*10)/10
if((daleAlpha*100)>5):
	daleChall = math.ceil((((daleAlpha*100)*0.1579)+(beta*0.0496)+3.6365)*10)/10
else:
	daleChall = math.ceil((((daleAlpha*100)*0.1579)+(beta*0.0496))*10)/10
	
#score printing
print(" " +str(flesch) + "         " + str(fleschKincaid) + "                     " + str(daleChall))
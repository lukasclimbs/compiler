#!/usr/bin/python2.7

# Getting the stuff we'll need, mostly from the Natural Language Toolkit

import nltk
from nltk import word_tokenize
import urllib2

while True:
    address = raw_input("What URL or file would you like to use? \n")

    # Set the default file as Coleridge's Rime of the Ancient Mariner

    if address == "":
        address = "/home/reschluk295/MobyDick.txt"

    # We need different procedures for text files and URLs, so we check for the http prefix

    if address[:4] == "http":
        response = urllib2.urlopen(address)
    else:
        response = open(address)

    raw = response.read().decode("utf-8-sig")

    # Break the text into tokens and make them all lower-case

    tokens = word_tokenize(raw)
    tokens = [token.lower() for token in tokens]
    text = nltk.Text(tokens)

    # What kind of search are we doing?

    search_type = raw_input("So, are we looking for \n1. a whole word, \n2. a word beginning, \n3. a word ending, \n4. a basket of words, \n5. a pre-made basket of words?, or \n6. punctuation marks? Enter the number of your choice:\n")

    # Set a counter to zero. This will work for whatever path we follow in the counting.

    newcount = 0

    # Do the actual counting, with the nature of the comparison changing according to the search type.

    if search_type == "1":
        whole_word = (raw_input("What word are we looking for? \n")).lower()
        print "\nRESULTS ARE HERE\n"
        for token in text:
            if token == whole_word:
                newcount += 1
                print token
        # Print out the results.
        print str(newcount) + " out of " + str(len(text)) + ", for a frequency of " + str(round((float(newcount)) * (1000/float(len(text))), 1)) + " per thousand tokens."

    elif search_type == "2":
        beginning = (raw_input("What word beginning are we looking for? \n")).lower()
        print "\nRESULTS ARE HERE\n"
        for token in text:
            if token[:(len(beginning))] == beginning:
                newcount += 1
                print token
        # Print out the results.
        print str(newcount) + " out of " + str(len(text)) + ", for a frequency of " + str(round((float(newcount)) * (1000/float(len(text))), 1)) + " per thousand tokens."

    elif search_type == "3":
        ending = (raw_input("What word ending are we looking for? \n")).lower()
        print "\nRESULTS ARE HERE\n"
        for token in text:
            if token[-(len(ending)):] == ending:
                newcount += 1
                print token
        # Print out the results.
        print str(newcount) + " out of " + str(len(text)) + ", for a frequency of " + str(round((float(newcount)) * (1000/float(len(text))), 1)) + " per thousand tokens."

    elif search_type == "4":
        word_list = (raw_input("What words are we looking for? Use spaces to separate them. \n")).lower()
        word_list = word_tokenize(word_list)
        word_list = [token.lower() for token in word_list]
        word_list = nltk.Text(word_list)
        print "\nRESULTS ARE HERE\n"
        for token in text:
            if token in word_list:
                newcount += 1
                print token
        # Print out the results.
        print str(newcount) + " out of " + str(len(text)) + ", for a frequency of " + str(round((float(newcount)) * (1000/float(len(text))), 1)) + " per thousand tokens."

    elif search_type == "5":
        baskets = {"Forms of 'to be'": "is are were was be am been", "Intensifiers": "very really literally quite", "Terms of certainty": "certainly definitely exactly surely totally completely absolutely", "Pundits' words to avoid": "really feel think sort kind like just rather somewhat somehow wonder ponder thought felt understand realize"}
        for key, val in baskets.items():
            newcount = 0
            print key + ": " + val
            word_list = val
            word_list = word_tokenize(word_list)
            word_list = [token.lower() for token in word_list]
            word_list = nltk.Text(word_list)
            for token in text:
                if token in word_list:
                    newcount += 1
            # Print out the results.
            print str(newcount) + " out of " + str(len(text)) + ", for a frequency of " + str(round((float(newcount)) * (1000/float(len(text))), 1)) + " per thousand tokens."
    elif search_type == "6":
        marks = {"Comma": ",", "Period": ".", "Single quotation/apostrophe": "'", "Double quotation": "\"", "Colon": ":", "Semicolon": ";", "Question mark": "?", "Exclamation point": "!"}
        for key, val in marks.items():
            newcount = 0
            print key + ": " + val
            mark_list = val
            mark_list = word_tokenize(mark_list)
            mark_list = nltk.Text(mark_list)
            for token in text:
                if token in mark_list:
                    newcount += 1
            # Print out the results.
            print str(newcount) + " out of " + str(len(text)) + ", for a frequency of " + str(round((float(newcount)) * (1000/float(len(text))), 1)) + " per thousand tokens."

    # But if the search type is invalid, we are outta here.

    else:
        print("I don't think you entered one of our numbers. I SAID GOOD DAY.")
        exit()
class_name NavdiNamer

const vowels = ['a','e','i','o','u',]
const consonants = ['q','w','r','t','y','p','s','d','f','g','h','j','k','l','z','x','c','v','b','n','m',]
func generate_vowel():
	return vowels[randi()%len(vowels)]
func generate_consonant():
	return consonants[randi()%len(consonants)]
func generate_vcname(length, vowelfirst=false):
	var vowel=vowelfirst
	var vcname=""
	for _i in range(length):
		vcname+=generate_vowel() if vowel else generate_consonant()
		vowel=not vowel
	return vcname

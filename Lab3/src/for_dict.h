#ifndef DICTIONARY_H
#define DICTIONARY_H

#define MAX_WORD_LENGTH 50
#define MAX_DICT_SIZE 100
#define MAX_TEXT_LENGTH 100000

typedef struct {
    char words[MAX_DICT_SIZE][MAX_WORD_LENGTH];
    int size;
} Dictionary;

int isInDictionary(Dictionary *dict, const char *word);
void addToDictionary(Dictionary *dict, const char *word);
void removeFromDictionary(Dictionary *dict, const char *word);
int checkInDictionary(Dictionary *dict, const char *word);
void saveDictionary(const Dictionary *dict, const char *filename);
void printresOfCheck(Dictionary *dict, const char *word);

#endif /* DICTIONARY_H */

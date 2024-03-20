#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "for_dict.h"

int isInDictionary(Dictionary *dict, const char *word) {
    for (int i = 0; i < dict->size; ++i) {
        if (strcmp(dict->words[i], word) == 0) {
            return 1; // слово найдено в словаре
        }
    }
    return 0; // слово не найдено в словаре
}

void addToDictionary(Dictionary *dict, const char *word) {
    int check = checkInDictionary(dict, word);
    if (check == 1 )
    {
        printf("Такое слово уже есть.\n");
        return;
    }
    if (dict->size < MAX_DICT_SIZE) {
        strcpy(dict->words[dict->size], word);
        dict->size++;
        saveDictionary(dict, "dictionary.txt");
    } else {
        printf("Словарь полон. Невозможно добавить слово.\n");
    }

}

void removeFromDictionary(Dictionary *dict, const char *word) {

    for (int i = 0; i < dict->size; ++i) {
        if (strcmp(dict->words[i], word) == 0) {
            for (int j = i; j < dict->size - 1; ++j) {
                strcpy(dict->words[j], dict->words[j + 1]);
            }
            dict->size--;
            saveDictionary(dict, "dictionary.txt");
            return;
        }
    }

    printf("Слово \"%s\" не найдено в словаре.\n", word);
}

int checkInDictionary(Dictionary *dict, const char *word) {
    if (isInDictionary(dict, word)) {
        return 1;
    } else {
        return 0;
    }
}

void saveDictionary(const Dictionary *dict, const char *filename) {
    FILE *file = fopen(filename, "w");
    if (file == NULL) {
        perror("Ошибка при открытии файла для записи");
        exit(EXIT_FAILURE);
    }

    for (int i = 0; i < dict->size; ++i) {
        fprintf(file, "%s\n", dict->words[i]);
    }

    fclose(file);
}

void printresOfCheck(Dictionary *dict, const char *word)
{
    if (checkInDictionary(dict, word)) {
        printf("Слово \"%s\" найдено в словаре.\n", word);
    } else {
        printf("Слово \"%s\" не найдено в словаре.\n", word);
    }
}

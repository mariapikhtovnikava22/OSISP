#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h> 
#include "for_dict.h"

// Функция для загрузки словаря из файла
void loadDictionary(Dictionary *dict, const char *filename) {
    FILE *file = fopen(filename, "r");
    if (file == NULL) {
        perror("Ошибка при открытии файла");
        exit(EXIT_FAILURE);
    }

    dict->size = 0;
    while (fscanf(file, "%s", dict->words[dict->size]) != EOF && dict->size < MAX_DICT_SIZE) {
        dict->size++;
    }

    fclose(file);
}

// // Функция для проверки, содержится ли слово в словаре
// int isInDictionary(Dictionary *dict, const char *word) {
//     for (int i = 0; i < dict->size; ++i) {
//         if (strcmp(dict->words[i], word) == 0) {
//             return 1; // слово найдено в словаре
//         }
//     }
//     return 0; // слово не найдено в словаре
// }

// Функция для замены "запрещенных" слов фиксированным шаблоном
void censorText(Dictionary *dict, char *text, const char *replacement) {
    char *copy = strdup(text); // копия текста, чтобы не изменять исходный
    if (copy == NULL) {
        perror("Ошибка выделения памяти");
        exit(EXIT_FAILURE);
    }

    char *word;
    char *temp;
    char *new_text = strdup(""); // создаем пустую строку для нового текста
    if (new_text == NULL) {
        perror("Ошибка выделения памяти");
        free(copy);
        exit(EXIT_FAILURE);
    }

    word = strtok(copy, " "); // разделение текста на слова по пробелам
    while (word != NULL) {
        temp = strdup(word);
        int len = strlen(word);
        if (ispunct(temp[len - 1])) {
                // Удаляем знак препинания
                temp[len - 1] = '\0';
            }
        if (isInDictionary(dict, temp)) {
            // Заменяем слово на фиксированный шаблон
            strcat(new_text, replacement);
            if (temp[len - 1] == '\0') 
            {
                strncat(new_text, &word[len - 1], 1); // Добавление символа из word[len - 1] к new_text
            }

        } else {
            // Копируем слово без изменений
            strcat(new_text, temp);
        }
      
        strcat(new_text, " "); // Добавляем пробел между словами
        word = strtok(NULL, " ");
    }

    // Удаляем лишний пробел в конце строки, если он есть
    if (strlen(new_text) > 0 && new_text[strlen(new_text) - 1] == ' ') {
        new_text[strlen(new_text) - 1] = '\0';
    }

    // Копируем новый текст в исходную строку
    strcpy(text, new_text);

    // Освобождаем выделенную память
    free(copy);
    free(new_text);
    free(temp);
}

void readTextFromFile(const char *filename, char *text) {
    FILE *file = fopen(filename, "r");
    if (file == NULL) {
        perror("Ошибка при открытии файла");
        exit(EXIT_FAILURE);
    }

    int c;
    size_t i = 0;
    while ((c = fgetc(file)) != EOF && i < MAX_TEXT_LENGTH - 1) {
        text[i++] = (char)c;
    }
    text[i] = '\0'; // Завершаем строку нулевым символом

    fclose(file);
}


int main(int argc, char *argv[]) {

    if (argc != 3) {
        printf("Для работы программы необходимо передать файл с запрещенными словами и текст для работы!\n");
        return 1;
    }

    Dictionary dict;
    loadDictionary(&dict, argv[1]); 
   
    char replacement[] = "[цензура]";
    // Пример текста для проверки
    char text[MAX_TEXT_LENGTH]; // Массив для хранения текста
    readTextFromFile(argv[2], text);

    printf("Исходный текст:\n%s\n\n", text);
    printf("Текст после цензуры:\n");
    censorText(&dict, text, replacement); // применяем цензуру к тексту, заменяем на ***
    printf("%s\n", text);

    addToDictionary(&dict, "week");
    removeFromDictionary(&dict, "week");
    printresOfCheck(&dict, "word");

    return 0;
}

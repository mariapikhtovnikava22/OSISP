#!/bin/bash

# Чтение текста из файла
text=$(<input.txt)

# Паттерн для поиска мест, где нужно произвести замену на заглавные буквы
pattern='(^|[.!?]\s+)([a-z])'

# Паттерн для сокращений, которые не должны изменяться
abbreviations='(i\.e\.|e\.g\.|etc\.|ect\.|p\.a\.|a\.m\.|p\.m\.|P\.S\.|Re\.|p\.|exp\.|err\.|et\.al\.|ex\.|fin\.|vs\.)'


# Замена строчных букв на заглавные в сокращениях, только если за ними следует знак препинания или конец строки
 
corrected_text=$(echo "$text" | sed -E "s/$pattern/\1\U\2/g")


corrected_text=$(echo "$corrected_text" | sed -E "s/($abbreviations)(\s+)([A-Za-z])/\2\3\L\4/g")



# Вывод скорректированного текста
echo "$corrected_text"

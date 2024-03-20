TARGET = Laba3
COMP = gcc

PREF_SRC = ./src/
PREF_OBJ = ./obj/
PREF_TESTS = ./tests/

SRC_С = $(wildcard $(PREF_SRC)*.c) #деректива wildcard означает что в данной переменнной должны хранится все 
#файлы которые удовлетворяют данной маске и находятся в той же папке что и makefale

OBJ = $(patsubst $(PREF_SRC)%.c, $(PREF_OBJ)%.o, $(SRC_С)) #список объектных файлов а не какой то конктретный,
#для простоты понимания что тут происходит: мы берем все переменные из SRC_С и взять те имена которые удовлетвроряют данной маске %.c  и преписать вместо c o


TEST_EXP = test_expected
TEST_INP = test_inp
TEST_OUT = test_out
TEST_DICT = test_dict


$(TARGET) : $(OBJ)
	$(COMP) $(OBJ) -o $(TARGET)

$(PREF_OBJ)%.o : $(PREF_SRC)%.c
	$(COMP) -c $< -o $@ 

#$< - переменная которая представляет первый зависимый файл т.е файл .c, $@ - второй файл который нужно получить из 1-го

clean : 
	rm $(TARGET) $(PREF_OBJ)*.o
	 

tests: test_censor 

test_censor:
	echo "Running test for censorText function..."
	@echo "Текст для замены блин цензуры" > $(PREF_TESTS)$(TEST_INP)1.txt
	@echo "блин" > $(PREF_TESTS)$(TEST_DICT)1.txt
	@echo "Текст для замены [цензура] цензуры" > $(PREF_TESTS)$(TEST_EXP)1.txt
	./$(TARGET) $(PREF_TESTS)$(TEST_DICT)1.txt $(PREF_TESTS)$(TEST_INP)1.txt > $(PREF_TESTS)$(TEST_OUT)1.txt
	diff $(PREF_TESTS)$(TEST_EXP)1.txt $(PREF_TESTS)$(TEST_OUT)1.txt
	@echo "Test for censorText function passed."
	rm $(PREF_TESTS)*.txt	


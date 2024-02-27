#!/bin/bash

user_inp(){

    local word
    local category
    local inp_text="Enter your word: "
    local hello_str="\t\nWELCOME TO THE GALLOWS GAME!!!\n"
    local type_game="\e[46m####### Your current game with human #######\e[0m \n"
    local error_mes=""
    
    while true; do
        clear
        echo -e  $hello_str
        echo -e "$type_game"
        echo -e "$error_mes"
        read -s -p "$inp_text" word
        
        if [[ ! "$word" =~ ^[a-zA-Z]+$ ]]; then
            error_mes="\e[31mError!!!Enter a word containing only English characters!\e[0m"
            continue
        else
            inp_text="Enter your category: "
            error_mes=""
            upcategory "$1" $word
            break
        fi
        
    done

    while true; do

        clear
        echo -e  $hello_str
        echo -e "$type_game"
        echo -e "$error_mes"
        read -p "$inp_text" category 

        if [[ ! "$category" =~ ^[a-zA-Z]+$ ]]; then
	        error_mes="\e[31mError!!!Enter a category containing only English characters!\e[0m"
            continue
        else
            upcategory "$2" $category
            break
        fi

    done
 
}


machine_inp(){

   words=("apple" "banana" "grape" "pineapple" "potato" "tomato" "beans" "carrot" 
   pizza cheese pasta ham egg meat red blue green pink violet orange
   bear fox pig moouse camel horse desk marker backpack pen lesson physics)
   
   rand_word=$(getRandomWord)
   echo "$rand_word"
   get_category "category" "$rand_word"

   
}
 

getRandomWord() {
    local random_index=$(( RANDOM % ${#words[@]} ))
    echo "${words[$random_index]}"
}

upcategory() {
    unset -v "$1" && eval "${1}=\$2" # или можно так:     eval "$1"'=$2'
}

get_category(){

   upcategory "$1" 'unknown'
   case $2 in
        apple | banana | grape | pineapple)
            upcategory "$1" 'fruit'
            ;;
        potato | tomato | beans | carrot)
            upcategory "$1" 'vegetable'
            ;;
        pizza | cheese | pasta | ham | egg | meat)
            upcategory "$1" 'food'
            ;; 
        red | blue | green | pink | violet | orange)
            upcategory "$1" 'colors'
            ;;  
        bear | fox | elephant | moouse | camel | horse | pig)
            upcategory "$1" 'animals'
            ;;   
        desk | marker | backpack | pen | lesson | physics)
            upcategory "$1" 'school'
            ;;    
   esac
}


drawHangman() {
    local attemptsLeft=$1
    case $attemptsLeft in
        6)
            cat << "EOF"
  ____
 |    |
 |     
 |     
 |     
 |     
_|______
EOF
            ;;
        5)
            cat << "EOF"
  ____
 |    |
 |    O
 |     
 |     
 |     
_|______
EOF
            ;;
        4)
            cat << "EOF"
  ____
 |    |
 |    O
 |    |
 |     
 |     
_|______
EOF
            ;;
        3)
            cat << "EOF"
  ____
 |    |
 |    O
 |   /|
 |     
 |     
_|______
EOF
            ;;
        2)
            cat << "EOF"
  ____
 |    |
 |    O
 |   /|\
 |     
 |     
_|______
EOF
            ;;
        1)
            cat << "EOF"
  ____
 |    |
 |    O
 |   /|\
 |   / 
 |     
_|______
EOF
            ;;
        0)
            cat << "EOF"
  ____
 |    |
 |    O
 |   /|\
 |   / \
 |     
_|______
EOF
            ;;
    esac
}


check_word() {
    
    local word=$1
    local letter=$2
    declare -a positions
    for (( i=0; i < ${#word}; i++ )); do 
        if [[ "${word:i:1}" == "$letter" ]]; then
            positions+=($i)
        fi
    done

    echo ${positions[@]}

    if [[ -z ${positions[@]} ]]; then
        return 1
    fi

}

print_word(){
    
    local secret_word=$1
    shift
    local let_position=("$@")
    
    local bool=0

    for ((i=0; i<${#secret_word}; i++)); do
        for (( y=0; y<${#let_position[@]}; y++)); do
            if [[ $i == ${let_position[y]} ]]; then
                new_word+=" ${secret_word:i:1}"
                bool=1
            fi
        done

        if [ $bool == 0 ]; then
            new_word+=" _"
        fi
        bool=0
         
    done

    echo $new_word
}


start()
{
    clear
    
    while true; do

        hello_str="\t\nWELCOME TO THE GALLOWS GAME!!!\n"
        type_game=""
        error_mes=""
        game_state=""
        answ=""
        attempts=6
        position=()
        inp_letters=""
        alp="
        Aa Bb Cc Dd Ee Ff Gg 
        Hh Ii Jj Kk Ll Mm Nn
        Oo Pp Qq Rr Ss Tt Uu
        Vv Ww Xx Yy Zz
        "
        alp_mini=$(tr '[:upper:]' '[:lower:]' <<< "$alp")
        letter=""
        state=""

         
        echo -e "$hello_str"

        while true; do
            
            read -p "Select the game option: 1) - playing with computer, 2) - playing with human, 3) - show my results in the game, 4) - exit the game: " option
            echo -e "\n"
            if [[ ! "$option" =~ ^[1-4]$ ]]; then
                error_mes="\e[31mError!!! Select 1 or 2 or 3\e[0m"      
                clear
                echo -e $hello_str
                echo -e $error_mes
                continue
            else
                break
            fi
        done

        error_mes=""

        case $option in 
            1) 
                
                type_game="\e[46m####### Your current game with machine #######\e[0m \n"
        
                word=$(machine_inp)
                get_category "category" "$word"

                ;;
            2) 
                
                type_game="\e[46m####### Your current game with human #######\e[0m \n"

                user_inp "word" "category"

                ;;

            3)
                echo -e "Your results in the game\n"
                cat records.txt
                continue
                ;;

            4)
                echo "Bye"
                break
                ;;   
        esac

        while [ $attempts -gt 0 ]; do

            word_ws=$(echo "$(print_word "$word" "${position[@]}")" | sed 's/ //g')

            if [[ "$word_ws" == "$word" ]]; then
                clear
                echo -e $hello_str
                echo -e "$type_game"

                echo -e  "$answ"
                echo -e "$game_state"

                drawHangman $(($attempts))
                echo -e "\n$(print_word "$word" "${position[@]}")\n"

                state="You guessed the word on the "$attempts"nd try\n"

                printf "$state" >> records.txt
                echo -e "$state\n\n"

                sed 's/.*/\x1b[32m&\x1b[0m/' win
                break
            fi

            if [ $attempts == 1 ]; then
                game_state="You have $attempts attempt"
            else
                game_state="You have $attempts attempts"
            fi

            while true; do
                clear
                echo -e  $hello_str
                echo -e "$type_game"

                echo -e "$answ"
                echo -e "$game_state"
                
                drawHangman $(($attempts))

                echo -e "\nWord category: \e[93m$category\e[0m \n"

                echo -e "letters available for input"

                echo "$alp"

                echo -e "$(print_word "$word" "${position[@]}")\n"

                echo -e $error_mes

                read -p "Enter only one letter of the Eglish alphabet: " letter 

                echo -e "\n"

                letter=$(tr '[:upper:]' '[:lower:]' <<< "$letter")
                letter_up=$(tr '[:lower:]' '[:upper:]' <<< "$letter")
                letter_low=$(tr '[:upper:]' '[:lower:]' <<< "$letter")

                gray_color=$(printf '\e[90m')
                reset_color=$(printf '\e[0m')

                pattern="$letter_up$letter_low"


                alp=$(echo "$alp" | sed -e "s/$pattern/${gray_color}&${reset_color}/g")


                if [[ ! "$letter" =~ ^[a-zA-Z]$ ]]; then
                    error_mes="\e[31mINPUT ERROR!!!\e[0m"
                    continue
                elif [[ "$inp_letters" == *"$letter"* ]]; then
                    error_mes="\e[31mERROR!!! This letter has already been used!!!\e[0m"
                    
                    continue
                else
                    error_mes=""
                    inp_letters+="$letter"
                    break
                fi
                

            done                   

            position+=($(check_word "$word" "$letter"))                     

            if [ $? == 1 ]; then
                answ="\e[31mWrong!\e[0m \n"
                ((attempts--))
            else 
                answ="\e[32mCorrectly!\e[0m \n"
            fi  
            
            if [[ $attempts == 0 ]]; then
                clear
                echo -e $hello_str
                echo -e "$type_game"

                echo -e  "$answ"
                game_state="You don't have any attempts"
                echo -e "$game_state"

                state="You lose\n"

                printf "$state" >> records.txt

                drawHangman $(($attempts))
                echo -e "\nWord category: \e[93m$category\e[0m \n"
                echo -e "\n$(print_word "$word" "${position[@]}")\n"

                sed 's/.*/\x1b[31m&\x1b[0m/' lose
                break
            fi     

                
        done

    done
    
}


start



 










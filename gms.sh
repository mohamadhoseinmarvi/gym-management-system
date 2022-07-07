#!/bin/bash

default_password="pass";
file_name="gymfile.txt";
catagories=("New Gym Member" "Personal Trainer" "Gym's Staff Member" "Back To Main Menu");
password ()
  {
    echo -e "\n\n\t\t\t\t\t WELCOME\n\t\t\t\t\t   To\n\t\t   |<<<<<<<<<<<<<> GYM MANAGEMENT SYSTEM <>>>>>>>>>>>>>|\n"
    read -sp "  Enter Password : " pass;
    if [ $pass = $default_password ]
      then
        echo -e "\n\n\t\t\tAccess Granted!!\n\n";
        echo -e "\t\tpress any key to proceed...";
        read any;
        main_menu
      else
        echo " Access Denied!!! Incorrect password!! ";
        clear
        password
    fi
  }



function list_in_tables()
{
    local -r delimiter="${1}"
    local -r data="$(removeEmptyLines "${2}")"

    if [[ "${delimiter}" != '' && "$(isEmptyString "${data}")" = 'false' ]]
    then
        local -r numberOfLines="$(wc -l <<< "${data}")"

        if [[ "${numberOfLines}" -gt '0' ]]
        then
            local table=''
            local i=1

            for ((i = 1; i <= "${numberOfLines}"; i = i + 1))
            do
                local line=''
                line="$(sed "${i}q;d" <<< "${data}")"

                local numberOfColumns='0'
                numberOfColumns="$(awk -F "${delimiter}" '{print NF}' <<< "${line}")"



                if [[ "${i}" -eq '1' ]]
                then
                    table="${table}$(printf '%s#+' "$(repeatString '#+' "${numberOfColumns}")")"
                fi



                table="${table}\n"

                local j=1

                for ((j = 1; j <= "${numberOfColumns}"; j = j + 1))
                do
                    table="${table}$(printf '#| %s' "$(cut -d "${delimiter}" -f "${j}" <<< "${line}")")"
                done

                table="${table}#|\n"


                if [[ "${i}" -eq '1' ]] || [[ "${numberOfLines}" -gt '1' && "${i}" -eq "${numberOfLines}" ]]
                then
                    table="${table}$(printf '%s#+' "$(repeatString '#+' "${numberOfColumns}")")"
                fi
            done

            if [[ "$(isEmptyString "${table}")" = 'false' ]]
            then
                echo -e "${table}" | column -s '#' -t | awk '/^\+/{gsub(" ", "-", $0)}1'
            fi
        fi
    fi
}

function removeEmptyLines()
{
    local -r content="${1}"

    echo -e "${content}" | sed '/^\s*$/d'
}

function repeatString()
{
    local -r string="${1}"
    local -r numberToRepeat="${2}"

    if [[ "${string}" != '' && "${numberToRepeat}" =~ ^[1-9][0-9]*$ ]]
    then
        local -r result="$(printf "%${numberToRepeat}s")"
        echo -e "${result// /${string}}"
    fi
}

function isEmptyString()
{
    local -r string="${1}"

    if [[ "$(trimString "${string}")" = '' ]]
    then
        echo 'true' && return 0
    fi

    echo 'false' && return 1
}

function trimString()
{
    local -r string="${1}"

    sed 's,^[[:blank:]]*,,' <<< "${string}" | sed 's,[[:blank:]]*$,,'
}

function add_members () {
    touch $file_name
    clear
    echo -e "\n\n\t Select a Category : \n"
    echo -e "\t\t[1] ${catagories[0]}\n"
    echo -e "\t\t[2] ${catagories[1]}\n"
    echo -e "\t\t[3] ${catagories[2]}\n"
    echo -e "\t\t[4] ${catagories[3]}\n"
    echo -e "\tEnter your choice : \c"
    read choice2
      if [ $choice2 -eq 4 ]
        then
         main_menu
      fi
    if [ -e $file_name ]
     then
            clear
            set Member_ID Member_NAME Member_ADDRESS Member_CONTACT Membership_DATE
            echo -e "\t\t\n CAUTION: Fill in the Informations below...\n\n"
            echo -e "\t Category :  ${catagories[$choice2-1]}\n"
            echo -e "$1 : \c"
            read  id
              if [ `check $id` -eq 0 ]
                then
                  echo -e "\n\t\tError: That ID is already taken!!\n"
                  echo -e "\n\tpress any key to return...\c"
                  read enter
                  add_members
              fi
            echo -e "$2 : \c"
            read name
            echo -e "$3 : \c"
            read address
            echo -e "$4 : \c"
            read contact
            echo -e "$5 : \c"
            read memdate


            file="${catagories[$choice2-1]} , $id , $name , $address , $contact , $memdate"
            ftable= list_in_tables ',' "$file"
            cat <<< $file >> $file_name
            echo -e "\t Record saved successfully!!!\n\n"
            echo -e "Do you Want to add more? (Y/N): \c"
            read another
                if [ $another = "n" ] || [ $another = "N" ]
                  then
                    main_menu
                  else
                    add_members
                fi
        fi
}
function remove_members() {
  local val
  clear
  echo -e "\n\t\tEnter Member's ID to remove : \c"
  read id
  if [ `check $id` -eq 1 ]
                then
                  echo -e "\n\t\tError: The ID you entered does not exist!!\n"
                  echo -e "\n\tpress any key to return...\c"
                  read enter
                  main_menu
              fi
  val=$id
  awk -v name="$val" '$2==name{print "Member found : " $3}' $file_name

          echo -e "\n  "
          tmpresults="/tmp/results.$$"
          grep -i "${val}" $file_name > "${tmpresults}"
          var=$( cat "${tmpresults}" )
          list_in_tables ',' "   $var"
          rm -f "${tmpresults}" ;

  echo -e "\n\tAre u sure u want to remove it (Y/N): \c"
  read sure
  if [ $sure = "n" ]
    then
      main_menu
    else
      sed -e "/$val/d" -i $file_name
      echo -e "\n\t\t\t Member has been removed successfully!!\n"
      echo -e "\n\t\tDo you Want to remove more (y/n): \c"
      read ch
     if [ $ch = 'y' ] || [ $ch = 'Y' ]
      then
        remove_members
      else
        main_menu
     fi
  fi
}

to_main() {
echo -e "\n\n********************************************************************************************************\n"
printf '\tPress any key to return to the main menu...\n'
read xz
clear
main_menu
}

function list_members ()
  {
    if [ -f $file_name ]
    then
    clear
    echo -e "\n\t LIST OF MEMBERS OF THE GYM:"
    echo -e "*******************************************************************************************************\n"

          tmpresults="/tmp/results.$$"
          grep -i "${members}" $file_name > "${tmpresults}"
          var0=$( cat "${tmpresults}" )
          list_in_tables ',' "   $var0"
          rm -f "${tmpresults}" ;
    to_main
      else
      echo -e "\n\t\t No previous records found!! \c"
      read anykey
      main_menu
      fi
  }
function check() {

        grep -w -q "$1" "$file_name"
        echo $?
  }

function search_members() {
    local id
    local name
    local another
    clear
    echo -e "\n\n\t\t1|  Search by ID\n\n"
    echo -e "\t\t2|  Search by Name\n\n"
    read input
 case $input in
   1)  echo -e "\n\t\tEnter the ID : \c"
       read id
     if [ `check $id` -eq 1 ]
     then
        echo -e "\t\t Error: The ID you entered does not exist!! \n\n"
        echo -e "\t\t press any key to return...";
        main_menu
     fi

          echo -e "\n  "
          tmpresults="/tmp/results.$$"
          grep -i "${id}" $file_name > "${tmpresults}"
          printf "Found record... \n\n" ;
          var=$( cat "${tmpresults}" )
          list_in_tables ',' "   $var"
          rm -f "${tmpresults}" ;

         echo -e "\n\n\tDo you Want to search more (Y/N): \c"
           read another
        if [ $another = 'n' ] || [ $another = 'N' ]
          then
            main_menu
          else
            search_members
        fi
       ;;
   2)  echo -e "\t\tEnter the Name : \c"
       read name
      if [ `check $name` -eq 1 ]
       then
          echo -e "\t\tError: The Name you entered does not exist!!\n\n"
          echo -e "\t\tpress any key to return..."
          main_menu
       else
          echo -e "\n  "
          tmpresults="/tmp/results.$$"
          grep -i "${name}" $file_name > "${tmpresults}"
          printf "Found record... \n\n" ;
          var=$( cat "${tmpresults}" )
          list_in_tables ',' "   $var"
          rm -f "${tmpresults}" ;

          echo -e "\n\n\tDo you Want to search more (Y/N): \c"
          read another
           if [ $another = 'n' ] || [ $another = 'N' ]
            then
              main_menu
           else
              search_members
           fi
      fi;;
   *) echo -e "\n\tplease enter a valid choice...\n"
   search_members
 esac
}

function update_members() {
      clear
      local id
      local try
      local line
      local lineNum
      echo -e "\n\n\t Enter Member's ID to Update : \c"
      read id
      if [ `check $id` -eq 1 ]
        then
            echo -e "\tError: The ID you entered does not exist!!\n\n"
            echo -e "Do u want to try again (y/n): \c"
            read try
            if [ $try = 'n' ] || [ $try = 'N' ]
              then
                main_menu
              else
                update_members
            fi
        else
               echo -e "\n\t\tEnter new Category(Member): \c"
               read newCategory
               echo -e "\n\t\tEnter new Member ID : \c"
               read newID
               if [ `check $newID` -eq 0 ]
                then
                  echo -e "\n\t\tError: That ID is already registered!!\n"
                  echo -e "\n\tpress any key to return...\c"
                  read enter
                  update_members
               fi
               echo -e "\n\t\tEnter new Name : \c"
               read newName
               echo -e "\n\t\tEnter new Address : \c"
               read newAddress
               echo -e "\n\t\tEnter new Contact : \c"
               read newContact
               echo -e "\n\t\tEnter new Membership date : \c"
               read newDate

               line="$newCategory , $newID , $newName , $newAddress , $newContact , $newDate"
               list_in_tables ',' "$line"
               lineNum="$(grep -n "$id" $file_name | head -n 1 | cut -d: -f1)"
               `sed -i "${lineNum}s/.*/${line}/" $file_name`
               echo -e "\n\n\t\t\tRecord saved successfully!! \n"
               echo -e "\n\t\t Do you Want to update more (Y/N): \c"
               read try
                if [ $try = 'n' ] || [ $try = 'N' ]
                  then
                     main_menu
                  else
                     update_members
                fi
      fi
    }
function close_app() {
    clear
    echo -e "\n----------------------------------------------------------------------\n"
    echo -e "\tThank you!"
    sleep 0.5
    echo -e "\n\n \t\t\t                                  "
    echo -e "-----------------------------------------------------------------------"
    sleep 0.4
    echo -e "\n Good Bye!!!\n\n"
    exit
}

function main_menu () {
    clear
    echo -e  "\n\n\t\tGym Management System "
    echo -e "\t\t**************************************************************\n"
    echo -e "\t\t\t[1] Add Gym Members  \n"
    echo -e "\t\t\t[2] Remove Gym Members \n"
    echo -e "\t\t\t[3] Search Gym Members \n"
    echo -e "\t\t\t[4] View Gym Members list \n"
    echo -e "\t\t\t[5] Update Gym Member's Record \n"
    echo -e "\t\t\t[6] Close The Application\n"
    echo -e "\tEnter your choice: \c"
    read choice;
                case $choice in
                    1) add_members ;;
                    2) remove_members ;;
                    3) search_members ;;
                    4) list_members ;;
                    5) update_members ;;
                    6) close_app ;;
 *) echo -e "\t Error: Invalid Input value!! \n";
     echo -e "\n\t\tplease enter a valid choice...\c"
     read enter
     main_menu;
esac
}
    password

# You should comment/uncomment part of the code to modify code using ./convert.sh transform
# where transform is the extraction of revive lint errors using get_keyword <keyword> <lint_file.txt>
# Be careful: with exported keyword you have several transformations:
# when the comment contains "*should be of*" I did the modifications manually
# when the comment contains "*name will*" I used the #### naming (and not var-naming) below


source_file="$1"
while read -r line; do

  ### var-naming
  #if [ -n "$file" ]; then
  #  new_file="$(echo "$line" | cut -d":" -f1)";
  #  match_file="$(echo "$file" | grep "$new_file")"
  #  if [ -z "$match_file" ]; then
  #    # changing file, insert global deactivation
  #    message="//revive:disable:var-naming"
  #    if ! grep -q "$message" "$file"; then
  #      num="$(grep -n -m1 "^[ ]*$" "$file" | cut -d":" -f1)"
  #      { head -"$((num - 1))" "$file";
  #      printf '\n%s\n' "$message";
  #      tail -n +"$num" "$file"; }  >> tmp_file;
  #      mv tmp_file "$file"
  #    fi
  #  fi
  #fi

  file="$(echo "$line" | cut -d":" -f1)";
  num="$(echo "$line" | cut -d":" -f2)";
  message="$(echo "$line" | cut -d":" -f5)";
  message="$(echo "$message" | awk '{mes="";for (i=2;i<NF;++i) {mes=mes" "$i;};print $1 mes}')"

  ##### exported
  message="$(echo "$message" | awk '{mes="";for (i=4;i<=NF;++i) { mes=mes" "$i;};print $3, $1, $2 mes}')"

  #### naming
  #message="$(echo "$message" | awk '{print $7, $NF}')"
  #replace="$(echo "$message" | cut -d" " -f2)"
  #### /naming

  keyword="$(echo "$message" | cut -d" " -f1)"
  if [ "$(echo "$keyword" | awk -F"." '{print NF}')" -eq 2 ]; then
    key="$(echo "$keyword" | cut -d"." -f2)"

    ##### exported
    message="$(echo "$message" | sed "s/$keyword/$key/")"
    keyword="$key"
  fi

  ## Find the correct file
  if ! ls "$file" 2>/dev/null; then
    #var-naming
    #echo "cannot work on $file"
    #break
    match=$(git ls-files | grep "$file")
    if [ "$(echo "$match" | wc -l)" != 1 ]; then
      echo "$match" | while read -r line; do
        #### exported
        #is_word=$(awk -v loc="$num" -v pat="$key" 'NR==loc && match($0, pat)' "$line")
        #### /exported
        #### package-comment
        is_word=$(awk -v loc="$num" 'NR==loc && /^package/' "$line")
        #### /package-comment
        if [ -n "$is_word" ]; then
          echo "$line"
          break
        fi
      done > tt
      file="$(cat tt)" && rm tt
    else
      file="$match"
    fi
  fi
  echo "on file $file at line $((num - 1))"

  #### package-comment
  package=$(awk -v loc="$num" 'NR==loc' "$file" | sed 's/p/P/')
  message="$package TODO comment"
  #### /package-comment

  { head -"$((num - 1))" "$file";
  echo "// $message";
  tail -n +"$num" "$file"; }  >> tmp_file;
  mv tmp_file "$file"

  #### naming
  #find "$(dirname "$file")" -name "*.go" -exec sed -i "" "s/[[:<:]]${key}[[:>:]]/$replace/g" "$file" {} \;

  #for f in $(git grep "$key" | cut -d":" -f1 | sort -u); do
  #  sed -i "" "s/\.$key/\.$replace/g" "$f"
  #done

done < "$source_file"

## var-naming update last file
#message="//revive:disable:var-naming"
#if ! grep -q "$message" "$file"; then
#  num="$(grep -n -m1 "^[ ]*$" "$file" | cut -d":" -f1)"
#  { head -"$((num - 1))" "$file";
#  printf '\n%s\n' "$message";
#  tail -n +"$num" "$file"; }  >> tmp_file;
#  mv tmp_file "$file"
#fi

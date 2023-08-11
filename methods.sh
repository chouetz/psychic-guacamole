function for_sed() {
  for file in `git grep $1 | cut -d":" -f1 | sort -u`; do
    sed -i "" "s/$1/$2/g" $file;
  done
}
function gvi() {
  vi `git ls-files | grep $1`
}
function list_rest() {
  grep "(revive)" $1 | grep ":" | cut -d":" -f4 | sort | uniq -c
}
function resort() {
  sort -t':' -k1,1 -k2,2nr $1 > $2
}
function get_keyword() {
   local key=$1
   local lint_file=$2
   grep $1 $2| grep ":" | sort -u > transform
}
function vivi() {
  while read line; do file=`echo "$line" | cut -d":" -f1`;num=`echo "$line" | cut -d":" -f2`; echo vi +$num $file;done < $1
}

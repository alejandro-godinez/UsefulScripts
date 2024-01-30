<small><i>Auto-generated using [bashdoc.sh](https://github.com/alejandro-godinez/UsefulScripts/blob/trunk/bashdoc/bashdoc.sh)</i></small>
# [arrays.sh](../arrays.sh)

 Library of common functions for manipulating arrays or maps (associative).

 Import Sample Code:
 <pre>
 if [[ ! -f ~/lib/arrays.sh ]]; then
   echo "ERROR: Missing arrays.sh library"
   exit
 fi
 source ~/lib/arrays.sh
 </pre>


## Functions:
| Function | Description |
|----------|-------------|
| arrayHasKey(arrKey,&nbsp;arr) |  Check if the array/map has an index or key position<br>  <br>  <u>Examples:</u><br>  arrayHasKey myArray 3<br>  arrayHasKey myMap "thekey"<br>  <br><br><u><b>Args:</b></u><br>arrKey - the index or key to check <br>arr - the reference to the array or map (named reference) <br> |
| arrayDeleteIndex(arr,&nbsp;deleteIdx) |  Delete (unset) an item index position from an array. This method will  collapse all the items ahead of delete position and unset the last position.  This avoids breaking the index sequence when using unset alone.<br>  <br>  <u>Examples:</u><br>  arrayDeleteIndex myArray 3   <br><br><u><b>Args:</b></u><br>arr - the reference to the array (named reference) <br>deleteIdx - the index position to delete from the aray <br> |
| mapDeleteKey(map) |  Delete (unset) a map entry by the key.<br>  <br>  <u>Examples:</u><br>  mapDeleteKey myMap 'thekey'  <br><br><u><b>Args:</b></u><br>map - the reference to the map (named reference) <br> |
| arrayLastIndex(arr) |  Gets the index number of the last position of the array.  Note: index numbers may not be sequential if uset was used<br>  <br>  <u>Examples:</u><br>  lastIndex=$( arrayLastIndex arrayName )  <br><br><u><b>Args:</b></u><br>arr - the name reference to the array <br><br><u><b>Output:</b></u><br>the last index number it written to standard output <br> |
| arraySortAsc(arr) |  Sorts the array in acending order<br>  <br>  <u>Examples:</u><br>  arraySortAsc arrayName  <br><br><u><b>Args:</b></u><br>arr - the array reference to the array <br> |
| arraySortDesc(arr) |  Sorts the array in descending order<br>  <br>  <u>Examples:</u><br>  arraySortDesc arrayName  <br><br><u><b>Args:</b></u><br>arr - the array reference to the array <br> |
| arrayPrint(arr) |  Print the contents of the array to standard output  Prints out entries in the format "key:value"<br>  <br>  <u>Examples:</u><br>  arrayPrint arrayName  <br><br><u><b>Args:</b></u><br>arr - the reference to the array or map (named reference) <br> |

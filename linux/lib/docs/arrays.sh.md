<small><i>Auto-generated using bashdoc.sh</i></small>
# [arrays.sh](../arrays.sh)

 Library of common functions for manipulating arrays

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
| arrayDelete($1,$2) | Delete (unset) an item index position from an array. This method will collapse all the items ahead of delete position and unset the last position. This avoids breaking the index sequence.<br> <br> <u>Examples:</u><br> arrayDelete 3 arrayName  <br><br><u>Args:</u><br>$1 - the index position to delete from the aray <br>$2 - the array reference to the array <br> |
| getLastIndex($1) | Gets the index number of the last position of the array. Note: index numbers may not be sequential if uset was used<br> <br> <u>Examples:</u><br> lastIndex=$( getLastIndex arrayName )  @return - the last index number <br><br><u>Args:</u><br>$1 - the array reference to the array <br> |
| sortArrayAsc($1) | Sorts the array in acending order<br> <br> <u>Examples:</u><br> sortArrayAsc arrayName )  <br><br><u>Args:</u><br>$1 - the array reference to the array <br> |
| sortArrayDec($1) | Sorts the array in descending order<br> <br> <u>Examples:</u><br> sortArrayDec arrayName  <br><br><u>Args:</u><br>$1 - the array reference to the array <br> |

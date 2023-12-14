<small><i>Auto-generated using [bashdoc.sh](https://github.com/alejandro-godinez/UsefulScripts/blob/trunk/bashdoc/bashdoc.sh)</i></small>
# [arrays.sh](.././linux/lib/arrays.sh)

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
| arrayDelete(arr,&nbsp;deleteIdx) | Delete (unset) an item index position from an array. This method will  collapse all the items ahead of delete position and unset the last position.  This avoids breaking the index sequence.<br>  <br>  <u>Examples:</u><br>  arrayDelete 3 arrayName    <br><br><u><b>Args:</b></u><br>arr - the array reference to the array  <br>deleteIdx - the index position to delete from the aray  <br> |
| getLastIndex(arr) | Gets the index number of the last position of the array.  Note: index numbers may not be sequential if uset was used<br>  <br>  <u>Examples:</u><br>  lastIndex=$( getLastIndex arrayName )    <br><br><u><b>Args:</b></u><br>arr - the array reference to the array  <br><br><u><b>Output:</b></u><br>the last index number it written to standard output  <br> |
| sortArrayAsc(arr) | Sorts the array in acending order<br>  <br>  <u>Examples:</u><br>  sortArrayAsc arrayName )    <br><br><u><b>Args:</b></u><br>arr - the array reference to the array  <br> |
| sortArrayDec(arr) | Sorts the array in descending order<br>  <br>  <u>Examples:</u><br>  sortArrayDec arrayName    <br><br><u><b>Args:</b></u><br>arr - the array reference to the array  <br> |

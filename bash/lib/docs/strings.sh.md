<small><i>Auto-generated using [bashdoc.sh](https://github.com/alejandro-godinez/UsefulScripts/blob/trunk/bashdoc/bashdoc.sh)</i></small>
# [strings.sh](../strings.sh)

 Library implementation with function to perform common string operations

 Import Sample Code:
 <pre>
 if [[ ! -f ~/lib/strings.sh ]]; then
   echo "ERROR: Missing spinner.sh library"
   exit
 fi
 source ~/lib/strings.sh
 </pre>


## Functions:
| Function | Description |
|----------|-------------|
| padLeft() |  Pad a string to the left with additional character up to a spcific length   LIMITATION: replaces all spaces with character including those in the text  |
| padRight() |  Pad a string to the left with additional character up to a spcific length   LIMITATION: replaces all spaces with character including those in the text  |
| newLinesToSpace(text) |  Replace newline characters (cr and lf) to space  <br><br><u><b>Args:</b></u><br>text - text to perform replacement <br><br><u><b>Output:</b></u><br>the trimmed text on standard output <br> |
| trimNewLines(text) |  Trim newline characters (cr and lf)  <br><br><u><b>Args:</b></u><br>text - text to perform trim <br><br><u><b>Output:</b></u><br>the trimmed text on standard output <br> |

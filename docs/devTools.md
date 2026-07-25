# Development Tools

## [ShellCheck](https://www.shellcheck.net) 
This is a useful code analysis tool to check bash script syntax and coding issues.

*Note: Have only recently started using this not all errors and warnings have been corrected.*

Windows Install (for gitbash):
```
winget install --id koalaman.shellcheck
```

Usage Examples:
```
shellcheck.exe gitStashPullApply.sh
shellcheck.exe -f gcc gitStashPullApply.sh
shellcheck.exe -f checkstyle gitStashPullApply.sh > gitStashPullApply.sh.xml
```

Use the docs page to check reasoning for each error  
`https://www.shellcheck.net/wiki/\<THE_CODE\>`
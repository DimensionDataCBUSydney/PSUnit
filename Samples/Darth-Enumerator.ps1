function Get-Enumerator 
{
<# 
.Synopsis 
    Calls GetEnumerator() on Hashtables and IEnumerables 
.Description 
    Calls GetEnumerator() on Hashtables.
    Throws "Pipeline input is not a HashTable" Error, if -Force
    is not set and Input Object is not a HashTable.
    Calls GetEnumerator() on IEnumerables, if -Force is set.
    Throws "Pipeline input is not an IEnumerable" Error, if
    -Force is set, -Strict is set and the Input Object is not an IEnumerable.
    Passes Normal Objects that are not IEnumerables through without changes, if 
    -Force is set and -Strict is not set.
    Treats Strings as IEnumerables, if -PreserveString is not set.
    Treats Strings as Normal Objects, if -PreserveString is set.
.Example
    "Hashtable Tests"

    "----- 1"
    $Team = @{4 = "Joe"; 2 = "Steve"; 12 = "Tom"}
    $Team.GetType().Fullname

    "----- 2"
    $Team | Sort-Object

    "----- 3"
    $Team | Get-Enumerator

    "----- 4"
    $Team.GetEnumerator() | Sort-Object -Property "Key"

    "----- 5"
    $Team | Get-Enumerator | Sort-Object -Property "Key"

    "----- 6"
    $Team |e| so Key

    "----- 7"
    $Team | Get-Enumerator -Force | Sort-Object -Property "Key"

    "----- 8"
    $Team |e -f| so Key

    "----- 9"
    $Team | Get-Enumerator -Force -Strict | Sort-Object -Property "Key"

    "----- 10"
    $Team |e -f -s| so Key
.Example
    "Array Tests"

    "===== 1"
    $RosterNames = "Joe", "Steve", "Tom"
    $RosterNumbers = 4,2,12
    $RosterNames.GetType().Fullname
    $RosterNumbers.GetType().Fullname

    "===== 2"
    $RosterNumbers
    $RosterNumbers |e -f| so

    "===== 3"
    if ($true)
    {
        trap {"Expected Error: Pipeline input is not an IEnumerable - Actual Error: $_"; continue} 
        $RosterNumbers |e -f -s| so
    }

    "===== 4"
    if ($true)
    {
        trap {"Expected Error: Pipeline input is not a HashTable - Actual Error: $_"; continue} 
        $RosterNames |e| so 
    }

    "===== 5"
    if ($true)
    {
        trap {"Expected Error: Pipeline input is not a HashTable - Actual Error: $_"; continue} 
        $RosterNumbers |e| so 
    }

    "===== 6"
    $RosterNumbers | Get-Enumerator -Force | Sort-Object

    "===== 7"
    $RosterNumbers | e -f | so # Interesting: Calling GetEnumerators on the string

    "===== 8"
    $RosterNames
    $RosterNames | Get-Enumerator -Force | Sort-Object

    "===== 9"
    $RosterNames | e -f | so # Interesting: Calling GetEnumerators on the string

    "===== 10"
    $RosterNames | e -Force -PreserveString| so

    "===== 11"
    $RosterNames | e -Force -PreserveString -Strict| so

    "===== 12"
    $RosterNames | e -f -p | so

    "===== 13"
    $RosterNames | e -f -p -s| so
.Example
    "ArrayList Tests"

    "..... 1"
    $RosterNameList = New-Object -TypeName "System.Collections.ArrayList"
    $RosterNames | foreach-object {$RosterNameList.Add($_)}| Out-Null
    $RosterNameList
    $RosterNameList.GetType().Fullname

    $RosterNumberList = New-Object -TypeName "System.Collections.ArrayList"
    $RosterNumbers | foreach-object {$RosterNumberList.Add($_)} | Out-Null
    $RosterNumberList
    $RosterNumberList.GetType().Fullname

    "..... 2"
    $RosterNumberList
    $RosterNumberList |e -f| so

    "..... 3"
    if ($true)
    {
        trap {"Expected Error: Pipeline input is not an IEnumerable - Actual Error: $_"; continue} 
        $RosterNumberList |e -f -s| so #ArrayList gets implicitly converted to an array (ToArray()) and treated as such
    }

    "..... 4"
    if ($true)
    {
        trap {"Expected Error: Pipeline input is not a HashTable - Actual Error: $_"; continue} 
        $RosterNumberList |e| so
    }

    "..... 5"
    if ($true)
    {
        trap {"Expected Error: Pipeline input is not a HashTable - Actual Error: $_"; continue} 
        $RosterNameList |e| so 
    }

    "..... 6"
    $RosterNumberList | Get-Enumerator -Force | Sort-Object

    "..... 7"
    $RosterNumberList | e -f | so

    "..... 8"
    $RosterNameList
    $RosterNameList | Get-Enumerator -Force | Sort-Object

    "..... 9"
    $RosterNameList | e -f | so

    "..... 10"
    $RosterNameList | e -Force -PreserveString| so

    "..... 11"
    $RosterNameList | e -Force -PreserveString -Strict| so

    "..... 12"
    $RosterNameList | e -f -p | so

    "..... 13"
    $RosterNameList | e -f -p -s| so
.Example
    "SortedList Tests" #Doesn't have ToArray() function

    "~~~~~ 1"
    $RosterNameList = New-Object -TypeName "System.Collections.SortedList"
    $RosterNames | foreach-object {$RosterNameList.Add($_, $_)}| Out-Null
    $RosterNameList
    $RosterNameList.GetType().Fullname

    $RosterNumberList = New-Object -TypeName "System.Collections.SortedList"
    $RosterNumbers | foreach-object {$RosterNumberList.Add($_, $_)} | Out-Null
    $RosterNumberList
    $RosterNumberList.GetType().Fullname

    "~~~~~ 2"
    $RosterNumberList
    $RosterNumberList |e -f| %{$_.Value}

    "~~~~~ 3"
    $RosterNumberList |e -f -s| %{$_.Value}

    "~~~~~ 4"
    if ($true)
    {
        trap {"Expected Error: Pipeline input is not a HashTable - Actual Error: $_"; continue} 
        $RosterNumberList |e| %{$_.Value}
    }

    "~~~~~ 5"
    if ($true)
    {
        trap {"Expected Error: Pipeline input is not a HashTable - Actual Error: $_"; continue} 
        $RosterNameList |e| %{$_.Value} 
    }

    "~~~~~ 6"
    $RosterNumberList | Get-Enumerator -Force | Sort-Object

    "~~~~~ 7"
    $RosterNumberList | e -f | %{$_.Value}

    "~~~~~ 8"
    $RosterNameList
    $RosterNameList | Get-Enumerator -Force | Sort-Object

    "~~~~~ 9"
    $RosterNameList | e -f | %{$_.Value}

    "~~~~~ 10"
    $RosterNameList | e -f -s | %{$_.Value}

    "~~~~~ 11"
    $RosterNameList | e -Force -PreserveString| %{$_.Value}

    "~~~~~ 12"
    $RosterNameList | e -Force -PreserveString -Strict| %{$_.Value}

    "~~~~~ 13"
    $RosterNameList | e -f -p | %{$_.Value}

    "~~~~~ 14"
    $RosterNameList | e -f -p -s| %{$_.Value}
.Parameter Force
    Function doesn't throw an error, if this Parameter is set and
    the Input Object is not a Hashtable.
    Calls GetEnumerator on all Input Objects that are IEnumerables.
.Parameter Scrict
    If Force is set and Strict is set, then Input Objects that are
    not IEnumerables will cause an error.
.Parameter PreseveString
    If Input object is of type String and this Parameter is set, then GetEnumerator()
    is not being called, but the whole string returned instead.
.Parameter Enumerable
    The Input Object
.ReturnValue 
    IEnumerable or Object 
.Link 
    about_functions_advanced 
    about_functions_advanced_methods 
    about_functions_advanced_parameters 
.Notes 
NAME:      Get-Enumerator 
AUTHOR:    Klaus Graefensteiner 
LASTEDIT:  04/09/2009 12:12:42
#Requires -Version 2.0 
#> 

    [CmdletBinding()]
    PARAM(
    
        [Switch] $Force, 
        
        [Switch] $Strict,
        
        [Switch] $PreserveString,
    
        [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true)]
        [Alias("Input","Hashtable")]
        [Object] $Enumerable
    
    
    )
    Process{
    
        if( $Enumerable -is "System.Collections.Hashtable")
        {
            return $Enumerable.GetEnumerator()
        }
        
        if ( $Enumerable -is "System.String" -and $PreserveString -and $Force)
        {
            return $Enumerable
        }
        
        if( $Enumerable -is "System.Collections.IEnumerable" -and $Force )
        {
            return $Enumerable.GetEnumerator()
        }
        
        if($Force -and -not $Strict)
        {
            return $Enumerable
        }
            
        if ($Force -and $Strict)
        {
            throw("Pipeline input is not an IEnumerable")
        }
        
        throw("Pipeline input is not a HashTable")
    
    }# End Process
}

set-alias e Get-Enumerator
set-alias so Sort-Object
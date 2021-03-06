. .\PSUnit.ps1                                        #Load PSUnit frame work (Accessible via PATH environment variable set in the profile)

function Throw-Error()
{
    $Exception = New-Object -TypeName "System.InvalidOperationException"
    Throw $Exception   
}

function DontThrow-Error()
{
    "Sorry, no error!"
}

function Test.Throw-Error_ThrowsError([System.InvalidOperationException] $ExpectedException = $(new-object -TypeName "System.InvalidOperationException") )
{
    "Throwing Error"
    Throw-Error
}

function Test.DontThrow-Error_FailsTest([System.InvalidOperationException] $ExpectedException = $(new-object -TypeName "System.InvalidOperationException") )
{
    "This test is not supposed to trigger the expected exception"
    DontThrow-Error
}

function Test.ThisFunctionHasAllTestMetaData([System.InvalidOperationException] $ExpectedException = $(new-object -TypeName "System.InvalidOperationException"), [switch] $Skip, [switch] $Category_FastTests)
{
    "Function with all test meta data attributes"
}

function Test.ThisFunctionHasAllMetaExceptSkip([System.InvalidOperationException] $ExpectedException = $(new-object -TypeName "System.InvalidOperationException"), [switch] $Category_FastTests)
{
    "Function with all test meta data attributes, except the skip parameter"
}

function Test.ThisFunctionHasCategoryFastTests([switch] $Category_FastTests)
{
    "Category Fast Tests"
    Assert-That $(2 + 2) {$ActualValue -eq 4}
}


function Test.ThisFunctionHasCategoryFastTestsAndUsesTheDefaultException([switch] $Category_FastTests, [System.InvalidOperationException] $ExpectedException = $(DefaultException))
{
    "Category Fast Tests"
    Throw $(DefaultException)
    Assert-That $(2 + 2) {[System.InvalidOperationException] $ExpectedException = $(DefaultException)}
}

function Test.ThisFunctionCausesAnAssertToANonBoolean()
{
    Assert-That $(2 + 2) {"NonBooleanContraintEvaluation"}
}

function Test.ThisFunctionThrowsAnUnexpectedInvalidOperationException()
{
    Throw New-Object -TypeName "System.InvalidOperationException" -ArgumentList "Unexpected Exception!"
}

function Test.ThisFunctionThrowsSomeUnforeseenException()
{
    & (blabla.exe)   
}

function Test.ThisFunctionCausesAnAssertToANull()
{
    Assert-That $(2 + 2) {$Null}
}

function Test.ThisFunctionCausesAnAssertToThrowAnException()
{
    Assert-That $(2 + 2) {& (blabla.exe)}
}

function Test.ThisFunctionUsesAnUnknownExceptionTypeInTheExpectedExceptionParameter([System.InvalidOperationException] $ExpectedException = $(New-Object -TypeName "System.CPUOverclockedExcpetion"))
{
    Assert-That $(2 + 2) {$ActualValue -eq 4}
}

function Test.ExpectPSUnitExpectedExceptionNotThrownExceptionCausesTestToPassIfNoOtherExceptionIsThrown([PSUnit.Assert.PSUnitExpectedExceptionNotThrownException] $ExpectedException = $(New-Object -TypeName "PSUnit.Assert.PSUnitExpectedExceptionNotThrownException"))
{
    "PSUnitExpectedExceptionNotThrownException is expected, but not thrown"
}

function Test.ExpectPSUnitExpectedExceptionNotThrownExceptionCausesTestToFailIfRuntimeExceptionIsThrown([PSUnit.Assert.PSUnitExpectedExceptionNotThrownException] $ExpectedException = $(New-Object -TypeName "PSUnit.Assert.PSUnitExpectedExceptionNotThrownException"))
{
    Throw-Error
}

#Assertions +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#Equality Asserts =============================================================
#Assert.AreEqual( int expected, int actual );

function Test.Assert.AreEqual()
{
    #Arrange
    [int] $Num1 = 2;
    [int] $Num2 = 2;
    
    #Act
    $Result = $Num1 + $Num2
    
    #Assert
    Assert-That -ActualValue $Result -Constraint {$ActualValue -eq 4}
}

#Assert.AreNotEqual( int expected, int actual );
function Test.Assert.AreNotEqual()
{
    #Arrange
    [int] $Num1 = 2;
    [int] $Num2 = 2;
    
    #Act
    $Result = $Num1 + $Num2
    
    #Assert
    Assert-That -ActualValue $Result -Constraint {$ActualValue -ne 5}
}

#Special Cases
#Assert.AreEqual( double.PositiveInfinity, double.PositiveInfinity );
function Test.Assert.AreEqualPositiveInfinity()
{
    #Arrange
    [Double] $Num1 = [Double]::PositiveInfinity;
    
    #Act
    $Result = $Num1
    
    #Assert
    Assert-That -ActualValue $Result -Constraint {$ActualValue -eq [Double]::PositiveInfinity}
}

#Assert.AreEqual( double.NegativeInfinity, double.NegativeInfinity );
function Test.Assert.AreEqualNegativeInfinity()
{
    #Arrange
    [Double] $Num1 = [Double]::NegativeInfinity;
    
    #Act
    $Result = $Num1
    
    #Assert
    Assert-That -ActualValue $Result -Constraint {$ActualValue -eq [Double]::NegativeInfinity}
}

#Assert.AreEqual( double.NaN, double.NaN );
function Test.Assert.AreEqualNaN()
{
    #Arrange
    [Double] $Num1 = [Double]::NaN;
    
    #Act
    $Result = $Num1
    
    #Assert
    Assert-That -ActualValue $Result -Constraint {$ActualValue -eq [Double]::NaN}
}

#Assert.AreEqual( double expected, double actual ); GlobalSettings.DefaultFloatingPointTolerance
function Test.Assert.AreEqualUsingFloatingPointTolerance()
{
    #Arrange
    [Double] $Num1 = 10.00;
    [Double] $Num2 = 3;
    
    [Double] $FloatingPointTolerance = 0.001
    
    #Act
    $Result = $Num1 / $Num2
    
    #Assert
    Assert-That -ActualValue $Result -Constraint {$ActualValue -le (3.333 + $FloatingPointTolerance) -and $ActualValue -ge (3.333 - $FloatingPointTolerance)}
}

#Assert.AreEqual( double expected, double actual ); GlobalSettings.DefaultFloatingPointTolerance
function Test.Assert.AreNotEqualUsingFloatingPointTolerance()
{
    #Arrange
    [Double] $Num1 = 10.00;
    [Double] $Num2 = 3;
    
    [Double] $FloatingPointTolerance = 0.0001
    
    #Act
    $Result = $Num1 / $Num2
    
    #Assert
    Assert-That -ActualValue $Result -Constraint {!($ActualValue -le (3.333 + $FloatingPointTolerance) -and $ActualValue -ge (3.333 - $FloatingPointTolerance))}
}

#Identity Asserts =============================================================

#Assert.AreSame and Assert.AreNotSame test whether the same objects are referenced by the two arguments.
#Assert.AreSame( object expected, object actual );
function Test.Assert.AreSame()
{
    #Arrange
    $Hash1 = @{}
    $Hash1[1] = "one"
    $Hash1[2] = "two"
    
    $Hash3 = @{}
    $Hash3[1] = "one"
    $Hash3[2] = "two"
    
    #Act
    $Hash2 = $Hash1

    #Assert
    Assert-That -ActualValue $Hash2 -Constraint {$ActualValue -eq $Hash1}
    Assert-That -ActualValue $Hash2 -Constraint {$ActualValue -ne $Hash3}
}

#Assert.AreNotSame( object expected, object actual );
function Test.Assert.AreNotSame()
{
    #Arrange
    $Hash1 = @{}
    $Hash1[1] = "one"
    $Hash1[2] = "two"
    
    $Hash3 = @{}
    $Hash3[1] = "one"
    $Hash3[2] = "two"
    
    #Act
    $Hash2 = $Hash1

    #Assert
    Assert-That -ActualValue $Hash1 -Constraint {$ActualValue -ne $Hash3}
}

#Assert.Contains is used to test whether an object is contained in an array or list.
#Assert.Contains( object anObject, IList collection );
function Test.Assert.Contains()
{
    #Arrange
    $Hash = @{}
    $Hash[1] = "one"
    $Hash[2] = "two"
    
    #Act
    $Value = 1

    #Assert
    Assert-That -ActualValue $Value -Constraint {$Hash[$ActualValue] -ne $Null}
}

#Condition Tests ==============================================================
#Assert.IsTrue( bool condition );
function Test.Assert.IsTrue()
{
    #Arrange
    [Bool] $Value = $false
    
    #Act
    $Value = $True

    #Assert
    Assert-That -ActualValue $Value -Constraint {$ActualValue -eq $True}
}

#Assert.IsFalse( bool condition);
function Test.Assert.IsFalse()
{
    #Arrange
    [Bool] $Value = $True
    
    #Act
    $Value = $False

    #Assert
    Assert-That -ActualValue $Value -Constraint {$ActualValue -eq $False}
}

#Assert.IsNull( object anObject ); Need to consider $ActualValue is $Null case
function Test.Assert.IsNull()
{
    #Arrange
    $Value = $Null
    
    #Act
    $Value = $Null

    #Assert
    Assert-That -ActualValue $Value -Constraint {$ActualValue -eq $Null}
}

#Assert.IsNotNull( object anObject );
function Test.Assert.IsNotNull()
{
    #Arrange
    $Value = $Null
    
    #Act
    $Value = "A real value"

    #Assert
    Assert-That -ActualValue $Value -Constraint {$ActualValue -ne $Null}
}

#Assert.IsNaN( double aDouble );
function Test.Assert.IsNaN()
{
    #Arrange
    $Value = $Null
    
    #Act
    $Value = [Double]::NaN

    #Assert
    Assert-That -ActualValue $Value -Constraint {$ActualValue -eq [Double]::NaN}
}

#Assert.IsEmpty( string aString );
function Test.Assert.IsEmptyString()
{
    #Arrange
    $Value = $Null
    
    #Act
    $Value = ""

    #Assert
    Assert-That -ActualValue $Value -Constraint {$ActualValue -eq [String]::Empty}
}

#Assert.IsNotEmpty( string aString );
function Test.Assert.IsNotEmptyString()
{
    #Arrange
    $Value = $Null
    
    #Act
    $Value = "A real value"

    #Assert
    Assert-That -ActualValue $Value -Constraint {$ActualValue -ne [String]::Empty}
}

#Assert.IsEmpty( ICollection collection );
function Test.Assert.IsEmptyCollection()
{
    #Arrange
    $Value = $Null
    
    #Act
    $Value = New-Object -TypeName "System.Collections.ArrayList"
    $Value.Clear()

    #Assert
    Assert-That -ActualValue $Value -Constraint {$ActualValue.Count -eq 0}
}

#Assert.IsNotEmpty( ICollection collection );
function Test.Assert.IsNotEmptyCollection()
{
    #Arrange
    $Value = $Null
    
    #Act
    $Value = New-Object -TypeName "System.Collections.ArrayList"
    $Result = $Value.Add("At least one item")

    #Assert
    Assert-That -ActualValue $Value -Constraint {$ActualValue.Count -ne 0}
}

#Comparisons ==================================================================

#Assert.Greater( int arg1, int arg2 );
function Test.Assert.Greater()
{
    #Arrange
    $Number1 = 10
    
    #Act

    #Assert
    Assert-That -ActualValue $Number1 -Constraint {$ActualValue -gt 9}
}

#Assert.GreaterOrEqual( int arg1, int arg2 );
function Test.Assert.GreaterOrEqual()
{
    #Arrange
    $Number1 = 10
    
    #Act

    #Assert
    Assert-That -ActualValue $Number1 -Constraint {$ActualValue -ge 10}
}

#Assert.Less( int arg1, int arg2 );
function Test.Assert.Less()
{
    #Arrange
    $Number1 = 10
    
    #Act

    #Assert
    Assert-That -ActualValue $Number1 -Constraint {$ActualValue -lt 11}
}

#Assert.LessOrEqual( int arg1, int arg2 );
function Test.Assert.LessOrEqual()
{
    #Arrange
    $Number1 = 10
    
    #Act

    #Assert
    Assert-That -ActualValue $Number1 -Constraint {$ActualValue -le 10}
}

#Special cases are DateTime
function Test.Assert.CompareDateTime()
{
    #Arrange
    $Yesterday = [DateTime]::Now.AddDays(-1)
    $Today = [DateTime]::Now
    
    #Act

    #Assert
    Assert-That -ActualValue $Yesterday -Constraint {$ActualValue -le $Today}
}

#Type Asserts =================================================================

#Assert.IsInstanceOfType( Type expected, object actual );
function Test.Assert.IsInstanceOfType()
{
    #Arrange
    $Team = @{1="eins";2="zwei";3="drei"}
    
    #Act

    #Assert
    Assert-That -ActualValue $Team -Constraint {$ActualValue -is "System.Collections.Hashtable"}
}	
	
#Assert.IsNotInstanceOfType( Type expected, object actual );
function Test.Assert.IsNotInstanceOfType()
{
    #Arrange
    $Team = @{1="eins";2="zwei";3="drei"}
    
    #Act

    #Assert
    Assert-That -ActualValue $Team -Constraint {$ActualValue -isnot "System.Collections.ArrayList"}
}
	
#Assert.IsAssignableFrom( Type expected, object actual );
function Test.Assert.IsAssignableFrom()
{
    #Arrange
    $IntArraySize10 = New-Object -TypeName "int[]" -Argumentlist 10
    $IntArraySize2 = New-Object -TypeName "int[]" -Argumentlist 2

    #Act
    $IntArraySize10Type = $IntArraySize10.GetType()
    $IntArraySize2Type = $IntArraySize2.GetType()

    #Assert
    Assert-That -ActualValue $IntArraySize10Type -Constraint {$ActualValue.IsAssignableFrom($IntArraySize2Type)}
}
			
#Assert.IsNotAssignableFrom( Type expected, object actual );
function Test.Assert.IsNotAssignableFrom()
{
    #Arrange
    $IntArraySize10 = New-Object -TypeName "int[]" -Argumentlist 10

    #Act
    $IntArraySize10Type = $IntArraySize10.GetType()

    #Assert
    Assert-That -ActualValue $IntArraySize10Type -Constraint {!$ActualValue.IsAssignableFrom(("hello".GetType()))}
}

#Utility Methods ==============================================================

#Assert.Fail()
#Assert.Ignore()

#Exception Assert =============================================================

#PSUnit uses the ExpectedException parameter

#String Asserts ===============================================================

#StringAssert.Contains( string expected, string actual );
function Test.StringAssert.Contains()
{
    #Arrange
    $Greeting = "Hello Test"

    #Act
    $SearchString = "Hello"

    #Assert
    Assert-That -ActualValue $Greeting -Constraint {$ActualValue.Contains($SearchString)}
}

#StringAssert.StartsWith( string expected, string actual );
function Test.StringAssert.StartsWith()
{
    #Arrange
    $Greeting = "Hello Test"

    #Act
    $SearchString = "Hello"

    #Assert
    Assert-That -ActualValue $Greeting -Constraint {$ActualValue.StartsWith($SearchString)}
}

#StringAssert.EndsWith( string expected, string actual );
function Test.StringAssert.EndsWith()
{
    #Arrange
    $Greeting = "Hello Test"

    #Act
    $SearchString = "Test"

    #Assert
    Assert-That -ActualValue $Greeting -Constraint {$ActualValue.EndsWith($SearchString)}
}

#StringAssert.AreEqualIgnoringCase( string expected, string actual );
function Test.StringAssert.AreEqualIgnoringCase()
{
    #Arrange
    $Greeting = "Hello Test"

    #Act
    $GreetingLowerCase = "hello test"

    #Assert
    Assert-That -ActualValue $Greeting -Constraint {[String]::Equals($Greeting , $GreetingLowerCase, [System.StringComparison]::CurrentCultureIgnoreCase)}
}
				
#StringAssert.IsMatch( string regexPattern, string actual );
function Test.StringAssert.IsMatch()
{
    #Arrange
    $Greeting = "Hello Test"

    #Act
    $Pattern = "H\w{4}\sTest"

    #Assert
    Assert-That -ActualValue $Greeting -Constraint {$ActualValue -match $Pattern}
}

#Collection Asserts ===========================================================

#CollectionAssert.AllItemsAreInstancesOfType( IEnumerable collection, Type expectedType );
function Test.CollectionAssert.AllItemsAreInstancesOfType()
{
    #Arrange
    $Names = New-Object -TypeName "System.Collections.ArrayList"

    #Act
    $Names.Add([String] "Udo") | out-Null
    $Names.Add([String] "Nena") | out-Null
    $Names.Add([String] "Charlie") | out-Null

    #Assert
    Assert-That -ActualValue $Names -Constraint {$ActualValue | ForEach-Object{if( $_ -isnot "String"){return $false}}; return $true}
}

#CollectionAssert.AllItemsAreNotNull( IEnumerable collection );
function Test.CollectionAssert.AllItemsAreNotNull()
{
    #Arrange
    $Names = New-Object -TypeName "System.Collections.ArrayList"

    #Act
    $Names.Add([String] "Udo") | out-Null
    $Names.Add([String] "Nena") | out-Null
    $Names.Add([String] "Charlie") | out-Null

    #Assert
    Assert-That -ActualValue $Names -Constraint {$ActualValue | ForEach-Object{if($_ -eq $null){return $false}}; return $true}
}

#CollectionAssert.AllItemsAreUnique( IEnumerable collection );
function Test.CollectionAssert.AllItemsAreUnique()
{
    #Arrange
    $Names = New-Object -TypeName "System.Collections.ArrayList"

    #Act
    $Names.Add([String] "Udo") | out-Null
    $Names.Add([String] "Nena") | out-Null
    $Names.Add([String] "Charlie") | out-Null

    #Assert
    Assert-That -ActualValue $Names -Constraint {$UniqueActualValue = $ActualValue | Sort-Object -Unique; return ($ActualValue.Count -eq $UniqueActualValue.Count)}
}

#CollectionAssert.AreEqual( IEnumerable expected, IEnumerable actual );
#The AreEqual overloads succeed if the two collections contain the same objects, in the same order. 
function Test.CollectionAssert.AreEqual()
{
    #Arrange
    $Names = New-Object -TypeName "System.Collections.ArrayList"
    $Roster = New-Object -TypeName "System.Collections.ArrayList"

    #Act
    $Names.Add([String] "Udo") | out-Null
    $Names.Add([String] "Nena") | out-Null
    $Names.Add([String] "Charlie") | out-Null
    
    $Roster.Add([String] "Udo") | out-Null
    $Roster.Add([String] "Nena") | out-Null
    $Roster.Add([String] "Charlie") | out-Null

    #Assert
    Assert-That -ActualValue $Names -Constraint {(Compare-Object -ReferenceObject $Roster -DifferenceObject $ActualValue -SyncWindow 0) -eq $Null}
}

#CollectionAssert.AreEquivalent( IEnumerable expected, IEnumerable actual);
#AreEquivalent tests whether the collections contain the same objects, without regard to order.
function Test.CollectionAssert.AreEquivalent()
{
    #Arrange
    $Names = New-Object -TypeName "System.Collections.ArrayList"
    $Roster = New-Object -TypeName "System.Collections.ArrayList"

    #Act
    $Names.Add([String] "Udo") | out-Null
    $Names.Add([String] "Nena") | out-Null
    $Names.Add([String] "Charlie") | out-Null
    
    $Roster.Add([String] "Udo") | out-Null
    $Roster.Add([String] "Charlie") | out-Null
    $Roster.Add([String] "Nena") | out-Null

    #Assert
    Assert-That -ActualValue $Names -Constraint {(Compare-Object -ReferenceObject $Roster -DifferenceObject $ActualValue -SyncWindow ($Roster.Count)) -eq $Null}
}

#CollectionAssert.AreNotEqual( IEnumerable expected, IEnumerable actual );
#The AreEqual overloads succeed if the two collections contain the same objects, in the same order. 
function Test.CollectionAssert.AreNotEqual()
{
    #Arrange
    $Names = New-Object -TypeName "System.Collections.ArrayList"
    $Roster = New-Object -TypeName "System.Collections.ArrayList"

    #Act
    $Names.Add([String] "Udo") | out-Null
    $Names.Add([String] "Nena") | out-Null
    $Names.Add([String] "Charlie") | out-Null
    
    $Roster.Add([String] "Nena") | out-Null
    $Roster.Add([String] "Udo") | out-Null
    $Roster.Add([String] "Charlie") | out-Null

    #Assert
    Assert-That -ActualValue $Names -Constraint {(Compare-Object -ReferenceObject $Roster -DifferenceObject $ActualValue -SyncWindow 0).Count -gt 0}
}

#CollectionAssert.AreNotEquivalent( IEnumerable expected, IEnumerable actual );
#AreEquivalent tests whether the collections contain the same objects, without regard to order.
function Test.CollectionAssert.AreNotEquivalent()
{
    #Arrange
    $Names = New-Object -TypeName "System.Collections.ArrayList"
    $Roster = New-Object -TypeName "System.Collections.ArrayList"

    #Act
    $Names.Add([String] "Udo") | out-Null
    $Names.Add([String] "Nena") | out-Null
    $Names.Add([String] "Charlie") | out-Null
    
    $Roster.Add([String] "Udo") | out-Null
    $Roster.Add([String] "Jim") | out-Null
    $Roster.Add([String] "Nena") | out-Null

    #Assert
    Assert-That -ActualValue $Names -Constraint {(Compare-Object -ReferenceObject $Roster -DifferenceObject $ActualValue -SyncWindow ($Roster.Count)).Count -gt 0}
}

#CollectionAssert.Contains( IEnumerable expected, object actual );
function Test.CollectionAssert.Contains()
{
    #Arrange
    $Names = New-Object -TypeName "System.Collections.ArrayList"

    #Act
    $Names.Add([String] "Udo") | out-Null
    $Names.Add([String] "Nena") | out-Null
    $Names.Add([String] "Charlie") | out-Null
    
    #Assert
    Assert-That -ActualValue $Names -Constraint {$ActualValue.Contains("Udo")}
}

#CollectionAssert.DoesNotContain( IEnumerable expected, object actual );
function Test.CollectionAssert.DoesNotContain()
{
    #Arrange
    $Names = New-Object -TypeName "System.Collections.ArrayList"

    #Act
    $Names.Add([String] "Udo") | out-Null
    $Names.Add([String] "Nena") | out-Null
    $Names.Add([String] "Charlie") | out-Null
    
    #Assert
    Assert-That -ActualValue $Names -Constraint {!$ActualValue.Contains("Jim")}
}

#CollectionAssert.IsSubsetOf( IEnumerable subset, IEnumerable superset );
function Test.CollectionAssert.IsSubsetOf()
{
    #Arrange
    $Names = New-Object -TypeName "System.Collections.ArrayList"
    $Roster = New-Object -TypeName "System.Collections.ArrayList"


    #Act
    $Names.Add([String] "Udo") | out-Null
    $Names.Add([String] "Nena") | out-Null
    $Names.Add([String] "Charlie") | out-Null
    $Roster.Add([String] "Nena") | out-Null
    $Roster.Add([String] "Charlie") | out-Null

    
    #Assert
    Assert-That -ActualValue $Roster -Constraint {$ActualValue.count -le $Names.count}
    Assert-That -ActualValue $Roster -Constraint {$ActualValue.count -eq (Compare-Object -DifferenceObject $ActualValue -ReferenceObject $Names -SyncWindow $Names.count -IncludeEqual -ExcludeDifferent).count}
}

#CollectionAssert.IsNotSubsetOf( IEnumerable subset, IEnumerable superset);
function Test.CollectionAssert.IsNotSubsetOf()
{
    #Arrange
    $Names = New-Object -TypeName "System.Collections.ArrayList"
    $Roster = New-Object -TypeName "System.Collections.ArrayList"

    #Act
    $Names.Add([String] "Udo") | out-Null
    $Names.Add([String] "Nena") | out-Null
    $Names.Add([String] "Charlie") | out-Null
    $Roster.Add([String] "Nena") | out-Null
    $Roster.Add([String] "Charlie") | out-Null

        
    #Assert
    
    #$Names is not a subset of $Roster if $Names.Count is greater than $Roster.Count or if at least one of $Names elements is not in $Roster

    $CompareResult = Compare-Object -ReferenceObject $Roster -DifferenceObject $Names -SyncWindow 3
    $StrangeItemFound = $false
    $CompareResult | ForEach-Object { if($_.SideIndicator -eq "=>"){$StrangeItemFound = $True }}
    Assert-That -ActualValue $Names -Constraint {($ActualValue.count -gt $Roster.count) -or $StrangeItemFound}
    
}

#CollectionAssert.IsEmpty( IEnumerable collection );
function Test.CollectionAssert.IsEmpty()
{
    #Arrange
    $Names = New-Object -TypeName "System.Collections.ArrayList"

    #Act
    $Names.Clear()
    
    #Assert
    Assert-That -ActualValue $Names -Constraint {$ActualValue.count -eq 0}
}

#CollectionAssert.IsNotEmpty( IEnumerable collection );
function Test.CollectionAssert.IsNotEmpty()
{
    #Arrange
    $Names = New-Object -TypeName "System.Collections.ArrayList"

    #Act
    $Names.Add([String] "Udo") | out-Null
    
    #Assert
    Assert-That -ActualValue $Names -Constraint {$ActualValue.count -gt 0}
}

#CollectionAssert.IsOrdered( IEnumerable collection );
function Test.CollectionAssert.IsOrdered()
{
    #Arrange
    $Names = New-Object -TypeName "System.Collections.ArrayList"
    
    #Act
    $Names.Add([String] "Charlie") | out-Null
    $Names.Add([String] "Kipper") | out-Null
    $Names.Add([String] "Lola") | out-Null
    
    $SortedNames = $Names | Sort-Object 

    #Assert
    Assert-That -ActualValue $Names -Constraint {(Compare-Object -ReferenceObject $SortedNames -DifferenceObject $ActualValue -SyncWindow 0) -eq $null}
}

#File Asserts =================================================================

#FileAssert.AreEqual( FileInfo expected, FileInfo actual );
function Test.FileAssert.PathsAreEqual()
{
    #Arrange
    $FileA = New-Item -Name "FileA.txt" -ItemType "File" -Force
    
    #Act
    $FileB = Get-Item -Path "FileA.txt"

    #Assert
    Assert-That -ActualValue $FileB -Constraint {$ActualValue.FullName -eq $FileA.FullName}
}

#FileAssert.AreNotEqual( FileInfo expected, FileInfo actual );
function Test.FileAssert.PathsAreNotEqual()
{
    #Arrange
    $FileA = New-Item -Name "FileA.txt" -ItemType "File" -Force
    
    #Act
    $FileB = New-Item -Name "FileB.txt" -ItemType "File" -Force

    #Assert
    Assert-That -ActualValue $FileB -Constraint {$ActualValue.FullName -ne $FileA.FullName}
}

function Test.FileAssert.ContentsAreEqual()
{
    #Arrange
    $FileA = New-Item -Name "FileA.txt" -ItemType "File" -Force
    "Some Content" > $FileA
    
    #Act
    $FileB = New-Item -Name "FileB.txt" -ItemType "File" -Force
    "Some Content" > $FileB
    
    #Assert
    Assert-That -ActualValue $FileB -Constraint {((New-MD5CheckSum $ActualValue.FullName) -eq (New-MD5CheckSum $FileA.FullName))}
}

#FileAssert.AreNotEqual( FileInfo expected, FileInfo actual );
function Test.FileAssert.ContentsAreNotEqual()
{
    #Arrange
    $FileA = New-Item -Name "FileA.txt" -ItemType "File" -Force
    "Some Content" > $FileA
    
    #Act
    $FileB = New-Item -Name "FileB.txt" -ItemType "File" -Force
    "Some Other Content" > $FileB
    
    #Assert
    Assert-That -ActualValue $FileB -Constraint {((New-MD5CheckSum $ActualValue.FullName) -ne (New-MD5CheckSum $FileA.FullName))}
    
}

function New-MD5CheckSum([String] $Path)
{
    $Algorithm = [System.Security.Cryptography.HashAlgorithm]::Create("MD5")
    $Stream = New-Object System.IO.FileStream($Path, [System.IO.FileMode]::Open)
    $MD5StringBuilder = New-Object -TypeName "System.Text.StringBuilder"
    $Algorithm.ComputeHash($Stream) | ForEach-Object { [void] $MD5StringBuilder.Append($_.ToString("x2")) } 
    $stream.Dispose()
    $MD5String = $MD5StringBuilder.ToString()
    Write-Debug "$MD5String $Path"
    return $MD5String
}

#Directory Assert =============================================================

#DirectoryAssert.AreEqual( DirectoryInfo expected, DirectoryInfo actual );
function Test.DirectoryAssert.AreEqual()
{
    #Arrange
    $DirectoryA = New-Item -Name "DirectoryA" -ItemType "Directory" -Force
    
    #Act
    $DirectoryB = Get-Item "DirectoryA"

    #Assert
    Assert-That -ActualValue $DirectoryB -Constraint {$ActualValue.FullName -eq $DirectoryA.FullName}
}

#DirectoryAssert.AreNotEqual( DirectoryInfo expected, DirectoryInfo actual );
function Test.DirectoryAssert.AreNotEqual()
{
    #Arrange
    $DirectoryA = New-Item -Name "DirectoryA" -ItemType "Directory" -Force
    
    #Act
    $DirectoryB = New-Item -Name "DirectoryB" -ItemType "Directory" -Force

    #Assert
    Assert-That -ActualValue $DirectoryB -Constraint {$ActualValue.FullName -ne $DirectoryA.FullName}
}

#DirectoryAssert.IsEmpty( DirectoryInfo directory );
function Test.DirectoryAssert.IsEmpty()
{
    #Arrange
    $DirectoryD = New-Item -Name "DirectoryD" -ItemType "Directory" -Force
    
    #Act
    $Result = @(dir $DirectoryD)
    
    #Assert
    Assert-That -ActualValue $Result -Constraint {$ActualValue.count -eq 0}
}

#DirectoryAssert.IsNotEmpty( DirectoryInfo directory );
function Test.DirectoryAssert.IsNotEmpty()
{
    #Arrange
    $DirectoryC = New-Item -Name "DirectoryC" -ItemType "Directory" -Force
    $FileC = New-Item -Name "FileC" -Path $DirectoryC.FullName -ItemType "File" -Force
    
    #Act
    $Result = @(dir $DirectoryC)
    
    #Assert
    Assert-That -ActualValue $Result -Constraint {$ActualValue.count -ne 0}
}

#DirectoryAssert.IsWithin( DirectoryInfo expected, DirectoryInfo actual );
function Test.DirectoryAssert.IsWithin()
{
    #Arrange
    $DirectoryC = New-Item -Name "DirectoryC" -ItemType "Directory" -Force
    $FileC = New-Item -Name "FileC" -Path $DirectoryC.FullName -ItemType "File" -Force
    
    #Act
    $Result = @(Get-Childitem -Path $DirectoryC.FullName -Name $FileC.Name -Recurse)
    
    #Assert
    Assert-That -ActualValue $Result -Constraint {$ActualValue.count -ne 0}
}

#DirectoryAssert.IsNotWithin( DirectoryInfo expected, DirectoryInfo actual );
function Test.DirectoryAssert.IsNotWithin()
{
    #Arrange
    $DirectoryC = New-Item -Name "DirectoryC" -ItemType "Directory" -Force
    $DirectoryF = New-Item -Name "DirectoryF" -ItemType "Directory" -Force

    $FileF = New-Item -Name "FileF" -Path $DirectoryF.FullName -ItemType "File" -Force
    
    #Act
    $Result = @(Get-Childitem -Path $DirectoryC.FullName -Name $FileF.Name -Recurse)
    
    #Assert
    Assert-That -ActualValue $Result -Constraint {$ActualValue.count -eq 0}
}
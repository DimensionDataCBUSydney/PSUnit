function DefaultException()
{
    return $(new-object -TypeName "System.InvalidOperationException")
}

function Set-DebugMode()
{
    $Global:DebugPreference = "Continue"
    set-strictmode -version Latest
}

function Set-ProductionMode()
{
    $Global:DebugPreference = "SilentlyContinue"
    set-strictmode -Off
}

$PSUnitAssertFailedExceptionCode =
@"
    using System;

    namespace PSUnit.Assert
    {
        public class PSUnitAssertFailedException : System.Exception
        {
            public PSUnitAssertFailedException()
            {
            }
            public PSUnitAssertFailedException(string message) : base(message)
            {
            }
            public PSUnitAssertFailedException(string message, Exception innerException)
            : base(message, innerException)
            {
            }
        }
    }
"@

$PSUnitExpectedExceptionNotInstantiableExceptionCode =
@"
    using System;

    namespace PSUnit.Assert
    {
      public class PSUnitExpectedExceptionNotInstantiableException : System.Exception
      {
        public PSUnitExpectedExceptionNotInstantiableException()
        {
        }
        public PSUnitExpectedExceptionNotInstantiableException(string message)
          : base(message)
        {
        }

        public PSUnitExpectedExceptionNotInstantiableException(string message, string notInstantiableExceptionTypeName)
          : base(message)
        {
          NotInstantiableExceptionTypeName = notInstantiableExceptionTypeName;
        }

        public PSUnitExpectedExceptionNotInstantiableException(string message, Exception innerException)
          : base(message, innerException)
        {
        }

        private string _NotInstantiableExceptionTypeName;

    	  public string NotInstantiableExceptionTypeName
    	  {
    		  get { return _NotInstantiableExceptionTypeName;}
    		  set { _NotInstantiableExceptionTypeName = value;}
    	  }
    	
      }
    }
"@

$PSUnitAssertEvaluatedToFalseExceptionCode =
@"
    using System;

    namespace PSUnit.Assert
    {
        public class PSUnitAssertEvaluatedToFalseException : System.Exception
        {
            public PSUnitAssertEvaluatedToFalseException()
            {
            }
            public PSUnitAssertEvaluatedToFalseException(string message) : base(message)
            {
            }
            public PSUnitAssertEvaluatedToFalseException(string message, Exception innerException)
                : base(message, innerException)
            {
            }
        }
    }
"@

$PSUnitAssertEvaluatedToNonBooleanTypeExceptionCode=
@"
    using System;

    namespace PSUnit.Assert
    {
        public class PSUnitAssertEvaluatedToNonBooleanTypeException : System.Exception
        {
            public PSUnitAssertEvaluatedToNonBooleanTypeException()
            {
            }
            public PSUnitAssertEvaluatedToNonBooleanTypeException(string message) : base(message)
            {
            }
            public PSUnitAssertEvaluatedToNonBooleanTypeException(string message, Exception innerException)
            : base(message, innerException)
            {
            }
        }
    }
"@

$PSUnitExpectedExceptionNotThrownExceptionCode=
@"
    using System;

    namespace PSUnit.Assert
    {
        public class PSUnitExpectedExceptionNotThrownException : System.Exception
        {
            public PSUnitExpectedExceptionNotThrownException()
            {
            }
            public PSUnitExpectedExceptionNotThrownException(string message) : base(message)
            {
            }
            public PSUnitExpectedExceptionNotThrownException(string message, Exception innerException)
            : base(message, innerException)
            {
            }
        }
    }
"@

$PSUnitExpectedExceptionCode=
@"
    using System;

    namespace PSUnit.Assert
    {
        public class PSUnitExpectedException
        {
            public PSUnitExpectedException()
            {
            }
        }
    }
"@

$PSUnitCategoryCode=
@"
    using System;

    namespace PSUnit.Assert
    {
        public class PSUnitCategory
        {
            public PSUnitCategory()
            {
            }
        }
    }
"@

function Build-PSUnitAssertFailedExceptionType()
{
    Add-Type -TypeDefinition $PSUnitAssertFailedExceptionCode
    Write-Debug "Build-PSUnitAssertFailedExceptionType"
}

function Build-PSUnitAssertEvaluatedToFalseExceptionType()
{
    Add-Type -TypeDefinition $PSUnitAssertEvaluatedToFalseExceptionCode
    Write-Debug "Build-PSUnitAssertEvaluatedToFalseExceptionType"

}

function Build-PSUnitAssertEvaluatedToNonBooleanTypeExceptionType()
{
    Add-Type -TypeDefinition $PSUnitAssertEvaluatedToNonBooleanTypeExceptionCode
    Write-Debug "Build-PSUnitAssertEvaluatedToNonBooleanTypeExceptionType"
}

function Build-PSUnitExpectedExceptionNotThrownExceptionType()
{
    Add-Type -TypeDefinition $PSUnitExpectedExceptionNotThrownExceptionCode
    Write-Debug "Build-PSUnitExpectedExceptionNotThrownExceptionType"
}

function Build-PSUnitExpectedExceptionNotInstantiableExceptionType()
{
    Add-Type -TypeDefinition $PSUnitExpectedExceptionNotInstantiableExceptionCode
    Write-Debug "Build-PSUnitExpectedExceptionNotInstantiableExceptionType"
}

function Build-PSUnitExpectedExceptionType()
{
    Add-Type -TypeDefinition $PSUnitExpectedExceptionCode
    Write-Debug "Build-PSUnitExpectedExceptionType"
}

function Build-PSUnitCategoryType()
{
    Add-Type -TypeDefinition $PSUnitCategoryCode
    Write-Debug "Build-PSUnitCategoryType"
}

Build-PSUnitAssertFailedExceptionType
Build-PSUnitAssertEvaluatedToFalseExceptionType
Build-PSUnitAssertEvaluatedToNonBooleanTypeExceptionType
Build-PSUnitExpectedExceptionNotThrownExceptionType
Build-PSUnitExpectedExceptionNotInstantiableExceptionType
Build-PSUnitExpectedExceptionType
Build-PSUnitCategoryType


function Get-ErrorRecord([string] $InnerExceptionTypeName, [string] $OuterExceptionTypeName, [string] $OuterExceptionMessage)
{
    $ErrorRecord = $Null
    try
    {
        try
        {
            Throw New-Object -TypeName $InnerExceptionTypeName
        }
        catch
        {
            $OuterException = New-Object -TypeName $OuterExceptionTypeName -ArgumentList $OuterExceptionMessage, $($_.Exception)
            Throw $OuterException
        }
    }
    catch
    {
        $ErrorRecord = $_
    }
    return $ErrorRecord
}

function Format-ErrorRecord([System.Management.Automation.ErrorRecord] $Record)
{
    $StringOutput = ""
    if ($Record.FullyQualifiedErrorId -ne "NativeCommandErrorMessage" -and $ErrorView -ne "CategoryView") 
    {
        $myinv = $Record.InvocationInfo
        if($myinv.MyCommand)
        {
            switch -regex ($myinv.MyCommand.CommandType)
            {
                "ExternalScript"
                {
                    if ($myinv.MyCommand.Path)
                    {
                        $StringOutput += $myinv.MyCommand.Path + " : ";
                    }
                    break;
                }
                "Script"
                {
                    if ($myinv.MyCommand.ScriptBlock)
                    {
                        $StringOutput += $myinv.MyCommand.ScriptBlock.ToString() + " : ";
                    }
                    break;
                }
                default
                {
                    if ($myinv.MyCommand.Name)
                    {
                        $StringOutput += $myinv.MyCommand.Name + " : "; break;
                    }
                }
            }
        }
    }
    if ($Record.FullyQualifiedErrorId -eq "NativeCommandErrorMessage") 
    {
        $StringOutput += $Record.Exception.Message   
    }
    else
    {
        if ($Record.InvocationInfo) 
        {
            $posmsg = $Record.InvocationInfo.PositionMessage
        } 
        else 
        {
            $posmsg = ""
        }
    				    
   		if ($Record.PSMessageDetails) 
        {
            $posmsg = " : " +  $Record.PSMessageDetails + $posmsg 
		}

        $indent = 4
        $width = $host.UI.RawUI.BufferSize.Width - $indent - 2

        $indentString = "+ CategoryInfo          : " + $Record.CategoryInfo
        $posmsg += "`n"
        foreach($line in @($indentString -split "(.{$width})")) { if($line) { $posmsg += (" " * $indent + $line) } }

        $indentString = "+ FullyQualifiedErrorId : " + $Record.FullyQualifiedErrorId
        $posmsg += "`n"
        foreach($line in @($indentString -split "(.{$width})")) { if($line) { $posmsg += (" " * $indent + $line) } }

        if ($ErrorView -eq "CategoryView") 
        {
            $StringOutput += $Record.CategoryInfo.GetMessage()
        }
        elseif (! $Record.ErrorDetails -or ! $Record.ErrorDetails.Message) 
        {
            $StringOutput += $Record.Exception.Message + $posmsg + "`n "
        } 
        else 
        {
            $StringOutput += $Record.ErrorDetails.Message + $posmsg
        }
    }
    return $StringOutput
}

#This call will be obsolete once PSUnit loads as module. System.Web will then be referenced in the Module Manifest
Add-Type -AssemblyName "System.Web"

function Encode-Html([string] $StringToEncode)
{
    $HtmlEncodedErrorRecordString = [System.Web.HttpUtility]::HtmlEncode($StringToEncode)
    return $HtmlEncodedErrorRecordString
}

Function Include-ScriptUnderTest()
{
    #Write-Debug $PSUnitTestFile
    $PSUnitFileUnderTest = ""
    if( $PSUnitTestFile -ne $Null )
    {
        if (Test-Path -Path $PSUnitTestFile)
        {
            if($PSUnitTestFile -match '.Test.ps1$')
            {
                $PSUnitFileUnderTest = $PSUnitTestFile -replace '.Test.ps1$', ".ps1"
            }
            else
            {
                Write-Warning "`$PSUnitTestFile $PSUnitTestFile doesn't follow the naming convention. File under test will not be included automatically!"
                return ".\PSUnit.EmptyInclude.ps1"
            }
        }
    }
    Write-Debug $PSUnitFileUnderTest
    
    if( Test-Path -Path $PSUnitFileUnderTest)
    {
        return $PSUnitFileUnderTest
    }
    else
    {
        Write-Warning "`$PSUnitFileUnderTest $PSUnitFileUnderTest does not exist!"
        return ".\PSUnit.EmptyInclude.ps1"
    }
}
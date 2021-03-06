. PSUnit.ps1

function Test.Is-RecordAtDesiredSampleTimeStamp_ReturnsFalseIfSecondsAreNot0()
{
    #Arrange
    $Time = New-Object -TypeName "System.DateTime" -ArgumentList 2009,1,1,10,45,01
    #Act
    $Actual = Is-RecordAtDesiredSampleTimeStamp -Time $Time -SampleInterval 10
    #Assert
    Assert-That -ActualValue $Actual -Constraint {$ActualValue -eq $false}
}

function Test.Is-RecordAtDesiredSampleTimeStamp_ReturnsFalseIfSecondsAre0ButSampleIntervalDoesntFitEvenlyInMinute()
{
    #Arrange
    $Time = New-Object -TypeName "System.DateTime" -ArgumentList 2009,1,1,10,23,0
    #Act
    $Actual = Is-RecordAtDesiredSampleTimeStamp -Time $Time -SampleInterval 10
    #Assert
    Assert-That -ActualValue $Actual -Constraint {$ActualValue -eq $false}
}

function Test.Is-RecordAtDesiredSampleTimeStamp_ReturnsTrueIfSecondsAre0AndSampleIntervalFitsEvenlyInMinute()
{
    #Arrange
    $Time = New-Object -TypeName "System.DateTime" -ArgumentList 2009,1,1,20,10,0
    #Act
    $Actual = Is-RecordAtDesiredSampleTimeStamp -Time $Time -SampleInterval 10
    #Assert
    Assert-That -ActualValue $Actual -Constraint {$ActualValue -eq $true}
}

function Test.Is-RecordAtDesiredSampleTimeStamp_ReturnsTrueIfSecondsAre0AndSampleIntervalFitsEvenlyIn0Minutes()
{
    #Arrange
    $Time = New-Object -TypeName "System.DateTime" -ArgumentList 2009,1,1,20,0,0
    #Act
    $Actual = Is-RecordAtDesiredSampleTimeStamp -Time $Time -SampleInterval 10
    #Assert
    Assert-That -ActualValue $Actual -Constraint {$ActualValue -eq $true}
}

function Test.Is-RecordAtDesiredSampleTimeStamp_ReturnsFalseIfSecondsAreNot0AndSampleIntervalFitsEvenlyInMinute()
{
    #Arrange
    $Time = New-Object -TypeName "System.DateTime" -ArgumentList 2009,1,1,20,30,13
    #Act
    $Actual = Is-RecordAtDesiredSampleTimeStamp -Time $Time -SampleInterval 10
    #Assert
    Assert-That -ActualValue $Actual -Constraint {$ActualValue -eq $false}
}

#Parameter Validation Tests

function Test.Is-RecordAtDesiredSampleTimeStamp_ThrowsArgumentOutOfRangeExceptionIfDateIsOlderThan5Years([switch] $Category_ParameterValidation, [System.ArgumentOutOfRangeException] $ExpectedException = $Null)
{
    #Arrange
    $Time = New-Object -TypeName "System.DateTime" -ArgumentList 2000,1,1,20,30,13

    #Act
    $Actual = Is-RecordAtDesiredSampleTimeStamp -Time $Time -SampleInterval 10
        
    #Assert
}

function Test.Is-RecordAtDesiredSampleTimeStamp_ThrowsArgumentOutOfRangeExceptionIfDateIsInTheFuture([switch] $Category_ParameterValidation, [System.ArgumentOutOfRangeException] $ExpectedException = $Null)
{
    #Arrange
    $Time = ([DateTime]::Now).AddDays(1)

    #Act
    $Actual = Is-RecordAtDesiredSampleTimeStamp -Time $Time -SampleInterval 10
        
    #Assert
}

function Test.Is-RecordAtDesiredSampleTimeStamp_ThrowsArgumentOutOfRangeExceptionIfDateIsInTheFuture([switch] $Category_ParameterValidation, [System.ArgumentOutOfRangeException] $ExpectedException = $Null)
{
    #Arrange
    $Time = ([DateTime]::Now).AddDays(1)

    #Act
    $Actual = Is-RecordAtDesiredSampleTimeStamp -Time $Time -SampleInterval 10
        
    #Assert
}

function Test.Is-RecordAtDesiredSampleTimeStamp_ThrowsArgumentOutOfRangeExceptionIfSampleIntervalIsGreaterThan60([switch] $Category_ParameterValidation, [System.ArgumentOutOfRangeException] $ExpectedException = $Null)
{
    #Arrange
    $Time = ([DateTime]::Now).AddDays(-1)

    #Act
    $Actual = Is-RecordAtDesiredSampleTimeStamp -Time $Time -SampleInterval 61
        
    #Assert
}

function Test.Is-RecordAtDesiredSampleTimeStamp_ThrowsArgumentOutOfRangeExceptionIfSampleIntervalIs0([switch] $Category_ParameterValidation, [System.ArgumentOutOfRangeException] $ExpectedException = $Null)
{
    #Arrange
    $Time = ([DateTime]::Now).AddDays(-1)

    #Act
    $Actual = Is-RecordAtDesiredSampleTimeStamp -Time $Time -SampleInterval 0
        
    #Assert
}

function Test.Is-RecordAtDesiredSampleTimeStamp_ThrowsArgumentOutOfRangeExceptionIfSampleIntervalIs13([switch] $Category_ParameterValidation, [System.ArgumentOutOfRangeException] $ExpectedException = $Null)
{
    #Arrange
    $Time = ([DateTime]::Now).AddDays(-1)

    #Act
    $Actual = Is-RecordAtDesiredSampleTimeStamp -Time $Time -SampleInterval 13
        
    #Assert
}

function Test.Is-RecordAtDesiredSampleTimeStamp_ThrowsArgumentOutOfRangeExceptionIfSampleIntervalIs-12([switch] $Category_ParameterValidation, [System.ArgumentOutOfRangeException] $ExpectedException = $Null)
{
    #Arrange
    $Time = ([DateTime]::Now).AddDays(-1)

    #Act
    $Actual = Is-RecordAtDesiredSampleTimeStamp -Time $Time -SampleInterval -12
        
    #Assert
}

function Test.Is-RecordAtDesiredSampleTimeStamp_DoesntThrowArgumentOutOfRangeExceptionIfSampleIntervalIs12AndTimeIsYesterday([switch] $Category_ParameterValidation)
{
    #Arrange
    $Time = ([DateTime]::Now).AddDays(-1)

    #Act
    $Actual = Is-RecordAtDesiredSampleTimeStamp -Time $Time -SampleInterval 12
        
    #Assert
}

function Test.Change-Status_ThrowsInvalidOperationExceptionIfStatusTransitionsFrom2To4([switch] $Skip)
{

    #Arrange
    $OldStatus =2
    $NewStatus =4
    
    #Act
    Change-Status -OldStatus $OldStatus -NewStatus $NewStatus
        
    #Assert
}


<#
.SYNOPSIS
    Convert the passed in string to Sentence Casing


.DESCRIPTION
    Convert the passed in string to Sentence Casing.
    Default delimiter is whiltespace (' ').


.EXAMPLE
    ConvertTo-SentenceCasing -String 'this is a test sentence'
    This Is A Test Sentence

    This command converts to Sentence Casing the passed string

.EXAMPLE
    $strings = 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua' -split ',' 
    $string | ConvertTo-SentenceCasing
    
    Lorem Ipsum Dolor Sit Amet
    Consectetur Adipisicing Elit
    Sed Do Eiusmod Tempor Incididunt Ut Labore Et Dolore Magna Aliqua

    This command prepares an array of strings and passes it to ConvertTo-SentenceCasing

    
.NOTES
    AUTHOR  : Carlo Cardella - carloc
    VERSION : 0.0.1 
    DATE    : 1/27/2016
    CHANGES : 
        -  first release
#>
function ConvertTo-SentenceCasing
{
    param(
        [parameter(mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        ## String to convert to Sentence Casing
        [string[]]$String, 
        
        [Parameter()]
        ## Delimiter
        [string]$Delimiter = ' '
    )

    process
    {
        foreach($s in $String)
        {
            $newstring = @()
            $s.Trim() -split $Delimiter | ForEach-Object {
                $newstring += "{0}{1}" -f $_[0].ToString().ToUpper(), $_.ToString().Substring(1)
            }

            [string]::Join($Delimiter, $newstring)
        }
    }
}
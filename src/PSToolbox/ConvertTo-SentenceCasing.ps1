function ConvertTo-SentenceCasing {
    <#
    .SYNOPSIS
    Convert the passed in string to Sentence Casing
    Convert the passed in string to Sentence Casing.
    Default delimiter is whiltespace (' ').

    .PARAMETER String
    String to convert to Sentence Casing

    .PARAMETER Delimiter
    Separator character used to delimit

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
    #>
    param(
        [parameter(mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string[]]$String
    )

    process {
        foreach ($s in $String) {
            $newstring = @()
            $s.Trim() -split ' ' | ForEach-Object {
                $newstring += "{0}{1}" -f $_[0].ToString().ToUpper(), $_.ToString().Substring(1)
            }

            [string]::Join(' ', $newstring)
        }
    }
}
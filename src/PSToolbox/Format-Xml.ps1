function Format-Xml {
    <#
    .SYNOPSIS
    Format and indent an XML file or string for better deadability

    .PARAMETER FileName
    XML file to format

    .PARAMETER Overwrite
    Overwrite the XML file

    .PARAMETER Xml
    XML string to format: must be on one line

    .EXAMPLE
    Format-Xml -Xml '<one><two/></one>'
    <?xml version="1.0" encoding="utf-16"?>
    <one>
        <two />
    </one>
    #>
    [CmdletBinding(DefaultParameterSetName = 'file')]
    param (
        [parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline, ParameterSetName = 'file', Position = 1)]
        [ValidateScript( { $_ | ForEach-Object { Test-Path $_ }})]
        [Alias('Fullname', 'Name')]
        [string[]]$FileName,

        [parameter(ParameterSetName = 'file')]
        [switch]$Overwrite,

        [parameter(ParameterSetName = 'xml')]
        [string]$Xml
    )

    process {
        foreach ($file in $FileName) {
            $file = Resolve-Path -Path $file
            Write-Verbose $file
            $x = [xml]([System.IO.File]::ReadAllText($file))
            $x.PreserveWhitespace = $true
            $settings = [System.Xml.XmlWriterSettings]::new()
            $settings.Indent = $true
            $settings.Encoding = [System.Text.UTF8Encoding]::new($false)

            if ($Overwrite) {
                $w = [System.Xml.XmlWriter]::Create($file, $settings)
                try {
                    $x.Save($w)
                }
                catch {
                    Write-Error $_
                }
                finally {
                    $w.Dispose()
                }
            }
            else {
                $w = [System.Xml.XmlWriter]::Create([console]::Out, $settings)
                $x.Save($w)
                $w.Dispose()
            }
        }

        if (!([string]::IsNullOrWhiteSpace($Xml))) {
            $document = [System.Xml.XmlDocument]::new()
            $stringReader = [System.IO.StringReader]::new($Xml)
            $document.Load($stringReader)
            $document.PreserveWhitespace = $true
            $builder = [System.Text.StringBuilder]::new()
            $stringWriter = [System.IO.StringWriter]::new($builder)
            $writer = [System.Xml.XmlTextWriter]::new($stringWriter)
            $writer.Formatting = [System.Xml.Formatting]::Indented
            $writer.Indentation = 2
            $document.Save($writer)
            $builder.ToString()
        }
    }
}
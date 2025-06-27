function Write-Response {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.Net.HttpListenerResponse]$response,
        [Parameter(Mandatory = $true)]
        [string]$message,
        [int]$statusCode = 200,
        [string]$contentType = "application/json"
    )
    $buffer = [System.Text.Encoding]::UTF8.GetBytes($message)
    $response.ContentType = $contentType
    $response.StatusCode = $statusCode
    $response.ContentLength64 = $buffer.Length
    $response.OutputStream.Write($buffer, 0, $buffer.Length)
    $response.OutputStream.Close()
}

class NumberTime {
    [int]$number
    [int]$time

    NumberTime([int]$number, [int]$time) {
        $this.number = $number
        $this.time = $time
    }

    [string]ToString() {
        return "Number: $($this.number), Time: $($this.time)"
    }

    [string]ToJson() {
        return @{ number = $this.number; time = $this.time } | ConvertTo-Json
    }
}
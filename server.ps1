. "$PSScriptRoot/server/utils.ps1"
. "$PSScriptRoot/server/utils-server.ps1"
. "$PSScriptRoot/server/converter.ps1"

Test-Machine $true

# Start HTTP Listener
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:8080/")
$listener.Start()
Write-Host "Server running at http://localhost:8080/"

# In-memory storage for POSTed data
$dataStore = @{number=0}



while ($listener.IsListening) {
    try {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response
        
        $response.AddHeader("Access-Control-Allow-Origin", "*")

        if ($request.RawUrl -eq "/stop_server") {
            Write-Response $response "Server is stopping..." 200
            break
        }

        if ($request.RawUrl -eq "/convert") {
            $converted = Convert-Files
            $message = @{ count =  $converted } | ConvertTo-Json
            Write-Response $response $message 200
            continue
        }

        # Handle /data endpoint
        if ($request.RawUrl -like "/data*") {

            # Add CORS headers to all responses on /data

            if ($request.HttpMethod -eq "GET") {
                # Return stored data as JSON
                $jsonResponse = $dataStore | ConvertTo-Json -Depth 5
                Write-Response $response $jsonResponse
            }
            elseif ($request.HttpMethod -eq "POST") {
                # Read the JSON body from the request
                $reader = New-Object System.IO.StreamReader($request.InputStream, $request.ContentEncoding)
                $jsonString = $reader.ReadToEnd()
                $reader.Close()

                # Convert JSON string to PowerShell object
                try {
                    $receivedData = $jsonString | ConvertFrom-Json
                }
                catch {
                    $errorMsg = @{ error = "Invalid JSON" } | ConvertTo-Json
                    Write-Response $response $errorMsg 400
                    continue
                }

                # Handle increment/decrement logic
                if ($receivedData.increment -eq $true) {
                    $dataStore.number += 1
                }
                elseif ($receivedData.decrement -eq $true) {
                    $dataStore.number -= 1
                }
                elseif ($null -ne $receivedData.number) {
                    # Directly set number if provided
                    $dataStore.number = $receivedData.number
                }
                else {
                    $errorMsg = @{ error = "Invalid data format" } | ConvertTo-Json
                    Write-Response $response $errorMsg 400
                    continue
                }

                # Respond with stored data
                $jsonResponse = $dataStore | ConvertTo-Json -Depth 5
                Write-Response $response $jsonResponse
            }
            else {
                # Method not allowed
                $response.StatusCode = 405
                $response.StatusDescription = "Method Not Allowed"
                $response.OutputStream.Close()
            }
        }
        else {
            # Endpoint not found
            $response.StatusCode = 404
            $response.StatusDescription = "Not Found"
            $response.OutputStream.Close()
        }
    }
    catch {
        Write-Host "Error: $_"
    }
}

Write-Host "Stopping server..."
$listener.Stop()
$listener.Close()
Write-Host "Server stopped."

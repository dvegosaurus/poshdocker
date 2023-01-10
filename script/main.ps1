# This is a super **SIMPLE** example of how to create a very basic powershell webserver
# 2019-05-18 UPDATE — Created by me and and evalued by @jakobii and the comunity.

# Http Server
$http = [System.Net.HttpListener]::new() 

# Hostname and port to listen on
$http.Prefixes.Add("http://*:9999/")

# Start the Http Server 
$http.Start()

# Log ready message to terminal 
if ($http.IsListening) {
    write-host " HTTP Server Ready!  " -f 'black' -b 'gre'
    write-host "now try going to $($http.Prefixes)" -f 'y'
    write-host "then try going to $($http.Prefixes)other/path" -f 'y'
}


# INFINTE LOOP
# Used to listen for requests
while ($http.IsListening) {
    $context = $http.GetContext()

     if ($context.Request.RawUrl -eq '/test') {
        
        #resposed to the request
        $buffer = [System.Text.Encoding]::UTF8.GetBytes("Hello World")
        $context.Response.ContentLength64 = $buffer.Length
        $context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
        $context.Response.OutputStream.Close() 
    }

    if ($context.Request.RawUrl -eq '/redirect') {
        
        $context.Response.RedirectLocation = "http://$($context.request.UserHostName)/api/password"
        $context.Response.StatusCode = 301
    
        $buffer = [System.Text.Encoding]::UTF8.GetBytes($context.Response)
        $context.Response.ContentLength64 = $buffer.Length
        $context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
        $context.Response.OutputStream.Close() 
    }

    if ($context.Request.RawUrl -eq '/test2') {
        
        #resposed to the request
        $buffer = [System.Text.Encoding]::UTF8.GetBytes("Hello World xxxxxxxxxxxxxxxx")
        $context.Response.ContentLength64 = $buffer.Length
        $context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
        $context.Response.OutputStream.Close() 
    }
 
    if ($context.Request.RawUrl -eq '/') {
        

        $html = '<h1>"YOOOOOOOOOOOOOOOOOOOOOOOOO"</h1>'
        #resposed to the request
        $buffer = [System.Text.Encoding]::UTF8.GetBytes($html)
        $context.Response.ContentLength64 = $buffer.Length
        $context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
        $context.Response.OutputStream.Close() 
    }

    if ($context.Request.RawUrl -eq '/process') {
        

        $html =  get-process | ConvertTo-json
        #resposed to the request
        $buffer = [System.Text.Encoding]::UTF8.GetBytes($html)
        $context.Response.ContentLength64 = $buffer.Length
        $context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
        $context.Response.OutputStream.Close() 
    }

    if ($context.Request.RawUrl -eq '/password') {
        

        $password =  & /build/pass.ps1

        $html = (get-content /build/templates/password.html) -replace 'aaapasswordaaa',$password
    
        #resposed to the request
        $buffer = [System.Text.Encoding]::UTF8.GetBytes($html)
        $context.Response.ContentLength64 = $buffer.Length
        $context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
        $context.Response.OutputStream.Close() 
    }


        if ($context.Request.RawUrl -eq '/api/password') {
        

        $html =  & /build/pass.ps1
        #resposed to the request
        $buffer = [System.Text.Encoding]::UTF8.GetBytes($html)
        $context.Response.ContentLength64 = $buffer.Length
        $context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
        $context.Response.OutputStream.Close() 
    }

    # http://127.0.0.1/some/post'
    if ($context.Request.HttpMethod -eq 'POST' -and $context.Request.RawUrl -eq '/query') {

        $FormContent = [System.IO.StreamReader]::new($context.Request.InputStream).ReadToEnd()
        
        $formdata = $FormContent | ConvertFrom-Json 
        
        $jsonresponse = new-item -Path $formdata.path -Name $formdata.name -ItemType File | select name,fullname,path | convertto-json 
        
        #resposed to the request
        $buffer = [System.Text.Encoding]::UTF8.GetBytes($jsonresponse)
        $context.Response.ContentLength64 = $buffer.Length
        $context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
        $context.Response.OutputStream.Close() 
    }

    if ($context.Request.RawUrl -eq '/video') {
        
        [string]$html = @'
        <!DOCTYPE html>
        <html><head>
        <meta name="viewport" content="width=device-width">
        </head>
        <body><video controls="" autoplay="" name="media">
        <source src="V:\youtube\brother.mp4" type="video/mp4">
        </video></body></html>
'@      
        #resposed to the request
        $buffer = [System.Text.Encoding]::UTF8.GetBytes($html)
        $context.Response.ContentLength64 = $buffer.Length
        $context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
        $context.Response.OutputStream.Close() 
    }

    if ($context.Request.RawUrl -eq '/toomanyredirects') {

        $context.Response.RedirectLocation = "http://localhost:8080/toomanyredirects"
        $context.Response.StatusCode = 301
    
        $buffer = [System.Text.Encoding]::UTF8.GetBytes("")
        $context.Response.ContentLength64 = $buffer.Length
        $context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
        $context.Response.OutputStream.Close() 
    }

    if ($context.Request.HttpMethod -eq 'GET' -and $context.Request.RawUrl -eq '/users') {

        $jsonresponse = Invoke-SqliteQuery -DataSource D:\Git\webserver\database\db.db -Query "SELECT * from user" | ConvertTo-Json

        $buffer = [System.Text.Encoding]::UTF8.GetBytes($jsonresponse)
        $context.Response.ContentLength64 = $buffer.Length
        $context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
        $context.Response.OutputStream.Close() 
    }
    
    if ($context.Request.HttpMethod -eq 'GET' -and $context.Request.RawUrl -eq '/docs') {
        
        $query = @'
        SELECT title,content,category.name FROM chapter
        INNER JOIN category on category.id = chapter.categories;
'@
        $jsonresponse = Invoke-SqliteQuery -DataSource D:\Git\webserver\database\db.db -Query $query | ConvertTo-Json


        $buffer = [System.Text.Encoding]::UTF8.GetBytes($jsonresponse)
        $context.Response.ContentLength64 = $buffer.Length
        $context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
        $context.Response.OutputStream.Close() 
    }

    if ($context.Request.RawUrl -eq '/stop') {
        $context.Response.KeepAlive = $false
        $http.Stop()
        $http.Close()
    }
    else {
        $html = (get-content /build/templates/404.html)
        $context.Response.StatusCode = 404

        $buffer = [System.Text.Encoding]::UTF8.GetBytes($html)
        $context.Response.ContentLength64 = $buffer.Length
        $context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
        $context.Response.OutputStream.Close() 
    
    }
} 






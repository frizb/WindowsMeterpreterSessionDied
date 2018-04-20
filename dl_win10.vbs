' using serverxmlhttp.6.0 bypasses the IE trusted website protection and does not generate an access denied message
dim xHttp: Set xHttp = createobject("MSXML2.ServerXMLHTTP.6.0")  
dim bStrm: Set bStrm = createobject("Adodb.Stream")  
xHttp.Open "GET", WScript.Arguments(0), False  
xHttp.Send 
bStrm.type = 1 
bStrm.open 
bStrm.write xHttp.responseBody 
bStrm.savetofile WScript.Arguments(1), 2 

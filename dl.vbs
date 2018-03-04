dim xHttp: Set xHttp = createobject("Microsoft.XMLHTTP")  
dim bStrm: Set bStrm = createobject("Adodb.Stream")  
xHttp.Open "GET", WScript.Arguments(0), False  
xHttp.Send 
bStrm.type = 1 
bStrm.open 
bStrm.write xHttp.responseBody 
bStrm.savetofile WScript.Arguments(1), 2 

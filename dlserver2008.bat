echo dim xHttp: Set xHttp = CreateObject("MSXML2.ServerXMLHTTP.6.0")  > dl.vbs
echo dim bStrm: Set bStrm = createobject("Adodb.Stream")  >> dl.vbs
echo xHttp.Open "GET", WScript.Arguments(0), False  >> dl.vbs
echo xHttp.Send >> dl.vbs
echo bStrm.type = 1 >> dl.vbs
echo bStrm.open >> dl.vbs
echo bStrm.write xHttp.responseBody >> dl.vbs
echo bStrm.savetofile WScript.Arguments(1), 2 >> dl.vbs

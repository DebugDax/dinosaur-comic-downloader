#include <inet.au3>
#include <string.au3>

$url = 'http://www.qwantz.com/index.php?comic='
Global $i = 1

DirCreate(@ScriptDir & "\comics")

While $i < 3000
	TraySetToolTip("Dinosaur Comics" & @CRLF & $i & "...")
	$source = _INetGetSource($url & $i, True)
	If StringInStr($source, "I BACK MY DATA UP.  Beats me, man.") Then
		ConsoleWrite("Skipping: " & $i & " - Latest")
		$i = $i + 1
	Else
		If StringInStr($source, 'class="comic"') Then
			$img = _StringBetween($source, 'valign="middle"><img src="', '"')
			If IsArray($img) Then
				$name = _StringBetween($img[0], "comics/", ".")
				If IsArray($name) Then
					$ext = StringRight($img[0], 4)
					$name[0] = StringReplace($name[0], "/", " ")
					$name[0] = StringReplace($name[0], "\", " ")
					$name[0] = StringReplace($name[0], "&", "")
					$name[0] = StringReplace($name[0], "*", "")
					$name[0] = StringReplace($name[0], "?", "")
					$name[0] = StringReplace($name[0], ")", "")
					$name[0] = StringReplace($name[0], "(", "")
					If Not FileExists(@ScriptDir & "\comics\" & $i & " " & $name[0] & $ext) Then
						ConsoleWrite($i & ": " & $name[0] & $ext & @CRLF)
						InetGet($img[0], @ScriptDir & "\comics\" & $i & " " & $name[0] & $ext, 3, 0)
					Else
						ConsoleWrite('Skipping: ' & $i & @CRLF)
					EndIf
				Else
					ConsoleWrite('Skipping: ' & $i & @CRLF)
				EndIf
			EndIf
		Else
			ConsoleWrite('Skipping: ' & $i & @CRLF)
		EndIf
	EndIf
	$i = $i + 1
	;sleep(Random(1000,2400,1))
WEnd

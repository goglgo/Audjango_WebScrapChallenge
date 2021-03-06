#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

FileRead, currentVersion, %A_ScriptDir%\version
latest_version := getCurrentVersion()
; Msgbox,% latest_version
version_array := []
version_array.push(currentVersion, latest_version)
Latest := VersionCompare(version_array[1], version_array[2])

version := ""

if version_array[Latest]
    version := version_array[Latest]
else
    version := latest_version

file := Fileopen("version", "w")
file.Write(version)
file.close()

setVersion(version)
; Msgbox,% version

return

setVersion(version)
{
    ; /goglgo/Audjango_WebScrapChallenge/releases/download/(.*)/manage.exe
    download_url := "https://github.com"
    download_url .= "/goglgo/Audjango_WebScrapChallenge/releases/download/"
    download_url .= version
    download_url .= "/manage.exe"

    download_file(download_url)
}

download_file(url)
{
    ; Msgbox,% url
    whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	whr.Open("GET", url, true)
	whr.Send()
	whr.WaitForResponse()

	; see https://autohotkey.com/boards/viewtopic.php?f=74&t=7190
	body := whr.ResponseBody
	data := NumGet(ComObjValue(body) + 8 + A_PtrSize, "UInt")
	size := body.MaxIndex() + 1

	if !InStr(FileExist(dir), "D")
		FileCreateDir % dir

	SplitPath url, urlFileName
	f := FileOpen(dir (fileName ? fileName : urlFileName), "w")
	f.RawWrite(data + 0, size)
	f.Close()
}

getCurrentVersion()
{
    url := "https://github.com/goglgo/Audjango_WebScrapChallenge/releases/"
    obj := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    obj.Open("GET", url)
    obj.Send()
    obj.WaitForResponse()
    response := obj.responseText
    ; response := StrReplace(response, "`r")
    ; response := StrReplace(response, "`n")
	needle := "(/goglgo/Audjango_WebScrapChallenge/releases/download/)(.*?)(?=/manage.exe)"
    ; needle := "/goglgo/Audjango_WebScrapChallenge/releases/download/(?<value>.*?)/manage.exe"
    ; ttt:= RegExMatch(response, needle, _)
	ttt:= RegExMatch(response, needle, result)
	; FileAppend, %response%, test.html
    return result2
}

VersionCompare(version1, version2)
{
	StringSplit, verA, version1, .
	StringSplit, verB, version2, .
	Loop, % (verA0> verB0 ? verA0 : verB0)
	{
		if (verA0 < A_Index)
			verA%A_Index% := "0"
		if (verB0 < A_Index)
			verB%A_Index% := "0"
		if (verA%A_Index% > verB%A_Index%)
			return 1
		if (verB%A_Index% > verA%A_Index%)
			return 2
	}
	return 0
}
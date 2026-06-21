Dim fso, src, dest, profileDest, parentFolder
Set fso = CreateObject("Scripting.FileSystemObject")

src = "C:\Users\Mihir Bhayani\.gemini\antigravity-ide\brain\b98a9e46-5617-40d1-bf06-46ea380ec22e\media__1782022496313.png"
dest = "d:\InternShip Project\VGB-Banking-System-Java\src\main\webapp\assest\images\logo.png"
profileDest = "d:\InternShip Project\VGB-Banking-System-Java\src\main\webapp\assest\images\profile-logo.png"

' Ensure the target folder exists
parentFolder = "d:\InternShip Project\VGB-Banking-System-Java\src\main\webapp\assest\images"
If Not fso.FolderExists(parentFolder) Then
    fso.CreateFolder(parentFolder)
End If

On Error Resume Next
fso.CopyFile src, dest, True
fso.CopyFile src, profileDest, True

If Err.Number <> 0 Then
    MsgBox "Error copying logo: " & Err.Description, vbCritical, "VGB Logo Updater"
Else
    MsgBox "Logo and profile images copied successfully!", vbInformation, "VGB Logo Updater"
End If

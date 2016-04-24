
[Setup]
AppId={{0E93C280-B9B0-470C-9E86-D12FBA5EC8BE}}
AppName={{PRODUCT}}
AppVerName={{PRODUCT}} {{VERSION}}
AppPublisher=
AppPublisherURL={{BUILDER_WEBSITE}}
AppSupportURL={{BUILDER_WEBSITE}}
AppUpdatesURL={{BUILDER_WEBSITE}}
DefaultDirName={pf}\{{PRODUCT}}
DefaultGroupName={{PRODUCT}}
DisableProgramGroupPage=yes
LicenseFile={{BASEDIR}}\GPL-2.0.txt
InfoAfterFile=info-post.txt
OutputDir={{DISTDIR}}
OutputBaseFilename={{PRODUCT}}Setup-{{VERSION}}
Compression=lzma
SolidCompression=yes
ArchitecturesInstallIn64BitMode=x64
ShowUndisplayableLanguages=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: fr; MessagesFile: "compiler:Languages\French.isl"
Name: de; MessagesFile: "compiler:Languages\German.isl"
Name: es; MessagesFile: "compiler:Languages\Spanish.isl"
Name: it; MessagesFile: "compiler:Languages\Italian.isl"
Name: "ptPT"; MessagesFile: "compiler:Languages\Portuguese.isl"
Name: "ptBR"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

[Files]
Source: "{{BUILDDIR}}\64\*"; DestDir: "{app}"; Flags: recursesubdirs createallsubdirs; Check: IsX64
Source: "{{BUILDDIR}}\32\*"; DestDir: "{app}"; Flags: recursesubdirs createallsubdirs; Check: IsOtherArch
Source: "{{BASEDIR}}\GPL-2.0.txt"; DestDir: "{app}"; 
Source: "{{BASEDIR}}\tmp\README.txt"; DestDir: "{app}"; Flags: isreadme


[Registry]
Root: HKLM32; Subkey: "Software\{{BUILDER}}\{{PRODUCT}}"; Flags: uninsdeletekey
Root: HKLM32; Subkey: "Software\{{BUILDER}}\{{PRODUCT}}"; ValueType: string; ValueName: "InstallFolder"; ValueData: "{app}"
Root: HKLM32; Subkey: "Software\{{BUILDER}}\{{PRODUCT}}"; ValueType: string; ValueName: "Version"; ValueData: "{{VERSION}}"
Root: HKLM32; Subkey: "Software\{{BUILDER}}\{{PRODUCT}}"; ValueType: string; ValueName: "Is32Bits"; ValueData: "yes"; Check: IsOtherArch
Root: HKLM32; Subkey: "Software\{{BUILDER}}\{{PRODUCT}}"; ValueType: string; ValueName: "Is32Bits"; ValueData: "no"; Check: IsX64


[Code]
function IsX64: Boolean;
begin
  Result := Is64BitInstallMode and (ProcessorArchitecture = paX64);
end;

function IsOtherArch: Boolean;
begin
  Result := not IsX64;
end;

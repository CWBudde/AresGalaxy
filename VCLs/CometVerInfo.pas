unit CometVerInfo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  VS_FIXEDFILEINFO = record
    dwSignature: Integer;
    dwStrucVersion: Integer;
    dwFileVersionMS: Integer;
    dwFileVersionLS: Integer;
    dwProductVersionMS: Integer;
    dwProductVersionLS: Integer;
    dwFileFlagsMask: Integer;
    dwFileFlags: Integer;
    dwFileOS: Integer;
    dwFileType: Integer;
    dwFileSubtype: Integer;
    dwFileDateMS: Integer;
    dwFileDateLS: Integer
  end;

  TCmtVerNfo = class(TComponent)
  private
    FAutoGetInfo: Boolean;
    FHaveVersionInfo: Boolean;
    FhZero: DWORD;
    FVersionInfoSize: Integer;
    FVersionInfoBuffer: PWidechar;
    FFilename: WideString;
    FParam: Pointer;
    FParameterLength: UINT;
    FLanguage: Integer;
    FCharSet: Integer;
    FLangChar: String[8];
    FLanguageStr: String[4];
    FCharSetStr: String[4];
    FFixedFileInfo: VS_FIXEDFILEINFO;
  protected
    function GetFileName: WideString;
    procedure SetFileName(Name: WideString);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    procedure GetFileInfo(FileName: WideString);
    procedure SetAutoGetInfo(Value: Boolean);

    property FileName: WideString read GetFileName write SetFileName;
    property AutoGetInfo: Boolean read FAutoGetInfo write SetAutoGetInfo default True;

    property HaveVersionInfo: Boolean read FHaveVersionInfo;
    property Language: Integer read FLanguage;
    property CharSet: Integer read FCharSet;
    property Signature: Integer read FFixedFileInfo.dwSignature;
    property StrucVersion: Integer read FFixedFileInfo.dwStrucVersion;
    property FileVersionMS: Integer read FFixedFileInfo.dwFileVersionMS;
    property FileVersionLS: Integer read FFixedFileInfo.dwFileVersionLS;
    property ProductVersionMS: Integer read FFixedFileInfo.dwProductVersionMS;
    property ProductVersionLS: Integer read FFixedFileInfo.dwProductVersionLS;
    property FileFlagsMask: Integer read FFixedFileInfo.dwFileFlagsMask;
    property FileFlags: Integer read FFixedFileInfo.dwFileFlags;
    property FileOS: Integer read FFixedFileInfo.dwFileOS;
    property FileType: Integer read FFixedFileInfo.dwFileType;
    property FileSubtype: Integer read FFixedFileInfo.dwFileSubtype;
    property FileDateMS: Integer read FFixedFileInfo.dwFileDateMS;
    property FileDateLS: Integer read FFixedFileInfo.dwFileDateLS;
    function GetValue(ValueName: String): WideString;
  end;

procedure Register;

implementation

constructor TCmtVerNfo.Create(AOwner: TComponent);
var
  Lung: Integer;
  buffer: array[0..MAX_PATH - 1] of WideChar;
  widstr: WideString;
begin
  inherited Create(AOwner);
  try
    FFilename := '';
    FAutoGetInfo := True;
    FLanguage := 0;
    FCharSet := 0;

    Lung := GetModuleFileNameW(0, Buffer, SizeOf(Buffer));

    if Lung = 0 then
      exit;

    SetLength(widstr, Lung);
    move(buffer, widstr[1], Lung * 2);

    SetFileName(widstr);
    GetFileInfo(FileName);
  except
  end;
end;

destructor TCmtVerNfo.Destroy;
begin
  inherited Destroy;
  try
    FFilename := '';
    if FVersionInfoBuffer <> nil then
      FreeMem(FVersionInfoBuffer);
  except
  end;
end;

function TCmtVerNfo.GetFileName: WideString;
begin
  Result := FFilename;
end;

procedure TCmtVerNfo.SetFileName(Name: WideString);
begin
  FFilename := name;
end;

procedure TCmtVerNfo.SetAutoGetInfo(Value: Boolean);
begin
  try
    if FAutoGetInfo <> Value then
    begin
      FAutoGetInfo := Value;
      if FAutoGetInfo then
        SetFileName(ParamStr(0));
      GetFileInfo(FFilename);
    end;
  except
  end;
end;

procedure TCmtVerNfo.GetFileInfo(FileName: WideString);
var
  Temp: Integer;
begin
  try
    FVersionInfoSize := GetFileVersionInfoSizeW(PWidechar(FFilename), FhZero);
    FHaveVersionInfo := (FVersionInfoSize <> 0);

    FVersionInfoBuffer := AllocMem(FVersionInfoSize);
    FHaveVersionInfo := GetFileVersionInfoW(PWidechar(FFilename), 0,
      FVersionInfoSize, FVersionInfoBuffer);

    if FHaveVersionInfo then
    begin
      VerQueryValueW(FVersionInfoBuffer, '\', FParam, FParameterLength);
      CopyMemory(@FFixedFileInfo, FParam, FParameterLength);
      VerQueryValueW(FVersionInfoBuffer, '\VarFileInfo\Translation', FParam,
        FParameterLength);
      Temp := Integer(FParam^);
      FLanguage := Temp and $FFFF;
      FCharSet := ((Temp and $FFFF0000) shr 16) and $FFFF;
      FLanguageStr := IntToHex(FLanguage, 4);
      FCharSetStr := IntToHex(FCharSet, 4);
      FLangChar := FLanguageStr + FCharSetStr;
    end;

  except
    FVersionInfoBuffer := nil;
  end;
end;

function TCmtVerNfo.GetValue(ValueName: String): WideString;
var
  Res: Boolean;
begin
  try
    if (Win32Platform = VER_PLATFORM_WIN32_NT) then
    begin
      Res := VerQueryValueW(FVersionInfoBuffer,
        PWidechar(WideString('\StringFileInfo\' + FLangChar + '\' + ValueName)),
        FParam, FParameterLength);
      if Res then
      begin
        SetLength(Result,FParameterLength-1);
        move(FParam^, Result[1], (FParameterLength - 1) * 2);
      end
      else
        Result := IntToStr(GetLastError);
    end
    else
    begin
      Res := VerQueryValue(FVersionInfoBuffer,
        PChar(string('\StringFileInfo\' + FLangChar + '\' + ValueName)),
        FParam, FParameterLength);
      if Res then
        Result := 'TODO' // TODO: StrPas(FParam)
      else
        Result := IntToStr(GetLastError);
    end;
  except
  end;
end;

procedure Register;
begin
  RegisterComponents('Comet', [TCmtVerNfo]);
end;

end.

{
 this file is part of Ares
 Aresgalaxy ( http://aresgalaxy.sourceforge.net )

  This program is free software; you can redistribute it and/or
  modify it under the terms of the GNU General Public License
  as published by the Free Software Foundation; either
  version 2 of the License, or (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 }

{$DEFINE ONCEWINSOCK}
{Note about define ONCEWINSOCK:
If you remove this compiler directive, then socket interface is loaded and
initialized on constructor of TBlockSocket class for each socket separately.
Socket interface is used only if your need it.

If you leave this directive here, then socket interface is loaded and
initialized only once at start of your program! It boost performace on high
count of created and destroyed sockets. It eliminate possible small resource
leak on Windows systems too.
}

//{$DEFINE RAISEEXCEPT}
{When you enable this define, then is Raiseexcept property is on by default
}

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}
{$IFDEF VER125}
  {$DEFINE BCB}
{$ENDIF}
{$IFDEF BCB}
  {$ObjExportAll On}
{$ENDIF}
{$Q-}
{$H+}

unit blcksock;

interface

uses
  SysUtils, Classes,
{$IFDEF LINUX}
  {$IFDEF FPC}
  synafpc,
  {$ENDIF}
  Libc,
{$ELSE}
  Windows,
{$ENDIF}
  synsock, classes2;

const
  TIMOUT_SOCKET_CONNECTION=15000;
  TIMOUT_SOCKET_CONNECTION_CLIENT=15000;
  SynapseRelease = '32';
  cLocalhost = '127.0.0.1';
  cAnyHost = '0.0.0.0';
  cBroadcast = '255.255.255.255';
  c6Localhost = '::1';
  c6AnyHost = '::0';
  c6Broadcast = 'ffff::1';
  cAnyPort = '0';
  CR = chr(13); //#$0d;
  LF = chr(10); //#$0a;
  CRLF = CR + LF;
  c64k = 65536;

type
HSocket = TSocket;

type

  ESynapseError = class(Exception)
  private
    FErrorCode: Integer;
    FErrorMessage: string;
  published
    property ErrorCode: Integer read FErrorCode Write FErrorCode;
    property ErrorMessage: string read FErrorMessage Write FErrorMessage;
  end;

  THookSocketReason = (
    HR_ResolvingBegin,
    HR_ResolvingEnd,
    HR_SocketCreate,
    HR_SocketClose,
    HR_Bind,
    HR_Connect,
    HR_CanRead,
    HR_CanWrite,
    HR_Listen,
    HR_Accept,
    HR_ReadCount,
    HR_WriteCount,
    HR_Wait,
    HR_Error
    );

  THookSocketStatus = procedure(Sender: TObject; Reason: THookSocketReason;
    const Value: string) of object;

  THookDataFilter = procedure(Sender: TObject; var Value: string) of object;

  THookCreateSocket = procedure(Sender: TObject) of object;

  TSocketFamily = (
    SF_Any,
    SF_IP4,
    SF_IP6
    );

  TSocksType = (
    ST_Socks5,
    ST_Socks4
    );

  TSSLType = (
    LT_SSLv2,
    LT_SSLv3,
    LT_TLSv1,
    LT_all
    );

  TStatoConnProxy = (
  PROXY_InConnessione,
  PROXY_INFlush_AuthorizeType,
  PROXY_INRicezioneAuthorizeType,
  PROXY_INFlush2_Authorization,
  PROXY_INRicezione_ReplyAuthorization,
  PROXY_INFlush_SendingHost,
  PROXY_INRicezione_EsitoConnessione
  );

  TSynaOptionType = (
    SOT_Linger,
    SOT_RecvBuff,
    SOT_SendBuff,
    SOT_NonBlock,
    SOT_RecvTimeout,
    SOT_SendTimeout,
    SOT_Reuse,
    SOT_TTL,
    SOT_Broadcast,
    SOT_MulticastTTL,
    SOT_MulticastLoop
    );

  TSynaOption = record
    Option: TSynaOptionType;
    Enabled: Boolean;
    Value: Integer;
  end;
  PSynaOption = ^TSynaOption;

  TBlockSocket = class(TObject)
  private
    FOnStatus: THookSocketStatus;
    FOnReadFilter: THookDataFilter;
    FOnWriteFilter: THookDataFilter;
    FOnCreateSocket: THookCreateSocket;
    FWsaData: TWSADATA;
    FLocalSin: TVarSin;
    FRemoteSin: TVarSin;
    FBuffer: string;
    FRaiseExcept: Boolean;
    FNonBlockMode: Boolean;
    FMaxLineLength: Integer;
    FMaxSendBandwidth: Integer;
    FNextSend: ULong;
    FMaxRecvBandwidth: Integer;
    FNextRecv: ULong;
    FConvertLineEnd: Boolean;
    FLastCR: Boolean;
    FLastLF: Boolean;
    FBinded: Boolean;
    FFamily: TSocketFamily;
    FFamilySave: TSocketFamily;
    FIP6used: Boolean;
    FPreferIP4: Boolean;
    FDelayedOptions: TList;
    FInterPacketTimeout: Boolean;
    FFDSet: TFDSet;
    FRecvCounter: Integer;
    FSendCounter: Integer;
    function GetSizeRecvBuffer: Integer;
    procedure SetSizeRecvBuffer(Size: Integer);
    function GetSizeSendBuffer: Integer;
    procedure SetSizeSendBuffer(Size: Integer);
    procedure SetNonBlockMode(Value: Boolean);
    procedure SetTTL(TTL: integer);
    function GetTTL: Integer;
    function IsNewApi: Boolean;
    procedure SetFamily(Value: TSocketFamily); virtual;
    procedure SetSocket(Value: TSocket); virtual;
  protected
    FSocket: TSocket;
    FLastError: Integer;
    FLastErrorDesc: string;
    procedure SetDelayedOption(Value: TSynaOption);
    procedure DelayedOption(Value: TSynaOption);
    procedure ProcessDelayedOptions;
    procedure InternalCreateSocket(Sin: TVarSin);
    procedure SetSin(var Sin: TVarSin; IP, Port: string);
    function GetSinIP(Sin: TVarSin): string;
    function GetSinPort(Sin: TVarSin): Integer;
    procedure DoStatus(Reason: THookSocketReason; const Value: string);
    procedure DoReadFilter(Buffer: Pointer; var Length: Integer);
    procedure DoWriteFilter(Buffer: Pointer; var Length: Integer);
    procedure DoCreateSocket;
    procedure LimitBandwidth(Length: Integer; MaxB: integer; var Next: ULong);
    procedure SetBandwidth(Value: Integer);
  public
    constructor Create;
    constructor CreateAlternate(Stub: string);
    procedure block(blocking:boolean);
    destructor Destroy; override;
    procedure CreateSocket;
    procedure CreateSocketByName(const Value: String);
    procedure CloseSocket; virtual;
    procedure AbortSocket;
    procedure Bind(IP, Port: string);
    procedure Connect(IP, Port: string); virtual;
    function SendBuffer(Buffer: Pointer; Length: Integer): Integer; virtual;
    procedure SendByte(Data: Byte); virtual;
    procedure SendString(const Data: string); virtual;
    procedure SendBlock(const Data: string); virtual;
    procedure SendStream(const Stream: TStream); virtual;
    function RecvBuffer(Buffer: Pointer; Length: Integer): Integer; virtual;
    function RecvBufferEx(Buffer: Pointer; Length: Integer; Timeout: Integer): Integer; virtual;
    function RecvBufferStr(Length: Integer; Timeout: Integer): String; virtual;
    function RecvByte(Timeout: Integer): Byte; virtual;
    function RecvString(Timeout: Integer): string; virtual;
    function RecvTerminated(Timeout: Integer; const Terminator: string): string; virtual;
    function RecvPacket(Timeout: Integer): string; virtual;
    function RecvBlock(Timeout: Integer): string; virtual;
    procedure RecvStream(const Stream: TStream; Timeout: Integer); virtual;
    function PeekBuffer(Buffer: Pointer; Length: Integer): Integer; virtual;
    function PeekByte(Timeout: Integer): Byte; virtual;
    function WaitingData: Integer; virtual;
    function WaitingDataEx: Integer;
    procedure Purge;
    procedure SetLinger(Enable: Boolean; Linger: Integer);
    procedure GetSinLocal;
    procedure GetSinRemote;
    procedure GetSins;
    function SockCheck(SockResult: Integer): Integer;
    procedure ExceptCheck;
    function LocalName: string;
    procedure ResolveNameToIP(Name: string; IPList: TStrings);
    function ResolveName(Name: string): string;
    function ResolveIPToName(IP: string): string;
    function ResolvePort(Port: string): Word;
    procedure SetRemoteSin(IP, Port: string);
    procedure SetLocalSin(IP, Port: string);
    function GetLocalSinIP: string; virtual;
    function GetRemoteSinIP: string; virtual;
    function GetLocalSinPort: Integer; virtual;
    function GetRemoteSinPort: Integer; virtual;
    function CanRead(Timeout: Integer): Boolean;
    function CanReadEx(Timeout: Integer): Boolean;
    function CanWrite(Timeout: Integer): Boolean;
    function SendBufferTo(Buffer: Pointer; Length: Integer): Integer; virtual;
    function RecvBufferFrom(Buffer: Pointer; Length: Integer): Integer; virtual;
    function GroupCanRead(const SocketList: TList; Timeout: Integer; const CanReadList: TList): Boolean;
    procedure EnableReuse(Value: Boolean);
    procedure SetTimeout(Timeout: Integer);
    procedure SetSendTimeout(Timeout: Integer);
    procedure SetRecvTimeout(Timeout: Integer);

    function StrToIP6(const value: string): TSockAddrIn6;
    function IP6ToStr(const value: TSockAddrIn6): string;

    function GetSocketType: integer; Virtual;
    function GetSocketProtocol: integer; Virtual;

    property WSAData: TWSADATA read FWsaData;
    property LocalSin: TVarSin read FLocalSin write FLocalSin;
    property RemoteSin: TVarSin read FRemoteSin write FRemoteSin;
  published
    property Socket: TSocket read FSocket write SetSocket;
    property LastError: Integer read FLastError;
    property LastErrorDesc: string read FLastErrorDesc;
    property LineBuffer: string read FBuffer write FBuffer;
    property RaiseExcept: Boolean read FRaiseExcept write FRaiseExcept;
    property SizeRecvBuffer: Integer read GetSizeRecvBuffer write SetSizeRecvBuffer;
    property SizeSendBuffer: Integer read GetSizeSendBuffer write SetSizeSendBuffer;
    property NonBlockMode: Boolean read FNonBlockMode Write SetNonBlockMode;
    property MaxLineLength: Integer read FMaxLineLength Write FMaxLineLength;
    property MaxSendBandwidth: Integer read FMaxSendBandwidth Write FMaxSendBandwidth;
    property MaxRecvBandwidth: Integer read FMaxRecvBandwidth Write FMaxRecvBandwidth;
    property MaxBandwidth: Integer Write SetBandwidth;
    property ConvertLineEnd: Boolean read FConvertLineEnd Write FConvertLineEnd;
    property TTL: Integer read GetTTL Write SetTTL;
    property Family: TSocketFamily read FFamily Write SetFamily;
    property PreferIP4: Boolean read FPreferIP4 Write FPreferIP4;
    property IP6used: Boolean read FIP6used;
    property InterPacketTimeout: Boolean read FInterPacketTimeout Write FInterPacketTimeout;
    property RecvCounter: Integer read FRecvCounter;
    property SendCounter: Integer read FSendCounter;
    property OnStatus: THookSocketStatus read FOnStatus write FOnStatus;
    property OnReadFilter: THookDataFilter read FOnReadFilter write FOnReadFilter;
    property OnWriteFilter: THookDataFilter read FOnWriteFilter write FOnWriteFilter;
    property OnCreateSocket: THookCreateSocket read FOnCreateSocket write FOnCreateSocket;
  end;

  TSocksBlockSocket = class(TBlockSocket)
  protected
    FSocksIP: string;
    FSocksPort: string;
    FSocksTimeout: integer;
    FSocksUsername: string;
    FSocksPassword: string;
    FUsingSocks: Boolean;
    FSocksResolver: Boolean;
    FSocksLastError: integer;
    FSocksResponseIP: string;
    FSocksResponsePort: string;
    FSocksLocalIP: string;
    FSocksLocalPort: string;
    FSocksRemoteIP: string;
    FSocksRemotePort: string;
    FBypassFlag: Boolean;



    function SocksCode(IP, Port: string): string;
    function SocksDecode(Value: string): integer;
  public
    FStatoConn: TStatoConnProxy;
    FSocksType: TSocksType;
    FLastTime: Cardinal;
    constructor Create;
    function SocksOpen: Boolean;
    function SocksRequest(Cmd: Byte; const IP, Port: string): Boolean;
    function SocksResponse: Boolean;
  published

    property SocksIP: string read FSocksIP write FSocksIP;
    property SocksPort: string read FSocksPort write FSocksPort;
    property SocksUsername: string read FSocksUsername write FSocksUsername;
    property SocksPassword: string read FSocksPassword write FSocksPassword;
    property SocksTimeout: integer read FSocksTimeout write FSocksTimeout;
    property UsingSocks: Boolean read FUsingSocks;
    property SocksResolver: Boolean read FSocksResolver write FSocksResolver;
    property SocksLastError: integer read FSocksLastError;
    property SocksType: TSocksType read FSocksType write FSocksType;
  end;

  TTCPBlockSocket = class(TSocksBlockSocket)
  protected
    procedure SocksDoConnect(IP, Port: string);
  public
    buffstr: string;
    ip: string;
    port: Word;
    tag: Cardinal;
    constructor Create(createsock:boolean);
    destructor Destroy; override;
    procedure CloseSocket; override;
    function WaitingData: Integer; override;
    procedure Listen(BackLog:integer = 5{SOMAXCONN}); virtual;
    function Accept: TSocket;
    procedure Connect(IP, Port: string); override;
    function GetLocalSinIP: string; override;
    function GetRemoteSinIP: string; override;
    function GetLocalSinPort: Integer; override;
    function GetRemoteSinPort: Integer; override;
    function SendBuffer(Buffer: Pointer; Length: Integer): Integer; override;
    function RecvBuffer(Buffer: Pointer; Length: Integer): Integer; override;
    function GetSocketType: integer; override;
    function GetSocketProtocol: integer; override;
  end;

  TIPHeader = record
    VerLen: Byte;
    TOS: Byte;
    TotalLen: Word;
    Identifer: Word;
    FragOffsets: Word;
    TTL: Byte;
    Protocol: Byte;
    CheckSum: Word;
    SourceIp: DWORD;
    DestIp: DWORD;
    Options: DWORD;
  end;

  TSynaClient = Class(TObject)
  protected
    FTargetHost: string;
    FTargetPort: string;
    FIPInterface: string;
    FTimeout: integer;
  public
    constructor Create;
  published
    property TargetHost: string read FTargetHost Write FTargetHost;
    property TargetPort: string read FTargetPort Write FTargetPort;
    property IPInterface: string read FIPInterface Write FIPInterface;
    property Timeout: integer read FTimeout Write FTimeout;
  end;

procedure ResolveNameToIP(Name: string;IPlist: TMyStringList);
procedure SetSin (var sin: TSockAddrIn;ip,port: string; protocol:integer);
function TCPSocket_ISConnected(socket: TTCPBlockSocket): Integer;

function  TCPSocket_Create: HSocket;
procedure TCPSocket_Free(var socket: HSocket);
function  TCPSocket_Connect(socket: HSocket; ip,port: string; var last_error: Integer): Integer;
procedure TCPSocket_Block(socket: HSocket; doblock: Boolean);
function  TCPSocket_GetSocketError(socket: HSocket): Integer;
function  TCPSocket_SendString(socket: HSocket; data: String; var last_error: Integer): integer;
function  TCPSocket_SendBuffer(socket: HSocket; buffer: Pointer;length: Integer; var last_error: Integer): Integer;
function  TCPSocket_RecvBuffer(socket: HSocket; buffer: Pointer;length: Integer; var last_error: Integer): Integer;
function  TCPSocket_CanRead(socket: HSocket; Timeout: Integer; var last_error: Integer): Boolean;
function  TCPSocket_CanWrite(socket: HSocket; Timeout: Integer; var last_error: Integer): Boolean;
procedure TCPSocket_Bind(socket: HSocket; ip,port: string);
function  TCPSocket_Listen(socket: HSocket): Integer;
procedure TCPSocket_SetSizeRecvBuffer(socket: HSocket; size:integer);
procedure TCPSocket_SetSizeSendBuffer(socket: HSocket; size:integer);
procedure TCPSocket_KeepAlive(socket: HSocket; b: Boolean);
function  TCPSocket_GetRemoteSin(socket: HSocket): TSockAddrIn;
function  TCPSocket_GetLocalSin(socket: HSocket): TSockAddrIn;
function  TCPSocket_Accept(socket: integer): integer;
function  TCPSocket_SockCheck(SockResult:integer): Integer;
function TCPSocket_GetRemotePort(socket: HSocket): word;

var
  WsaDataOnce : TWSADATA;
  sockets_count: Integer;
  e: ESynapseError;
  count_blocksock,
  count_blocksock_max: Integer;


implementation



constructor TBlockSocket.Create;
begin
  CreateAlternate('');
end;

constructor TBlockSocket.CreateAlternate(Stub: string);
{$IFNDEF ONCEWINSOCK}
var
  e: ESynapseError;
{$ENDIF}
begin
  inherited Create;
  FDelayedOptions := TList.Create;
  FRaiseExcept := False;
{$IFDEF RAISEEXCEPT}
  FRaiseExcept := True;
{$ENDIF}
  FSocket := INVALID_SOCKET;
  FBuffer := '';
  FLastCR := False;
  FLastLF := False;
  FBinded := False;
  FNonBlockMode := True;
  FMaxLineLength := 0;
  FMaxSendBandwidth := 0;
  FNextSend := 0;
  FMaxRecvBandwidth := 0;
  FNextRecv := 0;
  FConvertLineEnd := False;
  FFamily := SF_Any;
  FFamilySave := SF_Any;
  FIP6used := False;
  FPreferIP4 := True;
  FInterPacketTimeout := True;
  FRecvCounter := 0;
  FSendCounter := 0;
//{$IFDEF ONCEWINSOCK}
  FWsaData := WsaDataOnce;
//{$ELSE}
//  if Stub = '' then
//    Stub := DLLStackName;
//  if not InitSocketInterface(Stub) then
//  begin
//    e := ESynapseError.Create('Error loading Socket interface (' + Stub + ')!');
//    e.ErrorCode := 0;
//    e.ErrorMessage := 'Error loading Socket interface (' + Stub + ')!';
//    raise e;
//  end;
//  SockCheck(synsock.WSAStartup(WinsockLevel, FWsaData));
//  ExceptCheck;
//{$ENDIF}
end;

destructor TBlockSocket.Destroy;
var
  n: integer;
  p: PSynaOption;
begin
  CloseSocket;
//{$IFNDEF ONCEWINSOCK}
//  synsock.WSACleanup;
//  DestroySocketInterface;
//{$ENDIF}
  for n := FDelayedOptions.Count - 1 downto 0 do
    begin
      p := PSynaOption(FDelayedOptions[n]);
      Dispose(p);
    end;
  FDelayedOptions.Free;
  inherited Destroy;
end;

function TBlockSocket.IsNewApi: Boolean;
begin
  Result := SockEnhancedApi;
  if not Result then
    Result := (FFamily = SF_ip6) and SockWship6Api;
end;

procedure TBlockSocket.SetDelayedOption(Value: TSynaOption);
var
  li: TLinger;
  x: integer;
begin
  case value.Option of
    SOT_Linger:
      begin
        li.l_onoff := Ord(Value.Enabled);
        li.l_linger := Value.Value div 1000;
        synsock.SetSockOpt(FSocket, SOL_SOCKET, SO_LINGER, @li, SizeOf(li));
      end;
    SOT_RecvBuff:
      begin
        synsock.SetSockOpt(FSocket, SOL_SOCKET, SO_RCVBUF,
          @Value.Value, SizeOf(Value.Value));
      end;
    SOT_SendBuff:
      begin
        synsock.SetSockOpt(FSocket, SOL_SOCKET, SO_SNDBUF,
          @Value.Value, SizeOf(Value.Value));
      end;
    SOT_NonBlock:
      begin
        FNonBlockMode := Value.Enabled;
        x := Ord(FNonBlockMode);
        synsock.IoctlSocket(FSocket, FIONBIO, u_long(x));
      end;
    SOT_RecvTimeout:
      begin
        synsock.SetSockOpt(FSocket, SOL_SOCKET, SO_RCVTIMEO,
          @Value.Value, SizeOf(Value.Value));
      end;
    SOT_SendTimeout:
      begin
        synsock.SetSockOpt(FSocket, SOL_SOCKET, SO_SNDTIMEO,
          @Value.Value, SizeOf(Value.Value));
      end;
    SOT_Reuse:
      begin
        x := Ord(Value.Enabled);
        synsock.SetSockOpt(FSocket, SOL_SOCKET, SO_REUSEADDR, @x, SizeOf(x));
        //synsock.SetSockOpt(FSocket, SOL_SOCKET, SO_REUSEPORT, @x, SizeOf(x));
      end;
    SOT_TTL:
      begin
        if FIP6Used then
          synsock.SetSockOpt(FSocket, IPPROTO_IPV6, IPV6_UNICAST_HOPS,
            @Value.Value, SizeOf(Value.Value))
        else
          synsock.SetSockOpt(FSocket, IPPROTO_IP, IP_TTL,
            @Value.Value, SizeOf(Value.Value));
      end;
    SOT_Broadcast:
      begin
//#todo1 broadcasty na IP6
        x := Ord(Value.Enabled);
        synsock.SetSockOpt(FSocket, SOL_SOCKET, SO_BROADCAST, @x, SizeOf(x));
      end;
    SOT_MulticastTTL:
      begin
        if FIP6Used then
          synsock.SetSockOpt(FSocket, IPPROTO_IPV6, IPV6_MULTICAST_HOPS,
            @Value.Value, SizeOf(Value.Value))
        else
          synsock.SetSockOpt(FSocket, IPPROTO_IP, IP_MULTICAST_TTL,
            @Value.Value, SizeOf(Value.Value));
      end;
    SOT_MulticastLoop:
      begin
        x := Ord(Value.Enabled);
        if FIP6Used then
          synsock.SetSockOpt(FSocket, IPPROTO_IPV6, IPV6_MULTICAST_LOOP, @x, SizeOf(x))
        else
          synsock.SetSockOpt(FSocket, IPPROTO_IP, IP_MULTICAST_LOOP, @x, SizeOf(x));
      end;
  end;
end;

procedure TBlockSocket.DelayedOption(Value: TSynaOption);
var
  d: PSynaOption;
begin
  if FSocket = INVALID_SOCKET then begin
    new(d);
    d^ := Value;
    FDelayedOptions.Insert(0, d);
  end else SetDelayedOption(Value);
end;

procedure TBlockSocket.ProcessDelayedOptions;
var
  n: integer;
  d: PSynaOption;
begin
  for n := FDelayedOptions.Count - 1 downto 0 do begin
    d := FDelayedOptions[n];
    SetDelayedOption(d^);
    Dispose(d);
  end;
  FDelayedOptions.Clear;
end;

function SeparateLeft(const Value, Delimiter: string): string;
var
  x: Integer;
begin
  x := Pos(Delimiter, Value);
  if x < 1 then
    Result := Trim(Value)
  else
    Result := Trim(Copy(Value, 1, x - 1));
end;

function SeparateRight(const Value, Delimiter: string): string;
var
  x: Integer;
begin
  x := Pos(Delimiter, Value);
  if x > 0 then
    x := x + Length(Delimiter) - 1;
  Result := Trim(Copy(Value, x + 1, Length(Value) - x));
end;

function Fetch(var Value: string; const Delimiter: string): string;
var
  s: string;
begin
  Result := SeparateLeft(Value, Delimiter);
  s := SeparateRight(Value, Delimiter);
  if s = Value then
    Value := ''
  else
    Value := Trim(s);
  Result := Trim(Result);
end;

function IsIP(const Value: string): Boolean;
var
  TempIP: string;
  function ByteIsOk(const Value: string): Boolean;
  var
    x, n: integer;
  begin
    x := StrToIntDef(Value, -1);
    Result := (x >= 0) and (x < 256);
    // X may be in correct range, but value still may not be correct value!
    // i.e. "$80"
    if Result then
      for n := 1 to length(Value) do
        if not (Value[n] in ['0'..'9']) then
        begin
          Result := False;
          Break;
        end;
  end;
begin
  TempIP := Value;
  Result := False;
  if not ByteIsOk(Fetch(TempIP, chr(46){'.'})) then
    Exit;
  if not ByteIsOk(Fetch(TempIP, chr(46){'.'})) then
    Exit;
  if not ByteIsOk(Fetch(TempIP, chr(46){'.'})) then
    Exit;
  if ByteIsOk(TempIP) then
    Result := True;
end;

{==============================================================================}

function IsIP6(const Value: string): Boolean;
var
  TempIP: string;
  s,t: string;
  x: integer;
  partcount: integer;
  zerocount: integer;
  First: Boolean;
begin
  TempIP := Value;
  Result := False;
  partcount := 0;
  zerocount := 0;
  First := True;
  while tempIP <> '' do
  begin
    s := fetch(TempIP, chr(58){':'});
    if not(First) and (s = '') then
      Inc(zerocount);
    First := False;
    if zerocount > 1 then
      break;
    Inc(partCount);
    if s = '' then
      Continue;
    if partCount > 8 then
      break;
    if tempIP = '' then
    begin
      t := SeparateRight(s, chr(37){'%'});
      s := SeparateLeft(s, chr(37){'%'});
      x := StrToIntDef('$' + t, -1);
      if (x < 0) or (x > $ffff) then
        break;
    end;
    x := StrToIntDef('$' + s, -1);
    if (x < 0) or (x > $ffff) then
      break;
    if tempIP = '' then
      Result := True;
  end;
end;

procedure TBlockSocket.SetSin(var Sin: TVarSin; IP, Port: string);
type
  pu_long = ^u_long;
var
  ProtoEnt: PProtoEnt;
  ServEnt: PServEnt;
  HostEnt: PHostEnt;
  Hints: TAddrInfo;
  Addr: PAddrInfo;
  AddrNext: PAddrInfo;
  r: integer;
  Sin4, Sin6: TVarSin;
begin
  DoStatus(HR_ResolvingBegin, IP + chr(58){':'} + Port);
  FillChar(Sin, Sizeof(Sin), 0);
  //for prelimitary IP6 support try fake Family by given IP
  if SockWship6Api and (FFamily = SF_Any) then
  begin
    if IsIP(IP) then
      FFamily := SF_IP4
    else
      if IsIP6(IP) then
        FFamily := SF_IP6
      else
        if FPreferIP4 then
          FFamily := SF_IP4
        else
          FFamily := SF_IP6;
  end;
  if not IsNewApi then
  begin
    SynSockCS.Enter;
    try
      Sin.sin_family := AF_INET;
      ProtoEnt := synsock.GetProtoByNumber(GetSocketProtocol);
      ServEnt := nil;
      if ProtoEnt <> nil then
        ServEnt := synsock.GetServByName(PChar(Port), ProtoEnt^.p_name);
      if ServEnt = nil then
        Sin.sin_port := synsock.htons(StrToIntDef(Port, 0))
      else
        Sin.sin_port := ServEnt^.s_port;
      if IP = cBroadcast then
        Sin.sin_addr.s_addr := u_long(INADDR_BROADCAST)
      else
      begin
        Sin.sin_addr.s_addr := synsock.inet_addr(PChar(IP));
        if Sin.sin_addr.s_addr = u_long(INADDR_NONE) then
        begin
          HostEnt := synsock.GetHostByName(PChar(IP));
          if HostEnt <> nil then
            Sin.sin_addr.S_addr := u_long(Pu_long(HostEnt^.h_addr_list^)^);
        end;
      end;
    finally
      SynSockCS.Leave;
    end;
  end
  else
  begin
    Addr := nil;
    try
      FillChar(Sin4, Sizeof(Sin4), 0);
      FillChar(Sin6, Sizeof(Sin6), 0);
      FillChar(Hints, Sizeof(Hints), 0);
      //if socket exists, then use their type, else use users selection
      if FSocket = INVALID_SOCKET then
        case FFamily of
          SF_Any: Hints.ai_family := AF_UNSPEC;
          SF_IP4: Hints.ai_family := AF_INET;
          SF_IP6: Hints.ai_family := AF_INET6;
        end
      else
        if FIP6Used then
          Hints.ai_family := AF_INET6
        else
          Hints.ai_family := AF_INET;
      Hints.ai_socktype := GetSocketType;
      Hints.ai_protocol := GetSocketprotocol;
      if Hints.ai_socktype = SOCK_RAW then
      begin
        Hints.ai_socktype := 0;
        Hints.ai_protocol := 0;
        r := synsock.GetAddrInfo(PChar(IP), nil, @Hints, Addr);
      end
      else
      begin
        if IP = cAnyHost then
        begin
          Hints.ai_flags := AI_PASSIVE;
          r := synsock.GetAddrInfo(nil, PChar(Port), @Hints, Addr);
        end
        else
          if IP = cLocalhost then
          begin
            r := synsock.GetAddrInfo(nil, PChar(Port), @Hints, Addr);
          end
          else
          begin
            r := synsock.GetAddrInfo(PChar(IP), PChar(Port), @Hints, Addr);
          end;
      end;
      if r = 0 then
      begin
        AddrNext := Addr;
        while not (AddrNext = nil) do
        begin
          if not(Sin4.sin_family = AF_INET) and (AddrNext^.ai_family = AF_INET) then
            Move(AddrNext^.ai_addr^, Sin4, AddrNext^.ai_addrlen);
          if not(Sin6.sin_family = AF_INET6) and (AddrNext^.ai_family = AF_INET6) then
            Move(AddrNext^.ai_addr^, Sin6, AddrNext^.ai_addrlen);
          AddrNext := AddrNext^.ai_next;
        end;
        if (Sin4.sin_family = AF_INET) and (Sin6.sin_family = AF_INET6) then
        begin
          if FPreferIP4 then
            Sin := Sin4
          else
            Sin := Sin6;
        end
        else
        begin
          sin := sin4;
          if (Sin6.sin_family = AF_INET6) then
            sin := sin6;
        end;
      end;
    finally
      if Assigned(Addr) then
        synsock.FreeAddrInfo(Addr);
    end;
  end;
  DoStatus(HR_ResolvingEnd, IP + chr(58){':'} + Port);
end;

function TBlockSocket.GetSinIP(Sin: TVarSin): string;
var
  p: PChar;
  host, serv: string;
  hostlen, servlen: integer;
  r: integer;
begin
  Result := '';
  if not IsNewApi then
  begin
    p := synsock.inet_ntoa(Sin.sin_addr);
    if p <> nil then
      Result := p;
  end
  else
  begin
    hostlen := NI_MAXHOST;
    servlen := NI_MAXSERV;
    SetLength(host, hostlen);
    SetLength(serv, servlen);
    r := getnameinfo(@sin, SizeOfVarSin(sin), PChar(host), hostlen,
      PChar(serv), servlen, NI_NUMERICHOST + NI_NUMERICSERV);
    if r = 0 then
      Result := PChar(host);
  end;
end;

function TBlockSocket.GetSinPort(Sin: TVarSin): Integer;
begin
  if (Sin.sin_family = AF_INET6) then
    Result := synsock.ntohs(Sin.sin6_port)
  else
    Result := synsock.ntohs(Sin.sin_port);
end;

procedure TBlockSocket.CreateSocket;
var
  sin: TVarSin;
begin
  //dummy for SF_Any Family mode
  FLastError := 0;
  if (FFamily <> SF_Any) and (FSocket = INVALID_SOCKET) then begin
    FillChar(Sin, Sizeof(Sin), 0);
    if FFamily = SF_IP6 then sin.sin_family := AF_INET6
    else sin.sin_family := AF_INET;
    InternalCreateSocket(Sin);
  end;
end;

procedure TBlockSocket.CreateSocketByName(const Value: String);
var
  sin: TVarSin;
begin
  FLastError := 0;
  if FSocket = INVALID_SOCKET then
  begin
    SetSin(sin, value, chr(48){'0'});
    InternalCreateSocket(Sin);
  end;
end;

procedure TBlockSocket.InternalCreateSocket(Sin: TVarSin);
begin
  FRecvCounter := 0;
  FSendCounter := 0;
  FLastError := 0;
  if FSocket = INVALID_SOCKET then begin
    FBuffer := '';
    FBinded := False;
    FIP6Used := Sin.sin_family = AF_INET6;
    FSocket := synsock.Socket(Sin.sin_family, GetSocketType, GetSocketProtocol);
    if FSocket = INVALID_SOCKET then FLastError := synsock.WSAGetLastError;
    FD_ZERO(FFDSet);
    FD_SET(FSocket, FFDSet);
    ExceptCheck;
    if FIP6used then DoStatus(HR_SocketCreate, 'IPv6')
     else DoStatus(HR_SocketCreate, 'IPv4');
    ProcessDelayedOptions;
    DoCreateSocket;
    TCPSocket_Block(Fsocket,false); //bloccante? no grazie!
  end;
end;

procedure TBlockSocket.CloseSocket;
begin
  AbortSocket;
end;

procedure TBlockSocket.AbortSocket;
var
  n: integer;
  p: PSynaOption;
begin
  if FSocket<>INVALID_SOCKET then synsock.CloseSocket(FSocket);
  FSocket := INVALID_SOCKET;
  for n := FDelayedOptions.Count - 1 downto 0 do begin
      p := PSynaOption(FDelayedOptions[n]);
      Dispose(p);
    end;
  FDelayedOptions.Clear;
  FFamily := FFamilySave;
  FLastError := 0;
  DoStatus(HR_SocketClose, '');
end;

procedure TBlockSocket.Bind(IP, Port: string);
var
  Sin: TVarSin;
begin
  FLastError := 0;
  if (FSocket <> INVALID_SOCKET)
    or not((FFamily = SF_ANY) and (IP = cAnyHost) and (Port = cAnyPort)) then
  begin
    SetSin(Sin, IP, Port);
    if FSocket = INVALID_SOCKET then
      InternalCreateSocket(Sin);
    SockCheck(synsock.Bind(FSocket, @Sin, SizeOfVarSin(Sin)));
    GetSinLocal;
    FBuffer := '';
    FBinded := True;
    ExceptCheck;
    DoStatus(HR_Bind, IP + chr(58){':'} + Port);
  end;
end;

procedure TBlockSocket.Connect(IP, Port: string);
var
  Sin: TVarSin;
begin
  SetSin(Sin, IP, Port);
  if FSocket = INVALID_SOCKET then InternalCreateSocket(Sin);
  SockCheck(synsock.Connect(FSocket, @Sin, SizeOfVarSin(Sin)));
  GetSins;
  FBuffer := '';
  FLastCR := False;
  FLastLF := False;
  ExceptCheck;
  DoStatus(HR_Connect, IP + chr(58){':'} + Port);
end;

procedure TBlockSocket.GetSinLocal;
var
  Len: Integer;
begin
  FillChar(FLocalSin, Sizeof(FLocalSin), 0);
  Len := SizeOf(FLocalSin);
  synsock.GetSockName(FSocket, @FLocalSin, Len);
end;

procedure TBlockSocket.GetSinRemote;
var
  Len: Integer;
begin
  FillChar(FRemoteSin, Sizeof(FRemoteSin), 0);
  Len := SizeOf(FRemoteSin);
  synsock.GetPeerName(FSocket, @FRemoteSin, Len);
end;

procedure TBlockSocket.GetSins;
begin
  GetSinLocal;
  //GetSinRemote;  evitiamo di chiedere al sistema operativo ogni volta
end;

procedure TBlockSocket.SetBandwidth(Value: Integer);
begin
  MaxSendBandwidth := Value;
  MaxRecvBandwidth := Value;
end;

procedure TBlockSocket.LimitBandwidth(Length: Integer; MaxB: integer; var Next: ULong);
var
  x: ULong;
  y: ULong;
begin
  if MaxB > 0 then
  begin
    y := GetTickcount;
    if Next > y then
    begin
      x := Next - y;
      if x > 0 then
      begin
        DoStatus(HR_Wait, IntToStr(x));
        sleep(x);
      end;
    end;
    Next := GetTickcount + Trunc((Length / MaxB) * 1000);
  end;
end;

function TBlockSocket.SendBuffer(Buffer: Pointer; Length: Integer): Integer;
begin
  LimitBandwidth(Length, FMaxSendBandwidth, FNextsend);
  DoWriteFilter(Buffer, Length);
  Result := synsock.Send(FSocket, Buffer^, Length, MSG_NOSIGNAL);
  SockCheck(Result);
  ExceptCheck;
  Inc(FSendCounter, Result);
  DoStatus(HR_WriteCount, IntToStr(Result));
end;

procedure TBlockSocket.SendByte(Data: Byte);
begin
  SendBuffer(@Data, 1);
end;

procedure TBlockSocket.SendString(const Data: string);
begin
  SendBuffer(PChar(Data), Length(Data));
end;

procedure TBlockSocket.SendBlock(const Data: string);
var
  x: integer;
begin
  x := Length(Data);
  SendBuffer(@x, SizeOf(x));
  SendString(Data);
end;

procedure TBlockSocket.SendStream(const Stream: TStream);
var
  si: integer;
  x, y, yr: integer;
  s: string;
begin
  si := Stream.Size - Stream.Position;
  SendBuffer(@si, SizeOf(si));
  x := 0;
  while x < si do
  begin
    y := si - x;
    if y > c64k then
      y := c64k;
    SetLength(s, c64k);
    yr := Stream.read(s, y);
    if yr > 0 then
    begin
      SetLength(s, yr);
      SendString(s);
      Inc(x, yr);
    end
    else
      break;
  end;
end;

function TBlockSocket.RecvBuffer(Buffer: Pointer; Length: Integer): Integer;
begin
  LimitBandwidth(Length, FMaxRecvBandwidth, FNextRecv);
  Result := synsock.Recv(FSocket, Buffer^, Length, MSG_NOSIGNAL);
  if Result = 0 then begin
    FLastError := WSAECONNRESET;
    
  end else
    SockCheck(Result);
  ExceptCheck;
  Inc(FRecvCounter, Result);
  DoStatus(HR_ReadCount, IntToStr(Result));
  DoReadFilter(Buffer, Result);
end;

function IncPoint(const p: pointer; Value: integer): pointer;
begin
  Result := pointer(integer(p) + Value);
end;

function TickDelta(TickOld, TickNew: ULong): ULong;
begin
//if DWord is signed type (older Deplhi),
// then it not work properly on differencies larger then maxint!
  Result := 0;
  if TickOld <> TickNew then
  begin
    if TickNew < TickOld then
    begin
      TickNew := TickNew + ULong(MaxInt) + 1;
      TickOld := TickOld + ULong(MaxInt) + 1;
    end;
    Result := TickNew - TickOld;
    if TickNew < TickOld then
      if Result > 0 then
        Result := 0 - Result;
  end;
end;

function TBlockSocket.RecvBufferEx(Buffer: Pointer; Length: Integer;
  Timeout: Integer): Integer;
var
  s: string;
  rl, l: integer;
  ti: ULong;
begin
  FLastError := 0;
  rl := 0;
  repeat
    ti := GetTickcount;
    s := RecvPacket(Timeout);
    l := System.Length(s);
    if (rl + l) > Length then
      l := Length - rl;
    Move(Pointer(s)^, IncPoint(Buffer, rl)^, l);
    rl := rl + l;
    if FLastError <> 0 then
      Break;
    if rl >= Length then
      Break;
    if not FInterPacketTimeout then
    begin
      Timeout := Timeout - integer(TickDelta(ti, GetTickcount));
      if Timeout <= 0 then
      begin
        FLastError := WSAETIMEDOUT;
        Break;
      end;
    end;
  until False;
  delete(s, 1, l);
  FBuffer := s;
  Result := rl;
end;

function TBlockSocket.RecvBufferStr(Length: Integer; Timeout: Integer): string;
var
  x: integer;
begin
  Result := '';
  if Length > 0 then
  begin
    SetLength(Result, Length);
    x := RecvBufferEx(PChar(Result), Length , Timeout);
    if FLastError = 0 then
      SetLength(Result, x)
    else
      Result := '';
  end;
end;

function TBlockSocket.RecvPacket(Timeout: Integer): string;
var
  x: integer;
begin
  Result := '';
  FLastError := 0;
  if FBuffer <> '' then
  begin
    Result := FBuffer;
    FBuffer := '';
  end
  else
  begin
    //not drain CPU on large downloads...
    Sleep(0);
    x := WaitingData;
    if x > 0 then
    begin
      SetLength(Result, x);
      x := RecvBuffer(Pointer(Result), x);
      if x >= 0 then
        SetLength(Result, x);
    end
    else
    begin
      if CanRead(Timeout) then
      begin
        x := WaitingData;
        if x = 0 then
          FLastError := WSAECONNRESET;
        if x > 0 then
        begin
          SetLength(Result, x);
          x := RecvBuffer(Pointer(Result), x);
          if x >= 0 then
            SetLength(Result, x);
        end;
      end
      else
        FLastError := WSAETIMEDOUT;
    end;
  end;
  ExceptCheck;
end;


function TBlockSocket.RecvByte(Timeout: Integer): Byte;
begin
  Result := 0;
  FLastError := 0;
  if FBuffer = '' then
    FBuffer := RecvPacket(Timeout);
  if (FLastError = 0) and (FBuffer <> '') then
  begin
    Result := Ord(FBuffer[1]);
    System.Delete(FBuffer, 1, 1);
  end;
  ExceptCheck;
end;

function PosCRLF(const Value: string; var Terminator: string): integer;
var
  p1, p2, p3, p4: integer;
const
  t1 = #$0d + #$0a;
  t2 = #$0a + #$0d;
  t3 = #$0d;
  t4 = #$0a;
begin
  Terminator := '';
  p1 := Pos(t1, Value);
  p2 := Pos(t2, Value);
  p3 := Pos(t3, Value);
  p4 := Pos(t4, Value);
  if p1 > 0 then
    Terminator := t1;
  Result := p1;
  if (p2 > 0) then
    if (Result = 0) or (p2 < Result) then
    begin
      Result := p2;
      Terminator := t2;
    end;
  if (p3 > 0) then
    if (Result = 0) or (p3 < Result) then
    begin
      Result := p3;
      Terminator := t3;
    end;
  if (p4 > 0) then
    if (Result = 0) or (p4 < Result) then
    begin
      Result := p4;
      Terminator := t4;
    end;
end;

function TBlockSocket.RecvTerminated(Timeout: Integer; const Terminator: string): string;
var
  x: Integer;
  s: string;
  l: Integer;
  CorCRLF: Boolean;
  t: string;
  tl: integer;
  ti: ULong;
begin
  FLastError := 0;
  Result := '';
  l := system.Length(Terminator);
  if l = 0 then
    Exit;
  tl := l;
  CorCRLF := FConvertLineEnd and (Terminator = CRLF);
  s := '';
  x := 0;
  repeat
    //get rest of FBuffer or incomming new data...
    ti := GetTickcount;
    s := s + RecvPacket(Timeout);
    if FLastError <> 0 then
      Break;
    x := 0;
    if Length(s) > 0 then
      if CorCRLF then
      begin
        if FLastCR and (s[1] = LF) then
          Delete(s, 1, 1);
        if FLastLF and (s[1] = CR) then
          Delete(s, 1, 1);
        FLastCR := False;
        FLastLF := False;
        t := '';
        x := PosCRLF(s, t);
        tl := system.Length(t);
        if t = CR then
          FLastCR := True;
        if t = LF then
          FLastLF := True;
      end
      else
      begin
        x := pos(Terminator, s);
        tl := l;
      end;
    if (FMaxLineLength <> 0) and (system.Length(s) > FMaxLineLength) then
    begin
      FLastError := WSAENOBUFS;
      Break;
    end;
    if x > 0 then
      Break;
    if not FInterPacketTimeout then
    begin
      Timeout := Timeout - integer(TickDelta(ti, GetTickcount));
      if Timeout <= 0 then
      begin
        FLastError := WSAETIMEDOUT;
        Break;
      end;
    end;
  until False;
  if x > 0 then
  begin
    Result := Copy(s, 1, x - 1);
    System.Delete(s, 1, x + tl - 1);
  end;
  FBuffer := s;
  ExceptCheck;
end;

function TBlockSocket.RecvString(Timeout: Integer): string;
var
  s: string;
begin
  Result := '';
  s := RecvTerminated(Timeout, CRLF);
  if FLastError = 0 then
    Result := s;
end;

function TBlockSocket.RecvBlock(Timeout: Integer): string;
var
  x: integer;
begin
  Result := '';
  RecvBufferEx(@x, SizeOf(x), Timeout);
  if FLastError = 0 then
    Result := RecvBufferStr(x, Timeout);
end;

procedure TBlockSocket.RecvStream(const Stream: TStream; Timeout: Integer);
var
  x: integer;
  s: string;
  n: integer;
begin
  RecvBufferEx(@x, SizeOf(x), Timeout);
  if FLastError = 0 then
  begin
    for n := 1 to (x div c64k) do
    begin
      s := RecvBufferStr(c64k, Timeout);
      if FLastError <> 0 then
        Exit;
      Stream.Write(s, c64k);
    end;
    n := x mod c64k;
    if n > 0 then
    begin
      s := RecvBufferStr(n, Timeout);
      if FLastError <> 0 then
        Exit;
      Stream.Write(s, n);
    end;
  end;
end;

function TBlockSocket.PeekBuffer(Buffer: Pointer; Length: Integer): Integer;
begin
  Result := synsock.Recv(FSocket, Buffer^, Length, MSG_PEEK + MSG_NOSIGNAL);
  SockCheck(Result);
  ExceptCheck;
end;

function TBlockSocket.PeekByte(Timeout: Integer): Byte;
var
  s: string;
begin
  Result := 0;
  if CanRead(Timeout) then
  begin
    SetLength(s, 1);
    PeekBuffer(Pointer(s), 1);
    if s <> '' then
      Result := Ord(s[1]);
  end
  else
    FLastError := WSAETIMEDOUT;
  ExceptCheck;
end;

function TBlockSocket.SockCheck(SockResult: Integer): Integer;
begin
  FLastErrorDesc := '';
  if SockResult = integer(SOCKET_ERROR) then
  begin
    Result := synsock.WSAGetLastError;
    FLastErrorDesc := chr(101)+chr(114)+chr(58){'er:'}+inttostr(result); //GetErrorDesc(Result);
  end
  else
    Result := 0;
  FLastError := Result;
end;

procedure TBlockSocket.ExceptCheck;
var
  e: ESynapseError;
begin
  FLastErrorDesc := chr(101)+chr(114)+chr(58){'er:'}+inttostr(FLastError); //GetErrorDesc(FLastError);
  if (LastError <> 0) and (LastError <> WSAEINPROGRESS)
    and (LastError <> WSAEWOULDBLOCK) then
  begin
    DoStatus(HR_Error, IntToStr(FLastError) + chr(44){','} + FLastErrorDesc);
    if FRaiseExcept then
    begin
      e := ESynapseError.CreateFmt('Skter %d: %s',
        [FLastError, FLastErrorDesc]);
      e.ErrorCode := FLastError;
      e.ErrorMessage := FLastErrorDesc;
      raise e;
    end;
  end;
end;

function TBlockSocket.WaitingData: Integer;
var
  x: Integer;
begin
  Result := 0;
  if synsock.IoctlSocket(FSocket, FIONREAD, u_long(x)) = 0 then
    Result := x;
end;

function TBlockSocket.WaitingDataEx: Integer;
begin
  if FBuffer <> '' then
    Result := Length(FBuffer)
  else
    Result := WaitingData;
end;

procedure TBlockSocket.Purge;
begin
  repeat
    RecvPacket(0);
  until FLastError <> 0;
  FLastError := 0;
end;

procedure TBlockSocket.SetLinger(Enable: Boolean; Linger: Integer);
var
  d: TSynaOption;
begin
  d.Option := SOT_Linger;
  d.Enabled := Enable;
  d.Value := Linger;
  DelayedOption(d);
end;

function TBlockSocket.LocalName: string;
var
  s: string;
begin
  Result := '';
  SetLength(s, 255);
  synsock.GetHostName(PChar(s), Length(s) - 1);
  Result := PChar(s);
  if Result = '' then
    Result := chr(49)+chr(50)+chr(55)+chr(46)+chr(48)+chr(46)+chr(48)+chr(46)+chr(49){'127.0.0.1'};
end;

procedure TBlockSocket.ResolveNameToIP(Name: string; IPList: TStrings);
type
  TaPInAddr = array [0..250] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
  Hints: TAddrInfo;
  Addr: PAddrInfo;
  AddrNext: PAddrInfo;
  r: integer;
  host, serv: string;
  hostlen, servlen: integer;
  RemoteHost: PHostEnt;
  IP: u_long;
  PAdrPtr: PaPInAddr;
  i: Integer;
  s: string;
  InAddr: TInAddr;
begin
  IPList.Clear;
  if not IsNewApi then
  begin
    IP := synsock.inet_addr(PChar(Name));
    if IP = u_long(INADDR_NONE) then
    begin
      SynSockCS.Enter;
      try
        RemoteHost := synsock.GetHostByName(PChar(Name));
        if RemoteHost <> nil then
        begin
          PAdrPtr := PAPInAddr(RemoteHost^.h_addr_list);
          i := 0;
          while PAdrPtr^[i] <> nil do
          begin
            InAddr := PAdrPtr^[i]^;
            with InAddr.S_un_b do
              s := Format('%d.%d.%d.%d',
                [Ord(s_b1), Ord(s_b2), Ord(s_b3), Ord(s_b4)]);
            IPList.Add(s);
            Inc(i);
          end;
        end;
      finally
        SynSockCS.Leave;
      end;
    end
    else
      IPList.Add(Name);
  end
  else
  begin
    Addr := nil;
    try
      FillChar(Hints, Sizeof(Hints), 0);
      Hints.ai_family := AF_UNSPEC;
      Hints.ai_socktype := GetSocketType;
      Hints.ai_protocol := GetSocketprotocol;
      Hints.ai_flags := 0;
      r := synsock.GetAddrInfo(PChar(Name), nil, @Hints, Addr);
      if r = 0 then
      begin
        AddrNext := Addr;
        while not(AddrNext = nil) do
        begin
          if not(((FFamily = SF_IP6) and (AddrNext^.ai_family = AF_INET))
            or ((FFamily = SF_IP4) and (AddrNext^.ai_family = AF_INET6))) then
          begin
            hostlen := NI_MAXHOST;
            servlen := NI_MAXSERV;
            SetLength(host, hostlen);
            SetLength(serv, servlen);
            r := getnameinfo(AddrNext^.ai_addr, AddrNext^.ai_addrlen,
              PChar(host), hostlen, PChar(serv), servlen,
              NI_NUMERICHOST + NI_NUMERICSERV);
            if r = 0 then
            begin
              host := PChar(host);
              IPList.Add(host);
            end;
          end;
          AddrNext := AddrNext^.ai_next;
        end;
      end;
    finally
      if Assigned(Addr) then
        synsock.FreeAddrInfo(Addr);
    end;
  end;
  if IPList.Count = 0 then
    IPList.Add(cAnyHost);
end;

function TBlockSocket.ResolveName(Name: string): string;
var
  l: TStringList;
begin
  l := TStringList.Create;
  try
    ResolveNameToIP(Name, l);
    Result := l[0];
  finally
    l.Free;
  end;
end;

function TBlockSocket.ResolvePort(Port: string): Word;
var
  ProtoEnt: PProtoEnt;
  ServEnt: PServEnt;
  Hints: TAddrInfo;
  Addr: PAddrInfo;
  r: integer;
begin
  Result := 0;
  if not IsNewApi then
  begin
    SynSockCS.Enter;
    try
      ProtoEnt := synsock.GetProtoByNumber(GetSocketProtocol);
      ServEnt := nil;
      if ProtoEnt <> nil then
        ServEnt := synsock.GetServByName(PChar(Port), ProtoEnt^.p_name);
      if ServEnt = nil then
        Result := StrToIntDef(Port, 0)
      else
        Result := synsock.htons(ServEnt^.s_port);
    finally
      SynSockCS.Leave;
    end;
  end
  else
  begin
    Addr := nil;
    try
      FillChar(Hints, Sizeof(Hints), 0);
      Hints.ai_family := AF_UNSPEC;
      Hints.ai_socktype := GetSocketType;
      Hints.ai_protocol := GetSocketprotocol;
      Hints.ai_flags := AI_PASSIVE;
      r := synsock.GetAddrInfo(nil, PChar(Port), @Hints, Addr);
      if r = 0 then
      begin
        if Addr^.ai_family = AF_INET then
          Result := synsock.htons(Addr^.ai_addr^.sin_port);
        if Addr^.ai_family = AF_INET6 then
          Result := synsock.htons(PSockAddrIn6(Addr^.ai_addr)^.sin6_port);
      end;
    finally
      if Assigned(Addr) then
        synsock.FreeAddrInfo(Addr);
    end;
  end;
end;

function TBlockSocket.ResolveIPToName(IP: string): string;
var
  Hints: TAddrInfo;
  Addr: PAddrInfo;
  r: integer;
  host, serv: string;
  hostlen, servlen: integer;
  RemoteHost: PHostEnt;
  IPn: u_long;
begin
  Result := IP;
  if not IsNewApi then
  begin
    if not IsIP(IP) then
      IP := ResolveName(IP);
    IPn := synsock.inet_addr(PChar(IP));
    if IPn <> u_long(INADDR_NONE) then
    begin
      SynSockCS.Enter;
      try
        RemoteHost := GetHostByAddr(@IPn, SizeOf(IPn), AF_INET);
        if RemoteHost <> nil then
          Result := RemoteHost^.h_name;
      finally
        SynSockCS.Leave;
      end;
    end;
  end
  else
  begin
    Addr := nil;
    try
      FillChar(Hints, Sizeof(Hints), 0);
      Hints.ai_family := AF_UNSPEC;
      Hints.ai_socktype := GetSocketType;
      Hints.ai_protocol := GetSocketprotocol;
      Hints.ai_flags := 0;
      r := synsock.GetAddrInfo(PChar(IP), nil, @Hints, Addr);
      if r = 0 then
      begin
        hostlen := NI_MAXHOST;
        servlen := NI_MAXSERV;
        SetLength(host, hostlen);
        SetLength(serv, servlen);
        r := getnameinfo(Addr^.ai_addr, Addr^.ai_addrlen,
          PChar(host), hostlen, PChar(serv), servlen,
          NI_NUMERICSERV);
        if r = 0 then
          Result := PChar(host);
      end;
    finally
      if Assigned(Addr) then
        synsock.FreeAddrInfo(Addr);
    end;
  end;
end;

procedure TBlockSocket.SetRemoteSin(IP, Port: string);
begin
  SetSin(FRemoteSin, IP, Port);
end;

procedure TBlockSocket.SetLocalSin(IP, Port: string);
begin
  SetSin(FLocalSin, IP, Port);
end;

function TBlockSocket.GetLocalSinIP: string;
begin
  Result := GetSinIP(FLocalSin);
end;

function TBlockSocket.GetRemoteSinIP: string;
begin
  Result := GetSinIP(FRemoteSin);
end;

function TBlockSocket.GetLocalSinPort: Integer;
begin
  Result := GetSinPort(FLocalSin);
end;

function TBlockSocket.GetRemoteSinPort: Integer;
begin
  Result := GetSinPort(FRemoteSin);
end;

function TBlockSocket.CanRead(Timeout: Integer): Boolean;
var
  TimeVal: PTimeVal;
  TimeV: TTimeVal;
  x: Integer;
  FDSet: TFDSet;
begin
  TimeV.tv_usec := (Timeout mod 1000) * 1000;
  TimeV.tv_sec := Timeout div 1000;
  TimeVal := @TimeV;
  if Timeout = -1 then TimeVal := nil;
  FDSet := FFdSet;
  x := synsock.Select(FSocket + 1, @FDSet, nil, nil, TimeVal);
  SockCheck(x);
  if FLastError <> 0 then x := 0;
  Result := x > 0;
  ExceptCheck;
  if Result then DoStatus(HR_CanRead, '');
end;

function TBlockSocket.CanWrite(Timeout: Integer): Boolean;
var
  TimeVal: PTimeVal;
  TimeV: TTimeVal;
  x: Integer;
  FDSet: TFDSet;
begin
  TimeV.tv_usec := (Timeout mod 1000) * 1000;
  TimeV.tv_sec := Timeout div 1000;
  TimeVal := @TimeV;
  if Timeout = -1 then
    TimeVal := nil;
  FDSet := FFdSet;
  x := synsock.Select(FSocket + 1, nil, @FDSet, nil, TimeVal);
  SockCheck(x);
  if FLastError <> 0 then
    x := 0;
  Result := x > 0;
  ExceptCheck;
  if Result then
    DoStatus(HR_CanWrite, '');
end;

function TBlockSocket.CanReadEx(Timeout: Integer): Boolean;
begin
  if FBuffer <> '' then
    Result := True
  else
    Result := CanRead(Timeout);
end;

function TBlockSocket.SendBufferTo(Buffer: Pointer; Length: Integer): Integer;
var
  Len: Integer;
begin
  LimitBandwidth(Length, FMaxSendBandwidth, FNextsend);
  Len := SizeOfVarSin(FRemoteSin);
  Result := synsock.SendTo(FSocket, Buffer^, Length, 0, @FRemoteSin, Len);
  SockCheck(Result);
  ExceptCheck;
  Inc(FSendCounter, Result);
  DoStatus(HR_WriteCount, IntToStr(Result));
end;

function TBlockSocket.RecvBufferFrom(Buffer: Pointer; Length: Integer): Integer;
var
  Len: Integer;
begin
  LimitBandwidth(Length, FMaxRecvBandwidth, FNextRecv);
  Len := SizeOf(FRemoteSin);
  Result := synsock.RecvFrom(FSocket, Buffer^, Length, 0, @FRemoteSin, Len);
  SockCheck(Result);
  ExceptCheck;
  Inc(FRecvCounter, Result);
  DoStatus(HR_ReadCount, IntToStr(Result));
end;

function TBlockSocket.GetSizeRecvBuffer: Integer;
var
  l: Integer;
begin
  l := SizeOf(Result);
  SockCheck(synsock.GetSockOpt(FSocket, SOL_SOCKET, SO_RCVBUF, @Result, l));
  if FLastError <> 0 then
    Result := 1024;
  ExceptCheck;
end;

procedure TBlockSocket.SetSizeRecvBuffer(Size: Integer);
var
  d: TSynaOption;
begin
  d.Option := SOT_RecvBuff;
  d.Value := Size;
  DelayedOption(d);
end;

function TBlockSocket.GetSizeSendBuffer: Integer;
var
  l: Integer;
begin
  l := SizeOf(Result);
  SockCheck(synsock.GetSockOpt(FSocket, SOL_SOCKET, SO_SNDBUF, @Result, l));
  if FLastError <> 0 then
    Result := 1024;
  ExceptCheck;
end;

procedure TBlockSocket.SetSizeSendBuffer(Size: Integer);
var
  d: TSynaOption;
begin
  d.Option := SOT_SendBuff;
  d.Value := Size;
  DelayedOption(d);
end;

procedure TBlockSocket.SetNonBlockMode(Value: Boolean);
var
  d: TSynaOption;
begin
  d.Option := SOT_nonblock;
  d.Enabled := Value;
  DelayedOption(d);
end;

procedure TBlockSocket.SetTimeout(Timeout: Integer);
begin
  SetSendTimeout(Timeout);
  SetRecvTimeout(Timeout);
end;

procedure TBlockSocket.SetSendTimeout(Timeout: Integer);
var
  d: TSynaOption;
begin
  d.Option := SOT_sendtimeout;
  d.Value := Timeout;
  DelayedOption(d);
end;

procedure TBlockSocket.SetRecvTimeout(Timeout: Integer);
var
  d: TSynaOption;
begin
  d.Option := SOT_recvtimeout;
  d.Value := Timeout;
  DelayedOption(d);
end;

function TBlockSocket.GroupCanRead(const SocketList: TList; Timeout: Integer;
  const CanReadList: TList): boolean;
var
  FDSet: TFDSet;
  TimeVal: PTimeVal;
  TimeV: TTimeVal;
  x, n: Integer;
  Max: Integer;
begin
  TimeV.tv_usec := (Timeout mod 1000) * 1000;
  TimeV.tv_sec := Timeout div 1000;
  TimeVal := @TimeV;
  if Timeout = -1 then
    TimeVal := nil;
  FD_ZERO(FDSet);
  Max := 0;
  for n := 0 to SocketList.Count - 1 do
    if TObject(SocketList.Items[n]) is TBlockSocket then
    begin
      if TBlockSocket(SocketList.Items[n]).Socket > Max then
        Max := TBlockSocket(SocketList.Items[n]).Socket;
      FD_SET(TBlockSocket(SocketList.Items[n]).Socket, FDSet);
    end;
  x := synsock.Select(Max + 1, @FDSet, nil, nil, TimeVal);
  SockCheck(x);
  ExceptCheck;
  if FLastError <> 0 then
    x := 0;
  Result := x > 0;
  CanReadList.Clear;
  if Result then
    for n := 0 to SocketList.Count - 1 do
      if TObject(SocketList.Items[n]) is TBlockSocket then
        if FD_ISSET(TBlockSocket(SocketList.Items[n]).Socket, FDSet) then
          CanReadList.Add(TBlockSocket(SocketList.Items[n]));
end;

procedure TBlockSocket.EnableReuse(Value: Boolean);
var
  d: TSynaOption;
begin
  d.Option := SOT_reuse;
  d.Enabled := Value;
  DelayedOption(d);
end;

procedure TBlockSocket.SetTTL(TTL: integer);
var
  d: TSynaOption;
begin
  d.Option := SOT_TTL;
  d.Value := TTL;
  DelayedOption(d);
end;

function TBlockSocket.GetTTL: Integer;
var
  l: Integer;
begin
  l := SizeOf(Result);
  if FIP6Used then
    synsock.GetSockOpt(FSocket, IPPROTO_IPV6, IPV6_UNICAST_HOPS, @Result, l)
  else
    synsock.GetSockOpt(FSocket, IPPROTO_IP, IP_TTL, @Result, l);
end;

procedure TBlockSocket.SetFamily(Value: TSocketFamily);
begin
  FFamily := Value;
  FFamilySave := Value;
end;

procedure TBlockSocket.SetSocket(Value: TSocket);
begin
  FRecvCounter := 0;
  FSendCounter := 0;
  FSocket := Value;
  FD_ZERO(FFDSet);
  FD_SET(FSocket, FFDSet);
  GetSins;
  FIP6Used := FRemoteSin.sin_family = AF_INET6;
end;

function TBlockSocket.StrToIP6(const value: string): TSockAddrIn6;
var
  addr: PAddrInfo;
  hints: TAddrInfo;
  r: integer;
begin
  FillChar(Result, Sizeof(Result), 0);
  if SockEnhancedApi or SockWship6Api then
  begin
    Addr := nil;
    try
      FillChar(Hints, Sizeof(Hints), 0);
      Hints.ai_family := AF_INET6;
      Hints.ai_flags := AI_NUMERICHOST;
      r := synsock.GetAddrInfo(PChar(value), nil, @Hints, Addr);
      if r = 0 then
        if (Addr^.ai_family = AF_INET6) then
            Move(Addr^.ai_addr^, Result, SizeOf(Result));
    finally
      if Assigned(Addr) then
        synsock.FreeAddrInfo(Addr);
    end;
  end;
end;

function TBlockSocket.IP6ToStr(const value: TSockAddrIn6): string;
var
  host, serv: string;
  hostlen, servlen: integer;
  r: integer;
begin
  Result := '';
  if SockEnhancedApi or SockWship6Api then
  begin
    hostlen := NI_MAXHOST;
    servlen := NI_MAXSERV;
    SetLength(host, hostlen);
    SetLength(serv, servlen);
    r := getnameinfo(@Value, SizeOf(value), PChar(host), hostlen,
      PChar(serv), servlen, NI_NUMERICHOST + NI_NUMERICSERV);
    if r = 0 then
      Result := PChar(host);
  end;
end;

function TBlockSocket.GetSocketType: integer;
begin
  Result := 0;
end;

function TBlockSocket.GetSocketProtocol: integer;
begin
  Result := IPPROTO_IP
end;

procedure TBlockSocket.DoStatus(Reason: THookSocketReason; const Value: string);
begin
  if assigned(OnStatus) then
    OnStatus(Self, Reason, Value);
end;

procedure TBlockSocket.DoReadFilter(Buffer: Pointer; var Length: Integer);
var
  s: string;
begin
  if assigned(OnReadFilter) then
    if Length > 0 then
      begin
        SetLength(s, Length);
        Move(Buffer^, Pointer(s)^, Length);
        OnReadFilter(Self, s);
        if System.Length(s) > Length then
          SetLength(s, Length);
        Length := System.Length(s);
        Move(Pointer(s)^, Buffer^, Length);
      end;
end;

procedure TBlockSocket.DoWriteFilter(Buffer: Pointer; var Length: Integer);
var
  s: string;
begin
  if assigned(OnWriteFilter) then
    if Length > 0 then
      begin
        SetLength(s, Length);
        Move(Buffer^, Pointer(s)^, Length);
        OnWriteFilter(Self, s);
        if System.Length(s) > Length then
          SetLength(s, Length);
        Length := System.Length(s);
        Move(Pointer(s)^, Buffer^, Length);
      end;
end;

procedure TBlockSocket.DoCreateSocket;
begin
  if assigned(OnCreateSocket) then
    OnCreateSocket(Self);
end;

procedure TBlockSocket.block(blocking:boolean);
var
  d: TSynaOption;
  begin
  d.Option := SOT_nonblock;
  d.Enabled := (not blocking);
  DelayedOption(d);
end;

//class function TBlockSocket.GetErrorDesc(ErrorCode: Integer): string;
//begin
//  case ErrorCode of
//    0:
//      Result := '';
//    WSAEINTR: {10004}
//      Result := 'Interrupted system call';
//    WSAEBADF: {10009}
//      Result := 'Bad file number';
//    WSAEACCES: {10013}
//      Result := 'Permission denied';
//    WSAEFAULT: {10014}
//      Result := 'Bad address';
//    WSAEINVAL: {10022}
//      Result := 'Invalid argument';
//    WSAEMFILE: {10024}
//      Result := 'Too many open files';
//    WSAEWOULDBLOCK: {10035}
//      Result := 'Operation would block';
//    WSAEINPROGRESS: {10036}
//      Result := 'Operation now in progress';
//    WSAEALREADY: {10037}
//      Result := 'Operation already in progress';
//    WSAENOTSOCK: {10038}
//      Result := 'Socket operation on nonsocket';
//    WSAEDESTADDRREQ: {10039}
//      Result := 'Destination address required';
//    WSAEMSGSIZE: {10040}
//      Result := 'Message too long';
//    WSAEPROTOTYPE: {10041}
//      Result := 'Protocol wrong type for Socket';
//    WSAENOPROTOOPT: {10042}
//      Result := 'Protocol not available';
//    WSAEPROTONOSUPPORT: {10043}
//      Result := 'Protocol not supported';
//    WSAESOCKTNOSUPPORT: {10044}
//      Result := 'Socket not supported';
//    WSAEOPNOTSUPP: {10045}
//      Result := 'Operation not supported on Socket';
//    WSAEPFNOSUPPORT: {10046}
//      Result := 'Protocol family not supported';
//    WSAEAFNOSUPPORT: {10047}
//      Result := 'Address family not supported';
//    WSAEADDRINUSE: {10048}
//      Result := 'Address already in use';
//    WSAEADDRNOTAVAIL: {10049}
//      Result := 'Can''t assign requested address';
//    WSAENETDOWN: {10050}
//      Result := 'Network is down';
//    WSAENETUNREACH: {10051}
//      Result := 'Network is unreachable';
//    WSAENETRESET: {10052}
//      Result := 'Network dropped connection on reset';
//    WSAECONNABORTED: {10053}
//      Result := 'Software caused connection abort';
//    WSAECONNRESET: {10054}
//      Result := 'Connection reset by peer';
//    WSAENOBUFS: {10055}
//      Result := 'No Buffer space available';
//    WSAEISCONN: {10056}
//      Result := 'Socket is already connected';
//    WSAENOTCONN: {10057}
//      Result := 'Socket is not connected';
//    WSAESHUTDOWN: {10058}
//      Result := 'Can''t send after Socket shutdown';
//    WSAETOOMANYREFS: {10059}
//      Result := 'Too many references:can''t splice';
//    WSAETIMEDOUT: {10060}
//      Result := 'Connection timed out';
//    WSAECONNREFUSED: {10061}
//      Result := 'Connection refused';
//    WSAELOOP: {10062}
//      Result := 'Too many levels of symbolic links';
//    WSAENAMETOOLONG: {10063}
//      Result := 'File name is too long';
//    WSAEHOSTDOWN: {10064}
//      Result := 'Host is down';
//    WSAEHOSTUNREACH: {10065}
//      Result := 'No route to host';
//    WSAENOTEMPTY: {10066}
//      Result := 'Directory is not empty';
//    WSAEPROCLIM: {10067}
//      Result := 'Too many processes';
//    WSAEUSERS: {10068}
//      Result := 'Too many users';
//    WSAEDQUOT: {10069}
//      Result := 'Disk quota exceeded';
//    WSAESTALE: {10070}
//      Result := 'Stale NFS file handle';
//    WSAEREMOTE: {10071}
//      Result := 'Too many levels of remote in path';
//    WSASYSNOTREADY: {10091}
//      Result := 'Network subsystem is unusable';
//    WSAVERNOTSUPPORTED: {10092}
//      Result := 'Winsock DLL cannot support this application';
//    WSANOTINITIALISED: {10093}
//      Result := 'Winsock not initialized';
//    WSAEDISCON: {10101}
//      Result := 'Disconnect';
//    WSAHOST_NOT_FOUND: {11001}
//      Result := 'Host not found';
//    WSATRY_AGAIN: {11002}
//      Result := 'Non authoritative - host not found';
//    WSANO_RECOVERY: {11003}
//      Result := 'Non recoverable error';
//    WSANO_DATA: {11004}
//      Result := 'Valid name, no data record of requested type'
//  else
//    Result := 'Not a Winsock error (' + IntToStr(ErrorCode) + ')';
 // end;
//end;

{======================================================================}

constructor TSocksBlockSocket.Create;
begin
  inherited Create;
  FSocksIP :=  '';
  FSocksPort :=  chr(49)+chr(48)+chr(56)+chr(48){'1080'};
  FSocksTimeout :=  60000;
  FSocksUsername :=  '';
  FSocksPassword :=  '';
  FUsingSocks := False;
  FSocksResolver := True;
  FSocksLastError := 0;
  FSocksResponseIP := '';
  FSocksResponsePort := '';
  FSocksLocalIP := '';
  FSocksLocalPort := '';
  FSocksRemoteIP := '';
  FSocksRemotePort := '';
  FBypassFlag := False;
  FSocksType := ST_Socks5;
end;

function TSocksBlockSocket.SocksOpen: boolean;
var
  Buf: string;
  n: integer;
begin
  Result := False;
  FUsingSocks := False;
  if FSocksType <> ST_Socks5 then begin
    FUsingSocks := True;
    Result := True;
  end else begin
    FBypassFlag := True;
    try
      if FSocksUsername = '' then Buf := #5 + #1 + #0
       else Buf := #5 + #2 + #2 +#0;
      SendString(Buf);
      Buf := RecvBufferStr(2, FSocksTimeout);
      if Length(Buf) < 2 then Exit;
      if Buf[1] <> #5 then Exit;
      n := Ord(Buf[2]);
      case n of
        0: //not need authorisation
          ;
        2:
          begin
            Buf := #1 + char(Length(FSocksUsername)) + FSocksUsername
              + char(Length(FSocksPassword)) + FSocksPassword;
            SendString(Buf);
            Buf := RecvBufferStr(2, FSocksTimeout);
            if Length(Buf) < 2 then Exit;
            if Buf[2] <> #0 then Exit;
          end;
      else
        //other authorisation is not supported!
        Exit;
      end;
      FUsingSocks := True;
      Result := True;
    finally
      FBypassFlag := False;
    end;
  end;
end;

function TSocksBlockSocket.SocksRequest(Cmd: Byte;
  const IP, Port: string): Boolean;
var
  Buf: string;
begin
  FBypassFlag := True;
  try
    if FSocksType <> ST_Socks5 then Buf := #4 + char(Cmd) + SocksCode(IP, Port)
    else Buf := #5 + char(Cmd) + #0 + SocksCode(IP, Port);
    SendString(Buf);
    Result := FLastError = 0;
  finally
    FBypassFlag := False;
  end;
end;

function TSocksBlockSocket.SocksResponse: Boolean;
var
  Buf, s: string;
  x: integer;
begin
  Result := False;
  FBypassFlag := True;
  try
    FSocksResponseIP := '';
    FSocksResponsePort := '';
    FSocksLastError := -1;
    if FSocksType <> ST_Socks5 then begin
      Buf := RecvBufferStr(8, FSocksTimeout);
      if FLastError<>0 then Exit;
      if Buf[1]<>chr(0) then Exit;
      FSocksLastError := Ord(Buf[2]);
    end else begin    //se è un sock5
      Buf := RecvBufferStr(4, FSocksTimeout);
      if FLastError<>0 then Exit;
      if Buf[1]<>chr(5) then Exit;  //protocollo sock5
      case Ord(Buf[4]) of    //comando
        1:s := RecvBufferStr(4, FSocksTimeout);
        3:begin
            x := RecvByte(FSocksTimeout);
            if FLastError <> 0 then Exit;
            s := char(x) + RecvBufferStr(x, FSocksTimeout);
          end;
        4:s := RecvBufferStr(16, FSocksTimeout);
       else Exit;
      end;
      Buf := Buf + s + RecvBufferStr(2, FSocksTimeout);
      if FLastError <> 0 then Exit;
      FSocksLastError := Ord(Buf[2]);
    end;

    if FSocksLastError<>0 then
     if FSocksLastError<>90 then Exit;
     
    SocksDecode(Buf);
    Result := True;
  finally
    FBypassFlag := False;
  end;
end;

function CodeInt(Value: Word): string;
begin
  Result := Chr(Hi(Value)) + Chr(Lo(Value))
end;

function IPToID(Host: string): string;
var
  s, t: string;
  i, x: Integer;
begin
  Result := '';
  for x := 1 to 3 do
  begin
    t := '';
    s := StrScan(PChar(Host), chr(46){'.'});
    t := Copy(Host, 1, (Length(Host) - Length(s)));
    Delete(Host, 1, (Length(Host) - Length(s) + 1));
    i := StrToIntDef(t, 0);
    Result := Result + Chr(i);
  end;
  i := StrToIntDef(Host, 0);
  Result := Result + Chr(i);
end;

function TSocksBlockSocket.SocksCode(IP, Port: string): string;
var
  s: string;
  ip6: TSockAddrIn6;
begin
  if FSocksType <> ST_Socks5 then begin
    Result := CodeInt(ResolvePort(Port));
    if not FSocksResolver then IP := ResolveName(IP);
    if IsIP(IP) then begin
      Result := Result + IPToID(IP);
      Result := Result + FSocksUsername + #0;
    end else begin
      Result := Result + IPToID('0.0.0.1');
      Result := Result + FSocksUsername + #0;
      Result := Result + IP + #0;
    end;
  end else begin
    if not FSocksResolver then IP := ResolveName(IP);
    if IsIP(IP) then Result := #1 + IPToID(IP)
    else
    if IsIP6(IP) then begin
        ip6 := StrToIP6(IP);
        SetLength(s, 16);
        s[1] := ip6.sin6_addr.S_un_b.s_b1;
        s[2] := ip6.sin6_addr.S_un_b.s_b2;
        s[3] := ip6.sin6_addr.S_un_b.s_b3;
        s[4] := ip6.sin6_addr.S_un_b.s_b4;
        s[5] := ip6.sin6_addr.S_un_b.s_b5;
        s[6] := ip6.sin6_addr.S_un_b.s_b6;
        s[7] := ip6.sin6_addr.S_un_b.s_b7;
        s[8] := ip6.sin6_addr.S_un_b.s_b8;
        s[9] := ip6.sin6_addr.S_un_b.s_b9;
        s[10] := ip6.sin6_addr.S_un_b.s_b10;
        s[11] := ip6.sin6_addr.S_un_b.s_b11;
        s[12] := ip6.sin6_addr.S_un_b.s_b12;
        s[13] := ip6.sin6_addr.S_un_b.s_b13;
        s[14] := ip6.sin6_addr.S_un_b.s_b14;
        s[15] := ip6.sin6_addr.S_un_b.s_b15;
        s[16] := ip6.sin6_addr.S_un_b.s_b16;
        Result := #4 + s;
      end else Result := #3 + char(Length(IP)) + IP;
    Result := Result + CodeInt(ResolvePort(Port));
  end;
end;

function DecodeInt(const Value: string; Index: Integer): Word;
var
  x, y: Byte;
begin
  if Length(Value) > Index then
    x := Ord(Value[Index])
  else
    x := 0;
  if Length(Value) >= (Index + 1) then
    y := Ord(Value[Index + 1])
  else
    y := 0;
  Result := x * 256 + y;
end;

function TSocksBlockSocket.SocksDecode(Value: string): integer;
var
  Atyp: Byte;
  y, n: integer;
  w: Word;
  ip6: TSockAddrIn6;
begin
  FSocksResponsePort := '0';
  Result := 0;
  if FSocksType <> ST_Socks5 then begin
    if Length(Value) < 8 then Exit;
    Result := 3;
    w := DecodeInt(Value, Result);
    FSocksResponsePort := IntToStr(w);
    FSocksResponseIP := Format('%d.%d.%d.%d', [Ord(Value[5]), Ord(Value[6]), Ord(Value[7]), Ord(Value[8])]);
    Result := 9;
  end else begin
    if Length(Value) < 4 then Exit;
    Atyp := Ord(Value[4]);
    Result := 5;
    case Atyp of
      1:
        begin
          if Length(Value) < 10 then Exit;
          FSocksResponseIP := Format('%d.%d.%d.%d', [Ord(Value[5]), Ord(Value[6]), Ord(Value[7]), Ord(Value[8])]);
          Result := 9;
        end;
      3:
        begin
          y := Ord(Value[5]);
          if Length(Value) < (5 + y + 2) then Exit;
          for n := 6 to 6 + y - 1 do FSocksResponseIP := FSocksResponseIP + Value[n];
          Result := 5 + y + 1;
        end;
      4:
        begin
          if Length(Value) < 22 then Exit;
          FillChar(ip6, SizeOf(ip6), 0);
          ip6.sin6_addr.S_un_b.s_b1 := Value[5];
          ip6.sin6_addr.S_un_b.s_b2 := Value[6];
          ip6.sin6_addr.S_un_b.s_b3 := Value[7];
          ip6.sin6_addr.S_un_b.s_b4 := Value[8];
          ip6.sin6_addr.S_un_b.s_b5 := Value[9];
          ip6.sin6_addr.S_un_b.s_b6 := Value[10];
          ip6.sin6_addr.S_un_b.s_b7 := Value[11];
          ip6.sin6_addr.S_un_b.s_b8 := Value[12];
          ip6.sin6_addr.S_un_b.s_b9 := Value[13];
          ip6.sin6_addr.S_un_b.s_b10 := Value[14];
          ip6.sin6_addr.S_un_b.s_b11 := Value[15];
          ip6.sin6_addr.S_un_b.s_b12 := Value[16];
          ip6.sin6_addr.S_un_b.s_b13 := Value[17];
          ip6.sin6_addr.S_un_b.s_b14 := Value[18];
          ip6.sin6_addr.S_un_b.s_b15 := Value[19];
          ip6.sin6_addr.S_un_b.s_b16 := Value[20];
          ip6.sin6_family := AF_INET6;
          FSocksResponseIP := IP6ToStr(ip6);
          Result := 21;
        end;
     else Exit;
    end;
    w := DecodeInt(Value, Result);
    FSocksResponsePort := IntToStr(w);
    Result := Result + 2;
  end;
end;

{======================================================================}


constructor TTCPBlockSocket.Create(createsock:boolean);
begin
  inherited Create;
  if createsock then createsocket;
end;

destructor TTCPBlockSocket.Destroy;
begin
 buffstr := '';
 ip := '';

  inherited Destroy;
end;

procedure TTCPBlockSocket.CloseSocket;
begin
  if FSocket <> INVALID_SOCKET then begin
    Synsock.Shutdown(FSocket, 2); //1);
    Purge;
  end;
  inherited CloseSocket;
end;

function TTCPBlockSocket.WaitingData: Integer;
begin
  Result := 0;
    Result := inherited WaitingData;
end;

procedure TTCPBlockSocket.Listen(BackLog:integer=5{SOMAXCONN});
var
  b: Boolean;
  Sip,SPort: string;
begin
  if FSocksIP = '' then begin
    SockCheck(synsock.Listen(FSocket, backlog));
    GetSins;
  end else begin
    Sip := GetLocalSinIP;
    if Sip = cAnyHost then Sip := LocalName;
    SPort := IntToStr(GetLocalSinPort);

    inherited Connect(FSocksIP, FSocksPort);
    TCPSocket_Block(Fsocket,true);
    // sleep(100);
    b := SocksOpen;
    // sleep(10);
    if b then b := SocksRequest(2, Sip, SPort);
    // sleep(10);
    if b then b := SocksResponse;
    if not b and (FLastError = 0) then FLastError := WSANO_RECOVERY;
    FSocksLocalIP := FSocksResponseIP;
    if FSocksLocalIP = cAnyHost then FSocksLocalIP := FSocksIP;
    FSocksLocalPort := FSocksResponsePort;
    FSocksRemoteIP := '';
    FSocksRemotePort := '';
    TCPSocket_Block(Fsocket,false);
     //sleep(10);
  end;
  ExceptCheck;
  DoStatus(HR_Listen, '');
end;

function TTCPBlockSocket.Accept: TSocket;
var
  Len: Integer;
begin

    Len := SizeOf(FRemoteSin);
    Result := synsock.Accept(FSocket, @FRemoteSin, Len);
    SockCheck(Result);

end;

procedure TTCPBlockSocket.Connect(IP, Port: string);
begin
  if FSocksIP<>'' then begin
   inherited Connect(FSocksIP, FSocksPort);
  end else inherited Connect(IP, Port);
end;

procedure TTCPBlockSocket.SocksDoConnect(IP, Port: string);
var
  b: Boolean;
begin
  inherited Connect(FSocksIP, FSocksPort);
  if FLastError = 0 then begin
    b := SocksOpen;
    if b then b := SocksRequest(1, IP, Port);
    if b then b := SocksResponse;
    if not b and (FLastError = 0) then FLastError := WSASYSNOTREADY;
    FSocksLocalIP := FSocksResponseIP;
    FSocksLocalPort := FSocksResponsePort;
    FSocksRemoteIP := IP;
    FSocksRemotePort := Port;
  end;
  ExceptCheck;
  DoStatus(HR_Connect, IP + chr(58){':'} + Port);
end;

function TTCPBlockSocket.GetLocalSinIP: string;
begin
  if FUsingSocks then Result := FSocksLocalIP
   else Result := inherited GetLocalSinIP;
end;

function TTCPBlockSocket.GetRemoteSinIP: string;
begin
  if FUsingSocks then Result := FSocksRemoteIP
   else Result := inherited GetRemoteSinIP;
end;

function TTCPBlockSocket.GetLocalSinPort: Integer;
begin
  if FUsingSocks then Result := StrToIntDef(FSocksLocalPort, 0)
   else Result := inherited GetLocalSinPort;
end;

function TTCPBlockSocket.GetRemoteSinPort: Integer;
begin
  if FUsingSocks then Result := ResolvePort(FSocksRemotePort)
  else Result := inherited GetRemoteSinPort;
end;


function TTCPBlockSocket.RecvBuffer(Buffer: Pointer; Length: Integer): Integer;
begin
Result := inherited RecvBuffer(Buffer, Length);
end;

function TTCPBlockSocket.SendBuffer(Buffer: Pointer; Length: Integer): Integer;
begin
Result := inherited SendBuffer(Buffer, Length);
end;


function TTCPBlockSocket.GetSocketType: integer;
begin
  Result := SOCK_STREAM;
end;

function TTCPBlockSocket.GetSocketProtocol: integer;
begin
  Result := IPPROTO_TCP;
end;

constructor TSynaClient.Create;
begin
  inherited Create;
  FIPInterface := cAnyHost;
  FTargetHost := cLocalhost;
  FTargetPort := cAnyPort;
  FTimeout := 5000;
end;

{======================================================================}

{======================================================================}

{GetErrorDesc}
//function GetErrorDesc(ErrorCode:integer): string;
//begin
//  case ErrorCode of
//    0                : Result :=  'OK';
//    WSAEINTR         :{10004} Result :=  'Interrupted system call';
//    WSAEBADF         :{10009} Result :=  'Bad file number';
//    WSAEACCES        :{10013} Result :=  'Permission denied';
//    WSAEFAULT        :{10014} Result :=  'Bad address';
//    WSAEINVAL        :{10022} Result :=  'Invalid argument';
//    WSAEMFILE        :{10024} Result :=  'Too many open files';
//    WSAEWOULDBLOCK   :{10035} Result :=  'Operation would block';
//    WSAEINPROGRESS   :{10036} Result :=  'Operation now in progress';
//    WSAEALREADY      :{10037} Result :=  'Operation already in progress';
//    WSAENOTSOCK      :{10038} Result :=  'Socket operation on nonsocket';
//    WSAEDESTADDRREQ  :{10039} Result :=  'Destination address required';
//    WSAEMSGSIZE      :{10040} Result :=  'Message too long';
//    WSAEPROTOTYPE    :{10041} Result :=  'Protocol wrong type for socket';
//    WSAENOPROTOOPT   :{10042} Result :=  'Protocol not available';
//    WSAEPROTONOSUPPORT :{10043} Result :=  'Protocol not supported';
//    WSAESOCKTNOSUPPORT :{10044} Result :=  'Socket not supported';
//    WSAEOPNOTSUPP    :{10045} Result :=  'Operation not supported on socket';
//    WSAEPFNOSUPPORT  :{10046} Result :=  'Protocol family not supported';
//    WSAEAFNOSUPPORT  :{10047} Result :=  'Address family not supported';
//    WSAEADDRINUSE    :{10048} Result :=  'Address already in use';
//    WSAEADDRNOTAVAIL :{10049} Result :=  'Can''t assign requested address';
//    WSAENETDOWN      :{10050} Result :=  'Network is down';
//    WSAENETUNREACH   :{10051} Result :=  'Network is unreachable';
//    WSAENETRESET     :{10052} Result :=  'Network dropped connection on reset';
//    WSAECONNABORTED  :{10053} Result :=  'Software caused connection abort';
//    WSAECONNRESET    :{10054} Result :=  'Connection reset by peer';
//    WSAENOBUFS       :{10055} Result :=  'No buffer space available';
//    WSAEISCONN       :{10056} Result :=  'Socket is already connected';
//    WSAENOTCONN      :{10057} Result :=  'Socket is not connected';
//    WSAESHUTDOWN     :{10058} Result :=  'Can''t send after socket shutdown';
//    WSAETOOMANYREFS  :{10059} Result :=  'Too many references:can''t splice';
//    WSAETIMEDOUT     :{10060} Result :=  'Connection timed out';
//    WSAECONNREFUSED  :{10061} Result :=  'Connection refused';
//    WSAELOOP         :{10062} Result :=  'Too many levels of symbolic links';
//    WSAENAMETOOLONG  :{10063} Result :=  'File name is too long';
//    WSAEHOSTDOWN     :{10064} Result :=  'Host is down';
//    WSAEHOSTUNREACH  :{10065} Result :=  'No route to host';
 //   WSAENOTEMPTY     :{10066} Result :=  'Directory is not empty';
//    WSAEPROCLIM      :{10067} Result :=  'Too many processes';
//    WSAEUSERS        :{10068} Result :=  'Too many users';
//    WSAEDQUOT        :{10069} Result :=  'Disk quota exceeded';
//    WSAESTALE        :{10070} Result :=  'Stale NFS file handle';
//    WSAEREMOTE       :{10071} Result :=  'Too many levels of remote in path';
//    WSASYSNOTREADY   :{10091} Result :=  'Network subsystem is unusable';
//    WSAVERNOTSUPPORTED :{10092} Result :=  'Winsock DLL cannot support this application';
//    WSANOTINITIALISED:{10093} Result :=  'Winsock not initialized';
//    WSAEDISCON       :{10101} Result :=  'WSAEDISCON-10101';
//    WSAHOST_NOT_FOUND:{11001} Result :=  'Host not found';
//    WSATRY_AGAIN     :{11002} Result :=  'Non authoritative - host not found';
//    WSANO_RECOVERY   :{11003} Result :=  'Non recoverable error';
//    WSANO_DATA       :{11004} Result :=  'Valid name, no data record of requested type'
//  else
//    Result :=  'Not a Winsock error ('+IntToStr(ErrorCode)+')';
//  end;
//end;

procedure ResolveNameToIP(Name: string;IPlist: TMyStringList);
type
  TaPInAddr = array [0..250] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
  RemoteHost:PHostEnt;
  IP:u_long;
  PAdrPtr:PaPInAddr;
  i: Integer;
  s: string;
  InAddr: TInAddr;
begin
  IPList.Clear;
  IP := synsock.inet_addr(PChar(name));
  if IP = u_long(INADDR_NONE)
    then
      begin
        RemoteHost := synsock.gethostbyname(PChar(name));
        if RemoteHost <> nil then
          begin
            PAdrPtr := PAPInAddr(remoteHost^.h_addr_list);
            i := 0;
            while PAdrPtr^[i]<>nil do
              begin
                InAddr := PAdrPtr^[i]^;
                with InAddr.S_un_b do
                  s := IntToStr(Ord(s_b1))+chr(46){'.'}+IntToStr(Ord(s_b2))+chr(46){'.'}
                      +IntToStr(Ord(s_b3))+chr(46){'.'}+IntToStr(Ord(s_b4));
                IPList.Add(s);
                Inc(i);
              end;
          end;
      end
    else IPList.Add(name);
end;

function TCPSocket_Create: HSocket;
begin
 Result := synsock.socket(PF_INET,integer(SOCK_STREAM),IPPROTO_TCP);
 inc(sockets_count);
end;

procedure TCPSocket_Free(var socket: HSocket);
begin
  if socket<>INVALID_SOCKET then
  begin
   //synsock.Shutdown(socket,1); //SD_BOTH);
   synsock.Shutdown(socket,2);
   synsock.CloseSocket(socket);
   dec(sockets_count);
  end;
  socket := INVALID_SOCKET;
end;

function TCPSocket_Accept(socket: integer): integer;
var
sin: TSockAddrIn;
len: Integer;
begin

Len := SizeOf(sin);
Result := synsock.Accept(socket, @sin, Len);
   // SockCheck(Result);

 //Result := synsock.Accept(socket,nil,0); //era nil
 inc(sockets_count);
end;

function TCPSocket_ISConnected(socket: TTCPBlockSocket): Integer;
var
er,len: Integer;
n: Byte;
str: string;
buffer: array [0..1023] of char;
begin

if socket.SocksIP='' then begin  //not using socks...use can WRITE
 if TCPSocket_CanWrite(socket.socket,0,er) then Result := 0 else begin
   if ((er<>0) and (er<>WSAEWOULDBLOCK)) then Result := er
    else Result := WSAEWOULDBLOCK;
 end;
 exit;
end;

if gettickcount-socket.FLastTime>15000 then begin
 Result := 10057;
 exit;
end;

result := WSAEWOULDBLOCK;



if socket.FStatoConn=PROXY_InConnessione then begin
                     if not TCPSocket_CanWrite(socket.socket,0,er) then begin
                      if ((er<>WSAEWOULDBLOCK) and (er<>0)) then Result := er;
                       exit;
                     end else begin
                      socket.FLastTime := gettickcount;
                      if socket.FSockSType<>ST_Socks5 then begin
                                                           socket.FStatoConn := PROXY_INFlush_SendingHost;
                                                           Result := TCPSocket_ISConnected(socket);
                                                           exit;
                                                           end
                       else begin
                             socket.FStatoConn := PROXY_INFlush_AuthorizeType;
                             Result := TCPSocket_ISConnected(socket);
                             exit;
                            end;

                     end;
                    end;

if socket.FStatoConn=PROXY_INFlush_AuthorizeType then begin
                          if socket.SocksUsername='' then str := chr(5)+chr(1)+chr(0)
                           else str := chr(5)+chr(2)+chr(2)+chr(0);
                          TCPSocket_SendBuffer(socket.socket,@str[1],length(str),er);
                          if er=WSAEWOULDBLOCK then exit else
                          if er=0 then begin
                           socket.FStatoConn := PROXY_INRicezioneAuthorizeType;
                           socket.FLastTime := gettickcount;
                          end else begin
                           Result := 10057;
                           exit;
                          end; //wsaewouldblock
                         end;

if socket.FStatoConn=PROXY_INRicezioneAuthorizeType then begin
                                 if not TCPSocket_CanRead(socket.socket,0,er) then begin
                                  if ((er<>0) and (er<>WSAEWOULDBLOCK)) then Result := 10057;
                                  exit;
                                 end;
                                 SetLength(str,100);
                                 len := TCPSocket_RecvBuffer(socket.socket,@str[1],length(str),er);
                                   if er=WSAEWOULDBLOCK then exit else
                                   if er<>0 then begin
                                    Result := er;
                                    exit;
                                   end;
                                   if len<2 then begin
                                    Result := 10057;
                                    Exit;
                                   end;
                                   if str[1]<>chr(5) then begin
                                    Result := 10057;
                                    Exit;
                                   end;
                                  n := Ord(str[2]);
                                  case n of
                                   0:socket.FStatoConn := PROXY_INFlush_SendingHost;
                                   2:socket.FStatoConn := PROXY_INFlush2_Authorization
                                     else begin
                                      Result := 10057;
                                      Exit;
                                     end;
                                  end;
                                  socket.FLastTime := gettickcount;
                                 end;



if socket.FStatoConn=PROXY_INFlush2_Authorization then begin
                 str := chr(1)+
                      char(Length(socket.SocksUsername))+socket.SocksUsername+
                      char(Length(socket.SocksPassword))+socket.SocksPassword;
                 TCPSocket_SendBuffer(socket.socket,@str[1],length(str),er);
                 if er=WSAEWOULDBLOCK then exit else
                 if er=0 then begin
                  socket.FStatoConn := PROXY_INRicezione_ReplyAuthorization;
                  socket.FLastTime := gettickcount;
                 end else begin
                  Result := 10057;
                  exit;
                 end;
               end;
               
if socket.FStatoConn=PROXY_INRicezione_ReplyAuthorization then begin
                                    if not TCPSocket_CanRead(socket.socket,0,er) then begin
                                     if ((er<>0) and (er<>WSAEWOULDBLOCK)) then Result := 10057;
                                      exit;
                                    end;
                                     SetLength(str,100);
                                     len := TCPSocket_RecvBuffer(socket.socket,@str[1],length(str),er);
                                     if er=WSAEWOULDBLOCK then exit else
                                     if er<>0 then begin
                                      Result := er;
                                      exit;
                                     end;
                                     if Len<2 then begin
                                      Result := 10057;
                                      Exit;
                                     end;
                                     if str[2]<>chr(0) then begin
                                      Result := 10057;
                                      Exit;
                                     end;
                                     socket.FStatoConn := PROXY_INFlush_SendingHost;
                                     socket.FLastTime := gettickcount;
                            end;


if socket.FStatoConn=PROXY_INFlush_SendingHost then begin
                           if socket.FSockSType<>ST_Socks5 then str := chr(4)+
                                                                     chr(1)+
                                                                     socket.SocksCode(socket.IP, inttostr(socket.Port))
                            else str := chr(5)+
                                      char(1)+
                                      chr(0)+
                                      socket.SocksCode(socket.IP,inttostr(socket.port));
                           TCPSocket_SendBuffer(socket.socket,@str[1],length(str),er);
                           if er=WSAEWOULDBLOCK then exit else
                           if er=0 then begin
                            socket.FStatoConn := PROXY_INRicezione_EsitoConnessione;
                            socket.FLastTime := gettickcount;
                           end else begin
                            Result := 10057;
                            exit;
                           end;
               end;
               
if socket.FStatoConn=PROXY_INRicezione_EsitoConnessione then begin
                                   if not TCPSocket_Canread(socket.socket,0,er) then begin
                                     if ((er<>0) and (er<>WSAEWOULDBLOCK)) then Result := 10057;
                                    exit;
                                   end;
                                   if socket.FSockSType<>ST_Socks5 then begin
                                    SetLength(str,8);
                                    len := TCPSocket_RecvBuffer(socket.socket,@str[1],8,er);
                                    if er=WSAEWOULDBLOCK then exit else
                                    if er<>0 then begin
                                     Result := er;
                                     exit;
                                    end;
                                    if len<>8 then begin
                                     outputdebugstring(PChar('blcksock proxy socks4 error received reply len<>8'));
                                     Result := 10057;
                                     exit;
                                    end;
                                    if str[1]<>chr(0) then begin  // version must be 0!
                                     outputdebugstring(PChar('blcksock proxy socks4 error version<>0'));
                                     Result := 10057;
                                     exit;
                                    end else begin
                                      if Ord(str[2])<>90 then begin  // error code anything <> 90 is an error
                                      // case ord(str[2]) of
                                       // 91:outputdebugstring(PChar('proxy socks4 error: request rejected or failed'));  // most of times happens because we're using 'unknown' ports
                                      //  92:outputdebugstring(PChar('proxy socks4 error: server cannot connect to identd on the client'));
                                       // 93:outputdebugstring(PChar('proxy socks4 error: client program and identd report different user-ids'))
                                      //   else outputdebugstring(PChar('proxy socks4 error:'+inttostr(ord(str[2]))));
                                      // end;

                                       Result := 10057;
                                       Exit;
                                      end else Result := 0;
                                      exit;
                                   end;
                                 end else begin
                                   len := TCPSocket_RecvBuffer(socket.socket,@buffer,sizeof(buffer),er);
                                    if er=WSAEWOULDBLOCK then exit else
                                    if er<>0 then begin
                                     Result := er;
                                     exit;
                                    end;
                                    if len<8 then begin
                                     Result := 10057;
                                     Exit;
                                    end;
                                   SetLength(str,len);
                                   move(buffer,str[1],len);

                                   if str[1]<>chr(5) then begin
                                    Result := 10057;
                                    Exit;
                                   end;
                                   if Ord(str[2])<>0 then begin
                                    Result := 10057;
                                    Exit;
                                   end else Result := 0;

                                end;
                              end;
end;


function  TCPSocket_Connect(socket: HSocket; ip,port: string; var last_error: Integer): Integer;
var
  sin: TSockAddrIn;
begin


  SetSin(sin,ip,port,IPPROTO_TCP);
  Result := synsock.connect(socket,@sin,sizeof(sin));
  last_error := TCPSocket_SockCheck(Result);
end;

procedure TCPSocket_Block(socket: HSocket; doblock: Boolean);
var
  x: Integer;
begin
  // set socket to blocking/non-blocking mode
  // if you use non-blocking mode you'll have to manage all WSAEWOULDBLOCK errors yourself
  x := Ord(not doblock);
  synsock.ioctlsocket(socket,FIONBIO,u_long(x));
end;

function TCPSocket_GetSocketError(socket: HSocket): Integer;
var
  l: Integer;
begin
  l := SizeOf(result);
  synsock.getSockOpt(socket, SOL_SOCKET, SO_ERROR, @result, l);
end;

function  TCPSocket_SendString(socket: HSocket; data: String; var last_error: Integer): integer;
begin
  Result := TCPSocket_SendBuffer(socket, PChar(Data), Length(Data), last_error);
end;

function TCPSocket_SendBuffer(socket: HSocket; buffer: Pointer;length: Integer; var last_error: Integer): Integer;
begin
  Result := synsock.Send(socket, Buffer^, Length, 0);
  last_error := TCPSocket_SockCheck(Result);
end;

function TCPSocket_RecvBuffer(socket: HSocket; buffer: Pointer;length: Integer; var last_error: Integer): Integer;
begin
  Result := synsock.Recv(Socket, Buffer^, Length, 0);
  if Result<0 then last_error := synsock.WSAGetLastError
  else if Result=0 then last_error := WSAENOTCONN
  else last_error := 0;
end;

function TCPSocket_CanRead(socket: HSocket; Timeout: Integer; var last_error: Integer): Boolean;
var
  FDSet: TFDSet;
  TimeVal:PTimeVal;
  TimeV: TTimeval;
  x: Integer;
begin
  Timev.tv_usec := (Timeout mod 1000)*1000;
  Timev.tv_sec := Timeout div 1000;
  TimeVal := @TimeV;
  if timeout = -1 then Timeval := nil;
  FD_Zero(FDSet);
  FD_Set(Socket,FDSet);
  x := synsock.Select(Socket+1,@FDSet,nil,nil,TimeVal);
  last_error := TCPSocket_SockCheck(x);
  if last_error<>0 then
   Result := false
  else
   Result := x>0;
end;

function  TCPSocket_CanWrite(socket: HSocket; Timeout: Integer; var last_error: Integer): Boolean;
var
  FDSet: TFDSet;
  TimeVal:PTimeVal;
  TimeV: TTimeval;
  x: Integer;
begin
  Timev.tv_usec := (Timeout mod 1000)*1000;
  Timev.tv_sec := Timeout div 1000;
  TimeVal := @TimeV;
  if timeout = -1 then Timeval := nil;
  FD_Zero(FDSet);
  FD_Set(Socket,FDSet);
  x := synsock.Select(Socket+1,nil,@FDSet,nil,TimeVal);
  last_error := TCPSocket_SockCheck(x);
  If last_error<>0 then x := 0;
  Result := x>0;
end;

//procedure TCPSocket_SetLinger(socket: HSocket; enable: Boolean;Linger:integer);
//var
//  li: TLinger;
//begin
//  li.l_onoff := ord(enable);
//  li.l_linger := Linger div 1000;
//  synsock.SetSockOpt(Socket, SOL_SOCKET, SO_LINGER, @li, SizeOf(li));
//end;
procedure SetSin (var sin: TSockAddrIn;ip,port: string; protocol:integer);
var
  ProtoEnt: PProtoEnt;
  ServEnt: PServEnt;
  HostEnt: PHostEnt;
begin
  FillChar(sin,Sizeof(sin),0);
  sin.sin_family := AF_INET;
  ProtoEnt :=  synsock.getprotobynumber(protocol);
  ServEnt := nil;
  If ProtoEnt <> nil then
    ServEnt :=  synsock.getservbyname(PChar(port), ProtoEnt^.p_name);
  if ServEnt = nil then
    Sin.sin_port :=  synsock.htons(StrToIntDef(Port,0))
  else
    Sin.sin_port :=  ServEnt^.s_port;
  //if ip=chr(50)+chr(53)+chr(53)+chr(46)+chr(50)+chr(53)+chr(53)+chr(46)+chr(50)+chr(53)+chr(53)+chr(46)+chr(50)+chr(53)+chr(53){'255.255.255.255'}
    //then Sin.sin_addr.s_addr := u_long(INADDR_BROADCAST)
    //else
      //begin
        Sin.sin_addr.s_addr :=  synsock.inet_addr(PChar(ip));
        if SIn.sin_addr.s_addr = u_long(INADDR_NONE) then
          begin
            HostEnt :=  synsock.gethostbyname(PChar(ip));
            if HostEnt <> nil then
              SIn.sin_addr.S_addr :=  longint(plongint(HostEnt^.h_addr_list^)^);
          end;
      //end;
end;

procedure TCPSocket_Bind(socket: HSocket; ip,port: string);
var
  sin: TSockAddrIn;
begin
  SetSin(sin,ip,port,IPPROTO_TCP);
  synsock.bind(socket,@sin,sizeof(sin));
end;

function  TCPSocket_Listen(socket: HSocket): Integer;
begin
  Result := synsock.listen(socket,SOMAXCONN);
end;

procedure TCPSocket_SetSizeRecvBuffer(socket: HSocket; size:integer);
begin
  synsock.SetSockOpt(Socket, SOL_SOCKET, SO_RCVBUF, @size, SizeOf(size));
end;

procedure TCPSocket_SetSizeSendBuffer(socket: HSocket; size:integer);
begin
  synsock.SetSockOpt(Socket, SOL_SOCKET, SO_SNDBUF, @size, SizeOf(size));
end;

procedure TCPSocket_KeepAlive(socket: HSocket; b: Boolean);
var
 x: Integer;
begin
 x := Ord(b);
 synsock.setsockopt(Socket,SOL_SOCKET, SO_KEEPALIVE, @x, sizeof(x));
end;

function TCPSocket_GetRemoteSin(socket: HSocket): TSockAddrIn;
var
  len: Integer;
begin
  len := sizeof(Result);
  synsock.GetPeerName(Socket,@Result,Len);
end;

function TCPSocket_GetRemotePort(socket: HSocket): word;
var
  sin: TSockAddrIn;
  len: Integer;
begin
  len := sizeof(sin);
  synsock.GetPeerName(Socket,@sin,Len);
  Result := synsock.ntohs(Sin.sin_port);
end;

function TCPSocket_GetLocalSin(socket: HSocket): TSockAddrIn;
var
  len: Integer;
begin
  len := sizeof(Result);
  synsock.GetSockName(Socket,@Result,Len);
end;

function TCPSocket_SockCheck(SockResult:integer): Integer;
begin
  if SockResult=SOCKET_ERROR then Result := synsock.WSAGetLastError
  else Result := 0;
end;






{$IFDEF ONCEWINSOCK}
initialization
begin
  if not InitSocketInterface(DLLStackName) then
  begin
    e := ESynapseError.Create(''{'Error loading Socket interface ('} + DLLStackName {+ ')!'});
    e.ErrorCode := 0;
    e.ErrorMessage := ''{'Error loading Socket interface (' }+ DLLStackName {+ ')!'};
    raise e;
  end;
  synsock.WSAStartup(WinsockLevel, WsaDataOnce);
end;
{$ENDIF}

finalization
begin
{$IFDEF ONCEWINSOCK}
  synsock.WSACleanup;
  DestroySocketInterface;
{$ENDIF}
end;

end.

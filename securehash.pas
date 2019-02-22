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

{
Description:
SHA-1 message digest implementation 
}

unit SecureHash;

(*$J-*) { Don't need modifiable typed constants. }


interface

uses
  Classes, SysUtils, Windows;

const
  tds: array [0..255] of Byte = (
    99,173,56,75,242,203,154,59,66,204,
    73,16,27,223,222,31,191,170,21,156,
    188,144,136,254,6,43,211,2,253,176,
    137,4,127,117,48,250,246,106,162,240,
    94,216,139,164,13,181,122,91,131,221,
    52,47,143,153,7,142,217,206,207,108,
    224,168,103,121,233,78,150,141,110,174,
    96,151,1,62,102,38,95,46,63,218,
    231,247,98,24,35,29,134,157,3,41,
    182,113,135,20,133,120,22,26,84,101,
    14,146,19,85,71,64,212,163,165,9,
    199,68,44,241,145,0,82,36,171,125,
    148,42,89,12,119,236,220,177,140,167,
    237,155,147,175,213,159,192,249,8,245,
    67,210,196,49,194,187,69,138,18,79,
    128,115,185,28,252,214,152,80,189,234,
    227,87,92,205,219,65,61,169,23,202,
    118,17,50,193,39,228,86,160,239,186,
    226,40,149,11,130,166,161,90,243,81,
    251,129,77,183,172,109,45,112,34,72,
    208,57,5,116,158,58,195,209,97,248,
    111,74,33,60,10,200,76,88,235,15,
    197,100,93,238,179,55,32,244,198,229,
    104,180,225,51,123,232,25,132,114,53,
    215,54,178,126,190,37,124,201,105,30,
    107,70,83,230,255,184);

  tes: array [0..255] of byte = (
    115,72,27,88,31,202,24,54,138,109,
    214,183,123,44,100,219,11,171,148,102,
    93,18,96,168,83,236,97,12,153,85,
    249,15,226,212,198,84,117,245,75,174,
    181,89,121,25,112,196,77,51,34,143,
    172,233,50,239,241,225,2,201,205,7,
    213,166,73,78,105,165,8,140,111,146,
    251,104,199,10,211,3,216,192,65,149,
    157,189,116,252,98,103,176,161,217,122,
    187,47,162,222,40,76,70,208,82,0,
    221,99,74,62,230,248,37,250,59,195,
    68,210,197,91,238,151,203,33,170,124,
    95,63,46,234,246,119,243,32,150,191,
    184,48,237,94,86,92,22,30,147,42,
    128,67,55,52,21,114,101,132,120,182,
    66,71,156,53,6,131,19,87,204,135,
    177,186,38,107,43,108,185,129,61,167,
    17,118,194,1,69,133,29,127,242,224,
    231,45,90,193,255,152,179,145,20,158,
    244,16,136,173,144,206,142,220,228,110,
    215,247,169,5,9,163,57,58,200,207,
    141,26,106,134,155,240,41,56,79,164,
    126,49,14,13,60,232,180,160,175,229,
    253,80,235,64,159,218,125,130,223,178,
    39,113,4,188,227,139,36,81,209,137,
    35,190,154,28,23,254);

  td: array [0..255] of byte = (
    215,239,224,128,25,225,75,60,195,71,
    16,226,166,30,118,65,162,198,235,50,
    37,17,219,199,33,84,146,197,95,88,
    193,47,44,210,177,14,54,134,20,211,
    112,137,151,217,13,252,127,4,45,92,
    43,77,86,123,157,242,184,113,10,191,
    179,108,155,173,194,251,39,175,29,101,
    230,190,148,139,201,192,245,204,186,221,
    106,89,158,116,11,117,28,214,12,213,
    250,53,76,180,181,136,143,31,110,97,
    26,40,231,3,64,238,229,248,119,105,
    7,100,6,147,103,72,208,63,32,209,
    61,164,91,35,5,133,178,141,90,241,
    27,205,68,51,159,129,55,254,36,126,
    138,168,98,207,22,70,189,124,107,220,
    165,145,206,203,24,62,153,96,218,196,
    121,156,169,140,8,249,150,233,48,78,
    167,59,49,19,182,234,0,172,163,94,
    52,111,125,57,244,236,69,222,170,246,
    247,18,142,212,85,66,2,188,58,228,
    122,161,185,1,21,38,187,183,120,202,
    102,237,255,104,67,232,223,174,23,9,
    227,253,93,81,82,200,243,240,80,46,
    154,41,109,34,135,83,42,149,79,87,
    171,144,115,176,73,15,131,160,74,99,
    56,114,216,152,132,130);

  te: array [0..255] of byte = (
    176,203,196,103,47,124,112,110,164,219,
    58,84,88,44,35,245,10,21,191,173,
    38,204,144,218,154,4,100,130,86,68,
    13,97,118,24,233,123,138,20,205,66,
    101,231,236,50,32,48,229,31,168,172,
    19,133,180,91,36,136,250,183,198,171,
    7,120,155,117,104,15,195,214,132,186,
    145,9,115,244,248,6,92,51,169,238,
    228,223,224,235,25,194,52,239,29,81,
    128,122,49,222,179,28,157,99,142,249,
    111,69,210,114,213,109,80,148,61,232,
    98,181,40,57,251,242,83,85,14,108,
    208,160,200,53,147,182,139,46,3,135,
    255,246,254,125,37,234,95,41,140,73,
    163,127,192,96,241,151,26,113,72,237,
    166,42,253,156,230,62,161,54,82,134,
    247,201,16,178,121,150,12,170,141,162,
    188,240,177,63,217,67,243,34,126,60,
    93,94,174,207,56,202,78,206,197,146,
    71,59,75,30,64,8,159,27,17,23,
    225,74,209,153,77,131,152,143,116,119,
    33,39,193,89,87,0,252,43,158,22,
    149,79,187,216,2,5,11,220,199,106,
    70,102,215,167,175,18,185,211,105,1,
    227,129,55,226,184,76,189,190,107,165,
    90,65,45,221,137,212);

type
  PDWORD = ^DWORD;
  DWORD = Longword;

  //secure hash
  TID = array [0..4] of integer;
  TBD = array [0..19] of Byte;
  
function IDBD(ID: TID): TBD;   // sharesult
function ShB(const dig: Tbd): string;

type
  TSecHash2 = class(TObject)
  private
    klVar, grVar : TID;     // array [0..4] of integer;
    M : array [0..63] of Byte;
    W : array [0..79] of Integer;
    K : array [0..79] of Integer;
    procedure aac;
  public
    function Compute(fe: string): string;
  end;

  TSha1 = class(TObject)
  protected
    PDigest: Pointer;
    PLastBlock: Pointer;
    NumLastBlockBytes: Integer;
    FBlocksDigested: Longint;
    FCompleted: Boolean;
    PChainingVars: Pointer;
    FIsBigEndian: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Transform(const M; NumBytes: Longint);
    procedure Complete;
    procedure SpecialInit(strin: string);
    function HashValue: string;
    function TempHashValue: string;
    function HashValueBytes: Pointer;
   // class function AsString: string; virtual; abstract;
    property BlocksDigested: Longint read FBlocksDigested;
    property Completed: Boolean read FCompleted;
  end;

  function sha1str(const strin: string): string;

type
  TChainingVar = DWORD;
  TSHAChainingVarRange = (shaA, shaB, shaC, shaD, shaE);
  PSHAChainingVarArray = ^TSHAChainingVarArray;
  TSHAChainingVarArray = array [TSHAChainingVarRange] of TChainingVar;
  TSHADigest = array [1..5] of DWORD;
  PSHABlock = ^TSHABlock;
  TSHABlock = array [0..15] of DWORD;

const
  SHAInitialChainingValues: TSHAChainingVarArray = ($67452301, $efcdab89, $98badcfe, $10325476, $c3d2e1f0);

implementation

uses
  Helper_crypt;

type
  TDoubleDWORD = record
    L, H: DWORD;
  end;
  TFourByte = packed record
    B1, B2, B3, B4: Byte;
  end;

procedure TSecHash2.aac;assembler;
asm
   push ebx
   push edi
   push esi
   mov edx, eax            // pointer to Self (instance of SecHash)
   lea esi, [edx].GrVar[0] // Load Address of GrVar[0]
   lea edi, [edx].KlVar[0] // Load Address of KlVar[0]
   mov ecx, 5
   cld
   rep movsd               // copy GrVar[] to KlVar[]
   xor ecx, ecx            // zero ecx
   lea edi, [edx].M[0]     // Load Address of M[0]
   lea esi, [edx].W[0]     // Load Address of W[0]
@@Pie_W_0_15:
   mov eax, [edi+ecx]      // Copy M[0..15] to W[0..15] while changing from
   rol ax, 8               // Little endian to Big endian
   rol eax, 16
   rol ax, 8
   mov [esi+ecx], eax
   add ecx, 4
   cmp ecx, 64            //compare del loop quando exc vale meno di 64 rimane nel loop Pie_W_0_15
   jl @@Pie_W_0_15
   xor ecx, ecx           // zero ecx
   mov edi, esi
   add edi, 64
@@Pie_W_16_79:
   mov eax, [edi+ecx-12]     // W[t] = W[t-3] xor W[t-8] xor W[t-14] xor W[t-16] <<< 1
   xor eax, [edi+ecx-32]
   xor eax, [edi+ecx-56]
   xor eax, [edi+ecx-64]
   rol eax, 1
   mov [edi+ecx], eax
   add ecx, 4
   cmp ecx, 256
   jl @@Pie_W_16_79
   lea edi, [edx].KlVar[0]
   mov ecx, 20
   xor esi, esi              //zero esi
@@B_0_19:
   mov eax, [edi+4]          // t=0..19: TEMP=(a <<< 5)+f[t](b,c,d)
   mov ebx, eax              // f[t](b,c,d) = (b and c) or ((not b) and d)
   and eax, [edi+8]
   not ebx
   and ebx, [edi+12]
   or eax, ebx
   call @@Ft_Common
   add esi, 4
   dec ecx
   jnz @@B_0_19
   mov ecx, 20
@@B_20_39:
   mov eax, [edi+4]          // t=20..39: TEMP=(a <<< 5)+f[t](b,c,d)
   xor eax, [edi+8]          // f[t](b,c,d) = b xor c xor d
   xor eax, [edi+12]
   call @@Ft_Common
   add esi, 4
   dec ecx
   jnz @@B_20_39
   mov ecx, 20
@@B_40_59:
   mov eax, [edi+4]          // t=40..59: TEMP=(a <<< 5)+f[t](b,c,d)
   mov ebx, eax              // f[t](b,c,d) = (b and c) or (b and d) or (c and d)
   and eax, [edi+8]
   and ebx, [edi+12]
   or eax, ebx
   mov ebx, [edi+8]
   and ebx, [edi+12]
   or eax, ebx
   call @@Ft_Common
   add esi, 4
   dec ecx
   jnz @@B_40_59
   mov ecx, 20
@@B_60_79:
   mov eax, [edi+4]          // t=60..79: TEMP=(a <<< 5)+f[t](b,c,d)
   xor eax, [edi+8]          // f[t](b,c,d) = b xor c xor d
   xor eax, [edi+12]
   call @@Ft_Common
   add esi, 4
   dec ecx
   jnz @@B_60_79
   lea esi, [edx].GrVar[0]   // Load Address of GrVar[0]
   mov eax, [edi]            // For i := 0 to 4 do GrVar[i] := GrVar[i]+klVar[i]
   add eax, [esi]
   mov [esi], eax
   mov eax, [edi+4]
   add eax, [esi+4]
   mov [esi+4], eax
   mov eax, [edi+8]
   add eax, [esi+8]
   mov [esi+8], eax
   mov eax, [edi+12]
   add eax, [esi+12]
   mov [esi+12], eax
   mov eax, [edi+16]
   add eax, [esi+16]
   mov [esi+16], eax
   pop esi
   pop edi
   pop ebx
   jmp @@End
@@Ft_Common:
   add eax, [edi+16]         // + e
   lea ebx, [edx].W[0]
   add eax, [ebx+esi]        // + W[t]
   lea ebx, [edx].K[0]
   add eax, [ebx+esi]        // + K[t]
   mov ebx, [edi]
   rol ebx, 5                // ebx = a <<< 5
   add eax, ebx              // eax = (a <<< 5)+f[t](b,c,d)+e+W[t]+K[t]
   mov ebx, [edi+12]
   mov [edi+16], ebx         // e = d
   mov ebx, [edi+8]
   mov [edi+12], ebx         // d = c
   mov ebx, [edi+4]
   rol ebx, 30
   mov [edi+8], ebx          // c = b <<< 30
   mov ebx, [edi]
   mov [edi+4], ebx          // b = a
   mov [edi], eax            // a = TEMP
   ret
@@End:
end;

function TSecHash2.Compute(fe: string): string;
{
input 00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F
result 3B 8B FC 2E 15 4F BD 43 B1 4D C7 A3 D5 E0 90 E9 85 47 61 66
}
var
  st: string;

   function abcc(const strin: string): string;
   var
    byt: Tbd;
    len: Integer;
    BitsLow,BitsHigh,ToCompute : integer;
    done: Cardinal;

       procedure aaaacd;
       var
         i : integer;
       begin
         For i :=  0 to 19 do begin
          K[i]  := $5a827901;
          K[i+20] := $6ed9eba1;
          K[i+40] := $1f1cbcdc;
          K[i+60] := $ca62c1d6;
         end;
          grVar[0] := $17452301;
          grVar[1] := $eacdaf89;
          grVar[2] := $98bfdcfe;
          grVar[3] := $14325476;
          grVar[4] := $c3d2c1f0;
        end;
     begin
      SetLength(result,20); //
      len := length(strin);
      BitsHigh := (len and $FF000000) shr 29;
      BitsLow := len shl 3;

    aaaacd;  //init

      done := 1;
      ToCompute := len;
      While ToCompute>0 do begin
         If ToCompute>=64 then begin
            move(strin[done],m,64);
            inc(done,64);
             aac;
            dec(ToCompute,64);
            If ToCompute=0 then begin
               FillChar(M,sizeof(M),0);
               M[0] := $80;
            end;
         end else begin // ToCompute<64
            FillChar(M,SizeOf(M),0);
            move(strin[done],m,tocompute);
            inc(done,tocompute);
            M[ToCompute] := $80;
            If ToCompute>=56 then begin
               aac;
               FillChar(M,SizeOf(M),0);
            end;
            ToCompute := 0;
         end; //End else ToCompute>=64
         If ToCompute=0 then begin
            M[63] := BitsLow and $000000FF;
            M[62] := (BitsLow and $0000FF00) shr 8;
            M[61] := (BitsLow and $00FF0000) shr 16;
            M[60] := (BitsLow and $FF000000) shr 24;
            M[59] := (BitsHigh and $000000FF);
            aac;
         end;
      end; //End While ToCompute>0

    byt := IDBD(grVar);
    Result := ShB(byt);
  end;

var
i: Integer;
begin
  //-->  input 00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F
  st := fe;
  st[1] := chr(ord(st[2]) xor ord(st[12]) + $431f);  // 29 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F

  for i := 1 to length(st) do st[i] := chr(ord(st[i]) xor td[length(st)-i]); // 68 77 1c a5 e6 15 41 c4 34 42 eb 12 8c ed e1 d8

  st := st+st;
  for i := 1 to length(st) do st[i] := chr(ord(st[i]) xor te[length(st)-i]); // 09 7A 58 F3 64 71 45 5E EE D2 27 34 21 52 F4 D2 9D 54 30 FD B2 2F 9A 60 5A 32 97 3D EB 29 2A 68
   for i := 1 to length(st) do st[i] := chr(ord(st[i]) xor tes[length(st)-i]);  // 06 83 0D 6A 68 10 A9 0D 46 B2 35 69 47 C6 5F D9 46 30 1C 86 05 F9 F7 EA 6C 2A 5D 22 B3 32 62 1B
    for i := 1 to length(st) do st[i] := chr(ord(st[i]) xor byte(tds[i]+ff[i])); // B3 27 2A A5 D3 3F 0F 81 82 F5 AE 42 67 EE 6B 48 9E 54 92 D0 AF AC 8A 4D E8 35 7B 79 AD EF 56 49

  st := st+st;
  st := st+st;
  st := st+st;
  st := st+st; // repeat 16x times (make it a larger string value)

  result := abcc(st);  //hash it the Result 20 byte!
end;

destructor TSha1.Destroy;
begin
  FreeMem(PDigest,20);
  FreeMem(PLastBlock,64);
  FreeMem(PChainingVars,20);

  inherited;
end;

constructor TSha1.create;
begin
  inherited Create;

  //init chaining vars
  GetMem(PChainingVars, 20);
  Move(SHAInitialChainingValues, PChainingVars^, 20);

  //init digest
  GetMem(PLastBlock, 64);
  GetMem(PDigest, 20);
  FillChar(PLastBlock^, 64, 0);
  FillChar(PDigest^, 20, 0);

  NumLastBlockBytes := 0;
  FCompleted := False;
  FBlocksDigested := 0;

  FIsBigEndian := True;
end;

function sha1str(const strin: string): string;
var
 sha1: Tsha1;
begin
  sha1 := tsha1.create;
  if length(strin)>0 then
    sha1.Transform(strin[1],length(strin));
  sha1.complete;
  Result := sha1.HashValue;
  sha1.Free;
end;

procedure TSha1.SpecialInit(strin: string);
begin
  Move(strin[1], PChainingVars^, 20);
end;

procedure TSha1.Transform(const M; NumBytes: Longint);
type
  PSHAExpandedBlock = ^TSHABlock;
  TSHAExpandedBlock = array [0..79] of DWORD;
var
  NumBlocks: Longint;
  P, PLB: ^Byte;
  NumBytesNeeded: Integer;

//////////////trasform sha1
  {Ihi, }Jhi: Integer;
  Blok: PSHABlock;
  Tchv: TChainingVar;
  Ach, Bch, Cch, Dch, Ech: TChainingVar;
  Xexpblk: TSHAExpandedBlock;
  vari:dword;
  cicli: Integer;
/////////////////////////////
begin
  P := Addr(M);

  if NumLastBlockBytes > 0 then begin
    PLB := PLastBlock;
    Inc(PLB, NumLastBlockBytes);
    NumBytesNeeded := 64 - NumLastBlockBytes;
    if NumBytes < NumBytesNeeded then begin
      Move(M, PLB^, NumBytes);
      Inc(NumLastBlockBytes, NumBytes);
      Exit;
    end;
    Move(M, PLB^, NumBytesNeeded);
    Dec(NumBytes, NumBytesNeeded);
    Inc(P, NumBytesNeeded);

    /////////////////////// trasform SHA1
    Move(PLastBlock^, Xexpblk, 64);
    for Jhi := Low(TSHABlock) to High(TSHABlock) do begin
      with TFourByte(Xexpblk[Jhi]) do begin
        Tchv := B1; B1 := B4; B4 := Tchv;
        Tchv := B2; B2 := B3; B3 := Tchv;
      end;
    end;
    for Jhi := 16 to 79 do begin
      vari := Xexpblk[Jhi - 3] xor Xexpblk[Jhi - 8] xor Xexpblk[Jhi - 14] xor Xexpblk[Jhi - 16];
      Xexpblk[Jhi] := DWORD(vari shl 1 or vari shr 31);
    end;
    Ach := PSHAChainingVarArray(PChainingVars)^[shaA];
    Bch := PSHAChainingVarArray(PChainingVars)^[shaB];
    Cch := PSHAChainingVarArray(PChainingVars)^[shaC];
    Dch := PSHAChainingVarArray(PChainingVars)^[shaD];
    Ech := PSHAChainingVarArray(PChainingVars)^[shaE];
    for Jhi := 0 to 19 do begin
      Tchv :=  DWORD(Ach shl 5 or Ach shr 27) + ((Bch and Cch) or (not Bch and Dch)) + Ech + Xexpblk[Jhi] + $5a827999;
      Ech := Dch;
      Dch := Cch;
      Cch :=  DWORD(Bch shl 30 or Bch shr 2);
      Bch := Ach;
      Ach := Tchv;
    end;
    for Jhi := 20 to 39 do begin
      Tchv :=   DWORD(Ach shl 5 or Ach shr 27) + (Bch xor Cch xor Dch) + Ech + Xexpblk[Jhi] + $6ed9eba1;
      Ech := Dch;
      Dch := Cch;
      Cch := DWORD(Bch shl 30 or Bch shr 2);
      Bch := Ach;
      Ach := Tchv;
    end;
    for Jhi := 40 to 59 do begin
      Tchv := DWORD(Ach shl 5 or Ach shr 27) + (Bch and Cch or Bch and Dch or Cch and Dch) + Ech + Xexpblk[Jhi] + $8f1bbcdc;
      Ech := Dch;
      Dch := Cch;
      Cch := DWORD(Bch shl 30 or Bch shr 2);
      Bch := Ach;
      Ach := Tchv;
    end;
    for Jhi := 60 to 79 do begin
      Tchv := DWORD(Ach shl 5 or Ach shr 27) + (Bch xor Cch xor Dch) + Ech + Xexpblk[Jhi] + $ca62c1d6;
      Ech := Dch;
      Dch := Cch;
      Cch := DWORD(Bch shl 30 or Bch shr 2);
      Bch := Ach;
      Ach := Tchv;
    end;
    Inc(PSHAChainingVarArray(PChainingVars)^[shaA], Ach);
    Inc(PSHAChainingVarArray(PChainingVars)^[shaB], Bch);
    Inc(PSHAChainingVarArray(PChainingVars)^[shaC], Cch);
    Inc(PSHAChainingVarArray(PChainingVars)^[shaD], Dch);
    Inc(PSHAChainingVarArray(PChainingVars)^[shaE], Ech);
    Inc(FBlocksDigested);
    ////////////////////////////////////
  end;
  
  NumBlocks := NumBytes div 64;


  //////////////////////////////////////trasform sha1 block
  Blok := Addr(P^);
   for cicli := 1 to NumBlocks do begin
    Move(Blok^, Xexpblk, sizeof(Blok^));
    for Jhi := Low(TSHABlock) to High(TSHABlock) do begin
      with TFourByte(Xexpblk[Jhi]) do begin
        Tchv := B1; B1 := B4; B4 := Tchv;
        Tchv := B2; B2 := B3; B3 := Tchv;
      end;
    end;
    for Jhi := 16 to 79 do begin
      vari := Xexpblk[Jhi - 3] xor Xexpblk[Jhi - 8] xor Xexpblk[Jhi - 14] xor Xexpblk[Jhi - 16];
      Xexpblk[Jhi] := DWORD(vari shl 1 or vari shr 31);
    end;
    Ach := PSHAChainingVarArray(PChainingVars)^[shaA];
    Bch := PSHAChainingVarArray(PChainingVars)^[shaB];
    Cch := PSHAChainingVarArray(PChainingVars)^[shaC];
    Dch := PSHAChainingVarArray(PChainingVars)^[shaD];
    Ech := PSHAChainingVarArray(PChainingVars)^[shaE];
    for Jhi := 0 to 19 do begin
      Tchv :=  DWORD(Ach shl 5 or Ach shr 27) + ((Bch and Cch) or (not Bch and Dch)) + Ech + Xexpblk[Jhi] + $5a827999;
      Ech := Dch;
      Dch := Cch;
      Cch :=  DWORD(Bch shl 30 or Bch shr 2);
      Bch := Ach;
      Ach := Tchv;
    end;
    for Jhi := 20 to 39 do begin
      Tchv :=   DWORD(Ach shl 5 or Ach shr 27) + (Bch xor Cch xor Dch) + Ech + Xexpblk[Jhi] + $6ed9eba1;
      Ech := Dch;
      Dch := Cch;
      Cch := DWORD(Bch shl 30 or Bch shr 2);
      Bch := Ach;
      Ach := Tchv;
    end;
    for Jhi := 40 to 59 do begin
      Tchv := DWORD(Ach shl 5 or Ach shr 27) + (Bch and Cch or Bch and Dch or Cch and Dch) + Ech + Xexpblk[Jhi] + $8f1bbcdc;
      Ech := Dch;
      Dch := Cch;
      Cch := DWORD(Bch shl 30 or Bch shr 2);
      Bch := Ach;
      Ach := Tchv;
    end;
    for Jhi := 60 to 79 do begin
      Tchv := DWORD(Ach shl 5 or Ach shr 27) + (Bch xor Cch xor Dch) + Ech + Xexpblk[Jhi] + $ca62c1d6;
      Ech := Dch;
      Dch := Cch;
      Cch := DWORD(Bch shl 30 or Bch shr 2);
      Bch := Ach;
      Ach := Tchv;
    end;
    inc(Blok);
    Inc(PSHAChainingVarArray(PChainingVars)^[shaA], Ach);
    Inc(PSHAChainingVarArray(PChainingVars)^[shaB], Bch);
    Inc(PSHAChainingVarArray(PChainingVars)^[shaC], Cch);
    Inc(PSHAChainingVarArray(PChainingVars)^[shaD], Dch);
    Inc(PSHAChainingVarArray(PChainingVars)^[shaE], Ech);
   end;
    Inc(FBlocksDigested,NumBlocks);
  /////////////////////////////////////////////////////////
  //TransformSha1Blocks(P^,NumBlocks);

  NumLastBlockBytes := NumBytes mod 64;
  Inc(P, NumBytes - NumLastBlockBytes);
  Move(P^, PLastBlock^, NumLastBlockBytes);
end;

function TSha1.HashValueBytes: Pointer;
begin
  Result := PDigest;
end;

function TSha1.TempHashValue: string;
begin
  SetLength(Result,  20);
  move(PDigest^,result[1],20);
end;

function TSha1.HashValue: string;
begin
  SetLength(Result,  20);
  move(PDigest^,result[1],20);
end;


procedure TSha1.Complete;
type
  PSHAExpandedBlock = ^TSHABlock;
  TSHAExpandedBlock = array [0..79] of DWORD;
var
  NumBytesNeeded: Integer;
  MessageLength: Int64;
  P: ^Byte;
  T: DWORD;
  PD: ^TChainingVar;
  I: Integer;

//////////////trasform sha1
  {Ihi,} Jhi: Integer;
  Tchv: TChainingVar;
  Ach, Bch, Cch, Dch, Ech: TChainingVar;
  Xexpblk: TSHAExpandedBlock;
  vari:dword;
/////////////////////////////
begin
  MessageLength := FBlocksDigested;
  MessageLength := MessageLength * 64;
  MessageLength := MessageLength + NumLastBlockBytes;
  MessageLength := MessageLength * 8;

  P := PLastBlock;
  Inc(P, NumLastBlockBytes);
  P^ := $80; { Set the high bit. }
  Inc(P);
  Inc(NumLastBlockBytes);
  {
   # bytes needed = Block size - # bytes we already have -
                    8 bytes for the message length.
  }
  NumBytesNeeded := 64 - NumLastBlockBytes - SizeOf(MessageLength);
  if NumBytesNeeded < 0 then begin
    { Not enough space to put the message length in this block. }
    FillChar(P^, 64 - NumLastBlockBytes, 0);

    //////////////////////////////////////trasform sha1 block
    Move(PLastBlock^, Xexpblk, 64);
    for Jhi := Low(TSHABlock) to High(TSHABlock) do begin
      with TFourByte(Xexpblk[Jhi]) do begin
        Tchv := B1; B1 := B4; B4 := Tchv;
        Tchv := B2; B2 := B3; B3 := Tchv;
      end;
    end;
    for Jhi := 16 to 79 do begin
      vari := Xexpblk[Jhi - 3] xor Xexpblk[Jhi - 8] xor Xexpblk[Jhi - 14] xor Xexpblk[Jhi - 16];
      Xexpblk[Jhi] := DWORD(vari shl 1 or vari shr 31);
    end;
    Ach := PSHAChainingVarArray(PChainingVars)^[shaA];
    Bch := PSHAChainingVarArray(PChainingVars)^[shaB];
    Cch := PSHAChainingVarArray(PChainingVars)^[shaC];
    Dch := PSHAChainingVarArray(PChainingVars)^[shaD];
    Ech := PSHAChainingVarArray(PChainingVars)^[shaE];
    for Jhi := 0 to 19 do begin
      Tchv :=  DWORD(Ach shl 5 or Ach shr 27) + ((Bch and Cch) or (not Bch and Dch)) + Ech + Xexpblk[Jhi] + $5a827999;
      Ech := Dch;
      Dch := Cch;
      Cch :=  DWORD(Bch shl 30 or Bch shr 2);
      Bch := Ach;
      Ach := Tchv;
    end;
    for Jhi := 20 to 39 do begin
      Tchv :=   DWORD(Ach shl 5 or Ach shr 27) + (Bch xor Cch xor Dch) + Ech + Xexpblk[Jhi] + $6ed9eba1;
      Ech := Dch;
      Dch := Cch;
      Cch := DWORD(Bch shl 30 or Bch shr 2);
      Bch := Ach;
      Ach := Tchv;
    end;
    for Jhi := 40 to 59 do begin
      Tchv := DWORD(Ach shl 5 or Ach shr 27) + (Bch and Cch or Bch and Dch or Cch and Dch) + Ech + Xexpblk[Jhi] + $8f1bbcdc;
      Ech := Dch;
      Dch := Cch;
      Cch := DWORD(Bch shl 30 or Bch shr 2);
      Bch := Ach;
      Ach := Tchv;
    end;
    for Jhi := 60 to 79 do begin
      Tchv := DWORD(Ach shl 5 or Ach shr 27) + (Bch xor Cch xor Dch) + Ech + Xexpblk[Jhi] + $ca62c1d6;
      Ech := Dch;
      Dch := Cch;
      Cch := DWORD(Bch shl 30 or Bch shr 2);
      Bch := Ach;
      Ach := Tchv;
    end;
    Inc(PSHAChainingVarArray(PChainingVars)^[shaA], Ach);
    Inc(PSHAChainingVarArray(PChainingVars)^[shaB], Bch);
    Inc(PSHAChainingVarArray(PChainingVars)^[shaC], Cch);
    Inc(PSHAChainingVarArray(PChainingVars)^[shaD], Dch);
    Inc(PSHAChainingVarArray(PChainingVars)^[shaE], Ech);
    Inc(FBlocksDigested);
  /////////////////////////////////////////////////////////

    { Put it in the next one. }
    NumBytesNeeded := 64 - SizeOf(MessageLength);
    P := PLastBlock;
  end;
  FillChar(P^, NumBytesNeeded, 0);
  Inc(P, NumBytesNeeded);
  if FIsBigEndian then with TDoubleDWORD(MessageLength) do begin
    // Swap the bytes in MessageLength.
    with TFourByte(L) do begin
      T := B1; B1 := B4; B4 := T;
      T := B2; B2 := B3; B3 := T;
    end;
    with TFourByte(H) do begin
      T := B1; B1 := B4; B4 := T;
      T := B2; B2 := B3; B3 := T;
    end;
   //  Swap the DWORDs in MessageLength.
    T := L;
    L := H;
    H := T;
  end;
  Move(MessageLength, P^, SizeOf(MessageLength));

  //////////////////////////////////////trasform sha1 block
    Move(PLastBlock^, Xexpblk, 64);
    for Jhi := Low(TSHABlock) to High(TSHABlock) do begin
      with TFourByte(Xexpblk[Jhi]) do begin
        Tchv := B1; B1 := B4; B4 := Tchv;
        Tchv := B2; B2 := B3; B3 := Tchv;
      end;
    end;
    for Jhi := 16 to 79 do begin
      vari := Xexpblk[Jhi - 3] xor Xexpblk[Jhi - 8] xor Xexpblk[Jhi - 14] xor Xexpblk[Jhi - 16];
      Xexpblk[Jhi] := DWORD(vari shl 1 or vari shr 31);
    end;
    Ach := PSHAChainingVarArray(PChainingVars)^[shaA];
    Bch := PSHAChainingVarArray(PChainingVars)^[shaB];
    Cch := PSHAChainingVarArray(PChainingVars)^[shaC];
    Dch := PSHAChainingVarArray(PChainingVars)^[shaD];
    Ech := PSHAChainingVarArray(PChainingVars)^[shaE];
    for Jhi := 0 to 19 do begin
      Tchv :=  DWORD(Ach shl 5 or Ach shr 27) + ((Bch and Cch) or (not Bch and Dch)) + Ech + Xexpblk[Jhi] + $5a827999;
      Ech := Dch;
      Dch := Cch;
      Cch :=  DWORD(Bch shl 30 or Bch shr 2);
      Bch := Ach;
      Ach := Tchv;
    end;
    for Jhi := 20 to 39 do begin
      Tchv :=   DWORD(Ach shl 5 or Ach shr 27) + (Bch xor Cch xor Dch) + Ech + Xexpblk[Jhi] + $6ed9eba1;
      Ech := Dch;
      Dch := Cch;
      Cch := DWORD(Bch shl 30 or Bch shr 2);
      Bch := Ach;
      Ach := Tchv;
    end;
    for Jhi := 40 to 59 do begin
      Tchv := DWORD(Ach shl 5 or Ach shr 27) + (Bch and Cch or Bch and Dch or Cch and Dch) + Ech + Xexpblk[Jhi] + $8f1bbcdc;
      Ech := Dch;
      Dch := Cch;
      Cch := DWORD(Bch shl 30 or Bch shr 2);
      Bch := Ach;
      Ach := Tchv;
    end;
    for Jhi := 60 to 79 do begin
      Tchv := DWORD(Ach shl 5 or Ach shr 27) + (Bch xor Cch xor Dch) + Ech + Xexpblk[Jhi] + $ca62c1d6;
      Ech := Dch;
      Dch := Cch;
      Cch := DWORD(Bch shl 30 or Bch shr 2);
      Bch := Ach;
      Ach := Tchv;
    end;
    Inc(PSHAChainingVarArray(PChainingVars)^[shaA], Ach);
    Inc(PSHAChainingVarArray(PChainingVars)^[shaB], Bch);
    Inc(PSHAChainingVarArray(PChainingVars)^[shaC], Cch);
    Inc(PSHAChainingVarArray(PChainingVars)^[shaD], Dch);
    Inc(PSHAChainingVarArray(PChainingVars)^[shaE], Ech);
    Inc(FBlocksDigested);
  /////////////////////////////////////////////////////////


  Move(PChainingVars^, PDigest^, 20);
  if FIsBigEndian then begin
    // Swap 'em again.
    PD := PDigest;
    for I := 1 to 20 div SizeOf(PD^) do begin
      with TFourByte(PD^) do begin
        T := B1; B1 := B4; B4 := T;
        T := B2; B2 := B3; B3 := T;
      end;
      Inc(PD);
    end;
  end;

  FCompleted := True;
end;

function ShB(const dig: Tbd): string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to 19 do
    Result := Result + chr(dig[i]);
end;

function IDBD(ID: TID): TBD;   // sharesult
var
  i : integer;
begin
  for i := 0 to 19 do
    Result[i] := (ID[i div 4] shr ((3-(i-(i div 4)*4))*8))and $FF;
end;

end.

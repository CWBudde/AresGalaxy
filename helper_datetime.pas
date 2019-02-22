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
related to datetime, used by many units to visually display formatted time eg: 00:00:00
}

unit helper_datetime;

interface

uses
  Sysutils, Windows;

const
  UnixStartDate : TDateTime = 25569.0;

  TENTHOFSEC = 100;
  SECOND = 1000;
  MINUTE = 60000;
  HOUR = 3600000;
  DAY = 86400000;
  SECONDSPERDAY = 86400;

function UnixToDelphiDateTime(USec: LongInt): TDateTime;
function DelphiDateTimeToUnix(ConvDate: TDateTime):longint;
function Format_Time(secs: Integer): string;
function DelphiDateTimeSince1900(ConvDate: TDateTime):longint;
function time_now: Cardinal;
function HR2S(Hours: Single): Cardinal;
function SEC(Seconds:Integer): Cardinal;
function MIN2S(Minutes: Single): Cardinal;

function DateTimeToUnixTime(const DateTime: TDateTime): Cardinal;
function UnixTimeToDateTime(const UnixTime: Cardinal): TDateTime;

implementation

function DateTimeToUnixTime(const DateTime: TDateTime): Cardinal;
var
  FileTime: TFileTime;
  SystemTime: TSystemTime;
  I: Int64;
begin
  // first convert datetime to Win32 file time
  DateTimeToSystemTime(DateTime, SystemTime);
  SystemTimeToFileTime(SystemTime, FileTime);

  // simple maths to go from Win32 time to Unix time
  I := Int64(FileTime.dwHighDateTime) shl 32 + FileTime.dwLowDateTime;
  Result := (I - 116444736000000000) div Int64(10000000);
end;

function UnixTimeToDateTime(const UnixTime: Cardinal): TDateTime;
var
  FileTime: TFileTime;
  SystemTime: TSystemTime;
  I: Int64;
begin
  // first convert unix time to a Win32 file time
  I := Int64(UnixTime) * Int64(10000000) + 116444736000000000;
  FileTime.dwLowDateTime := DWORD(I);
  FileTime.dwHighDateTime := I shr 32;

  // Now convert to system time
  FileTimeToSystemTime(FileTime,SystemTime);

  // and finally convert the system time to TDateTime
  Result := SystemTimeToDateTime(SystemTime);
end;

function Format_Time(secs: Integer): string;
var
  ore, Minuti, Secondi, Variabile: Integer;
begin
  if secs>0 then
  begin
    if secs<60 then
    begin
      ore := 0;
      Minuti := 0;
      Secondi := secs;
    end
    else
    if secs < 3600 then
    begin
      ore := 0;
      Minuti := (secs div 60);
      Secondi := (secs-((secs div 60)*60));
    end
    else
    begin
      ore := (secs div 3600);
      Variabile := (secs-((secs div 3600)*3600)); //Minuti avanzati
      Minuti := Variabile div 60;
      Secondi := Variabile-((Minuti )* 60);
    end;

    if ore=0 then
      Result := ''
    else
      Result := IntToStr(ore)+':';

    if ((Minuti=0) and (ore=0)) then
      Result := '0:'
    else
    begin
      if Minuti<10 then
      begin
        if ore=0 then
          Result := IntToStr(Minuti)+':'
        else
          Result := Result+'0'+IntToStr(Minuti)+':';
      end
      else
        Result := Result+IntToStr(Minuti)+':';
    end;

    if Secondi<10 then
      Result := Result + '0' + IntToStr(Secondi)
    else
      Result := Result + IntToStr(Secondi);
  end
  else
    Result := '0:00';  // fake tempo se non ho niente nella var
end;

function DelphiDateTimeToUnix(ConvDate: TDateTime): LongInt;
   // Converts Delphi TDateTime to Unix Seconds,
   //  ConvDate = the Date and Time that you want to convert
   //  example:   UnixSeconds := DelphiDateTimeToUnix(Now);
begin
  Result := Round((ConvDate-UnixStartDate) * SECONDSPERDAY);
end;

function UnixToDelphiDateTime(USec: LongInt): TDateTime;
{Converts Unix Seconds to Delphi TDateTime,
   USec = the Unix Date Time that you want to convert
   example:  DelphiTimeDate := UnixToDelphiTimeDate(693596);}
begin
  Result := (Usec / SECONDSPERDAY) + UnixStartDate;
end;

function time_now: Cardinal;
begin
 Result := DelphiDateTimeSince1900(Now);
end;

function HR2S(Hours: Single): Cardinal;
begin
Result := MIN2S(Hours*60);
end;

function SEC(Seconds:Integer): Cardinal;
begin
Result := Seconds;
end;

function MIN2S(Minutes: Single): Cardinal;
begin
Result := Round(Minutes  * 60);
end;

function DelphiDateTimeSince1900(ConvDate: TDateTime):longint;
// Converts Delphi TDateTime to Unix Seconds,
//  ConvDate = the Date and Time that you want to convert
//  example:   UnixSeconds := DelphiDateTimeToUnix(Now);
begin
  Result := Round((ConvDate - 1.5) * 86400);
end;

end.

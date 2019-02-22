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
draw graphs on big hints (used by thread_download and thread_upload)
}

unit helper_graphs;

interface

uses
 graphics,classes;

const
 GRAPH_MAX_HEIGHT=35;

type
precord_graph_sample=^record_graph_sample;
record_graph_sample=record
 sample: Cardinal;
 prev,next:precord_graph_sample;
end;

procedure graphhint_vertical_draw(Acanvas: Tcanvas; posxgrafico: Integer; posygraph: Integer; awidth:integer);
procedure graphint_horizontal_draw(divisore: Integer; acanvas: Tcanvas; posygraph: Integer; awidth:integer);
procedure graphint_draw(acanvas: Tcanvas; posygraph: Integer; FirstSample:precord_graph_sample; awidth:integer);
procedure GraphClearRecords(var FirstGraphSample,LastGraphSample:precord_graph_sample; var NumGraphStats:word);
procedure GraphUpdate(Stats:precord_graph_sample);
procedure GraphIncrement(var FirstGraphSample,LastGraphSample:precord_graph_sample; var NumGraphStats: Word; m_graphWidth: Word; Elapsed:integer);   //il tick del campione grafico
procedure GraphCreateFirstSamples(var FirstGraphSample,LastGraphSample:precord_graph_sample; var NumGraphStats:word);

implementation

uses
 const_ares,vars_global,sysutils,const_timeouts,windows;

procedure GraphCreateFirstSamples(var FirstGraphSample,LastGraphSample:precord_graph_sample; var NumGraphStats:word);
begin
 LastGraphSample := AllocMem(sizeof(record_graph_sample));
 LastGraphSample^.next := nil;
 LastGraphSample^.sample := 0;

 FirstGraphSample := AllocMem(sizeof(record_graph_sample));
 FirstGraphSample^.prev := nil;
 FirstGraphSample^.sample := 0;

 LastGraphSample^.prev := FirstGraphSample;
 FirstGraphSample^.next := LastGraphSample;
 NumGraphStats := 2;
end;

procedure GraphIncrement(var FirstGraphSample,LastGraphSample:precord_graph_sample; var NumGraphStats: Word; m_graphWidth: Word; Elapsed:integer);   //il tick del campione grafico
var
h: Integer;
ris:extended;
act:extended;
sample,prevSample:precord_graph_sample;
begin
try

if LastGraphSample<>nil then
 if FirstGraphSample<>nil then
 while (((m_graphWidth shr 1)<NumGraphStats) and (m_graphWidth>0)) do begin
  sample := LastGraphSample;
  prevSample := sample^.prev;

  FreeMem(sample,sizeof(record_graph_sample));

  sample := prevSample;
  sample^.next := nil;
  LastGraphSample := sample;
  dec(NumGraphStats);
 end;


 if FirstGraphSample^.sample>0 then
  FirstGraphSample^.sample := cardinal(int64(FirstGraphSample^.sample*GRAPH_TICK_TIME) div Elapsed);

   act := FirstGraphSample^.sample;
   ris := 0;

   h := 0;
   sample := FirstGraphSample^.next;
   while (sample<>nil) do begin
     ris := ris+sample^.sample;
     inc(h);
     if h>=5 then break;
     sample := sample^.next;
   end;
   if h>=5 then begin
    ris := ris / 5;
    if FirstGraphSample^.sample=0 then ris := ((ris / 10)*5)
     else ris := ((ris / 10)*9) + (act / 10);
    FirstGraphSample^.sample := trunc(ris);
  end;

   sample := AllocMem(sizeof(record_graph_sample));
    sample^.prev := nil;
    sample^.next := FirstGraphSample;
    sample^.sample := trunc(act);
   FirstGraphSample^.prev := sample;
   FirstGraphSample := sample;
   inc(NumGraphStats);

except
end;
end;

procedure GraphUpdate(Stats:precord_graph_sample);
begin
try
if vars_global.formhint.posygraph=-1 then exit;

// move grid
dec(vars_global.formhint.posXgraph,2);
if vars_global.formhint.posXgraph<=0 then vars_global.formhint.posXgraph := 14;


with vars_global.formhint.bitMapGraph.canvas do begin
 pen.color := vars_global.COLORE_HINT_BG;
 brush.color := vars_global.COLORE_HINT_BG;
 rectangle(0,0,vars_global.formhint.bitMapGraph.width,vars_global.formhint.bitMapGraph.height);
 pen.color := clgray;
 brush.color := vars_global.COLORE_GRAPH_BG;
 rectangle(4,1,vars_global.formhint.bitMapGraph.width-4,vars_global.formhint.bitMapGraph.height-3);
 brush.color := vars_global.COLORE_GRAPH_GRID;
end;

 graphhint_vertical_draw(vars_global.formhint.bitMapGraph.canvas,
                         vars_global.formhint.posXgraph,
                         1,
                         vars_global.formhint.bitMapGraph.width);
 graphint_draw(vars_global.formhint.bitMapGraph.canvas,
               2,
               Stats,
               vars_global.formhint.bitMapGraph.width);

 windows.BitBlt(vars_global.formhint.canvas.Handle,
                1,
                vars_global.formhint.posYgraph,
                vars_global.formhint.bitMapGraph.width,
                vars_global.formhint.bitMapGraph.height,
                vars_global.formhint.bitMapGraph.canvas.Handle,
                0,
                0,
                SRCCOPY);

except
end;
end;

procedure GraphClearRecords(var FirstGraphSample,LastGraphSample:precord_graph_sample; var NumGraphStats:word);
var
sample,nextSample:precord_graph_sample;
begin

sample := FirstGraphSample;
while (sample<>nil) do begin
  nextSample := sample^.next;
   FreeMem(sample,sizeof(record_graph_sample));
  sample := nextSample;
end;

LastGraphSample := nil;
FirstGraphSample := nil;
NumGraphStats := 0;
end;

procedure graphint_draw(acanvas: Tcanvas; posygraph: Integer; FirstSample:precord_graph_sample; awidth:integer);   //qui dobbiamo trovare risorse con numero download adeguato
var
w: Integer;
offsety,divisore: Integer;
amountscaled,massimo: Cardinal;
start: Boolean;
oldpointh: Integer;
sample:precord_graph_sample;
begin
if FirstSample=nil then exit;

try
 massimo := 0;
 //minimo := 50000;

 sample := FirstSample;
 while (sample<>nil) do begin
  if sample^.sample>massimo then massimo := sample^.sample;
  sample := sample^.next;
 end;

inc(massimo,6);

if massimo>GRAPH_MAX_HEIGHT then begin
 divisore := (massimo div (GRAPH_MAX_HEIGHT-5))+1
end else divisore := 1;

graphint_horizontal_draw(divisore,acanvas,posygraph,awidth);

aCanvas.pen.color := COLORE_GRAPH_INK;

start := True;
oldpointh := 0;

offsety := (posygraph+GRAPH_MAX_HEIGHT+2);

w := vars_global.formhint.GraphWidth+4;
acanvas.pen.width := 2;

sample := FirstSample;
while (sample<>nil) do begin

 if sample^.sample>0 then amountscaled := sample^.sample div cardinal(divisore)
  else amountscaled := 0;

 if start then begin
   oldpointh := cardinal(offsety)-amountscaled;
   start := False;
 end;

     acanvas.moveto(w,oldpointh);
     acanvas.lineto(w-2,cardinal(offsety)-amountscaled);

     oldpointh := cardinal(offsety)-amountscaled;

 sample := sample^.next;
 dec(w,2);
end;

 acanvas.moveto(0,0);
 acanvas.pen.width := 1;
except
end;
end;

procedure graphhint_vertical_draw(Acanvas: Tcanvas; posxgrafico: Integer; posygraph: Integer; awidth:integer);
var
offsetx: Integer;
begin

try
offsetx := 5;

repeat
if posxgrafico+offsetx+1>awidth-5 then break;
aCanvas.fillrect(rect( posxgrafico+offsetx, posygraph +1, posxgrafico+1+offsetx, posygraph +39));
inc(offsetx,14);
until (not true);

except
end;
end;

procedure graphint_horizontal_draw(divisore: Integer; acanvas: Tcanvas; posygraph: Integer; awidth:integer);
var
offsety: Integer;
incremento: Byte;
begin
try

if divisore<10 then incremento := 14 else
 if divisore<20 then incremento := 12 else
  if divisore<40 then incremento := 10 else
   if divisore<80 then incremento := 8 else
    if divisore<160 then incremento := 6 else
     incremento := 4;



offsety := 39-incremento; //saltiamo prima riga
repeat
if offsety<1 then break;
 acanvas.fillrect(rect(5,posygraph +offsety,awidth-5,posygraph +offsety+1));
dec(offsety,incremento);
until (not true);
except
end;
end;

end.

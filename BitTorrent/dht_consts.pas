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

*****************************************************************
 The following delphi code is based on Emule (0.46.2.26) Kad's implementation http://emule.sourceforge.net
 and KadC library http://kadc.sourceforge.net/
*****************************************************************
 }

{
Description:
 DHT constants, Ares flavor byte and opcodes have been changed
 to avoid any problem with other existent DHT networks
}

unit dht_consts;

interface

uses
  dht_int160, classes2;

type
  tmdhtsearchtype=(
    UNDEFINED,
    NODE,
		NODECOMPLETE,
		FINDSOURCE
	);

const
  MDHT_TYPE_ERROR=0;
  MDHT_TYPE_QUERY=1;
  MDHT_TYPE_REPLY=2;

  MDHT_K8						                    = 10;
  MDHT_KPINGABLE                         = 4;
  MDHT_KBASE						                  = 4;
  MDHT_KK						                  	= 5;
  MDHT_ALPHA_QUERY	   				            = 3;
  MDHT_LOG_BASE_EXPONENT			            = 5;
  MDHT_SEARCH_LIFETIME				            = 45;
  MDHT_SEARCHNODE_LIFETIME			          = 45;
  MDHT_SEARCHNODECOMP_LIFETIME		        = 10;
  MDHT_SEARCHFINDSOURCE_LIFETIME	        = 80;
  MDHT_SEARCHNODECOMP_TOTAL		          = 10;
  MDHT_SEARCHFINDSOURCE_TOTAL		        = 60;
  MDHT_SEARCH_TOLERANCE = 16777216;


  MDHT_DISCONNECTDELAY	            = 1200;	//20 mins in seconds

  MDHT_ACTION_NONE=0;
  MDHT_PING_REQ=1;
  MDHT_GETPEER_REQ=2;
  MDHT_FINDNODE_REQ=3;
  MDHT_ANNOUNCEPEER_REQ=4;

type
  tmdhtbucket = class(tobject)
    ipC: Cardinal;
    portW: Word;
    id:CU_INT160;
    m_distance:CU_Int160;
    lastcontact: Cardinal;
    lastping: Cardinal;
    m_type: Byte;
    m_expires: Cardinal;
    m_inUse: Cardinal;
    m_rtt: Cardinal;
    m_created: Cardinal;
    m_lastTypeSet: Cardinal;
    constructor create; // Common var initialization goes here
    procedure init(const clientID:pCU_Int160; ip: Cardinal; udpPort: Word; const target:pCU_Int160);
    procedure checkingType;
    procedure updateType;
  end;

  precord_mdht_announced_torrent=^record_mdht_announced_torrent;
  record_mdht_announced_torrent=record
    hash: string;
    last: Cardinal;
    clients: TMyStringList;
  end;

implementation

uses
  helper_datetime;

procedure tmdhtbucket.init(const clientID:pCU_Int160; ip: Cardinal; udpPort: Word; const target:pCU_Int160);
begin
	CU_INT160_Fill(@ID,clientID);
  CU_INT160_FillNXor(@m_distance,@ID,target);
	ipC := ip;
	portW := udpPort;
end;

constructor tmdhtbucket.create;
begin
	m_type := 3;
	m_expires := 0;
	m_lastTypeSet := time_now;
  m_created := m_lastTypeSet;
	m_inUse := 0;
  m_rtt := 0;
end;

procedure tmdhtbucket.checkingType;
begin
	if ((time_now-m_lastTypeSet<10) or
      (m_type=4)) then exit;

	m_lastTypeSet := time_now;

	m_expires := m_lastTypeSet + MIN2S(2);
	inc(m_type);
end;

procedure tmdhtbucket.updateType;
var
hours: Cardinal;
begin

	hours := (time_now-m_created) div HR2S(1);
	case hours of
		0:begin
			m_type := 2;
			m_expires := time_now+HR2S(1);
    end;
		1:begin
			m_type := 1;
			m_expires := time_now+HR2S(1.5);
		end else begin
			m_type := 0;
			m_expires := time_now+HR2S(2);
     end;
  end;

end;


end.

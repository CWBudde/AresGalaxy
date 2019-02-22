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

unit dhtconsts;

interface

const
  OP_DHT_HEADER	   	= $E9; // don't pollute Kad network
  OP_DHT_PACKEDPROT	= $EA;

  OP_MDHT_HEADER = 100;
  OP_MDHT_ENCRYPTED_HEADER = 65;
  OP_MDHT_UKNOWN = 33;


  CMD_DHT_BOOTSTRAP_REQ	      = $50; // send bootstrap nodes
  CMD_DHT_BOOTSTRAP_RES	      = $51;

  CMD_DHT_HELLO_REQ	 	        = $55; // ping pong
  CMD_DHT_HELLO_RES     	    = $56;

  CMD_DHT_REQID		   	        = $60; // find nodes
  CMD_DHT_RESID			          = $61;
  CMD_DHT_REQID2              = $62;

  CMD_DHT_SEARCHKEY_REQ		    = $70; // search and publish
  CMD_DHT_SEARCHKEY_RES		    = $71;
  CMD_DHT_PUBLISHKEY_REQ      = $75;
  CMD_DHT_PUBLISHKEY_RES	    = $76;

  CMD_DHT_SEARCHHASH_REQ		  = $80; // search and publish
  CMD_DHT_SEARCHHASH_RES		  = $81;
  CMD_DHT_PUBLISHHASH_REQ     = $82;
  CMD_DHT_PUBLISHHASH_RES	    = $83;
  CMD_DHT_SEARCHPARTIALHASH_RES = $84;

  CMD_DHT_IPREQ	              = $90;
  CMD_DHT_IPREP	              = $91;
  CMD_DHT_CACHESREQ	          = $92;
  CMD_DHT_CACHESREP	          = $93;
  CMD_DHT_FIREWALLCHECK       = $95;
  CMD_DHT_FIREWALLCHECKINPROG = $96;
  CMD_DHT_FIREWALLCHECKRESULT = $97;

  DHTFIREWALLRESULT_FAILEDCONNECTION =0;
  DHTFIREWALLRESULT_CONNECTED        =1;

  // FIND_ID values (parameter) left unchanged to kademlia values
  ARES_DHT_FIND_VALUE		      = $02;
  ARES_DHT_STORE			        = $04;
  ARES_DHT_FIND_NODE		      = $0B;



  // max number of non-responses before a node is assumed dead or offline
  DHT_MAX_SOURCES_HASH              = 200;
  DHT_MAX_PARTIALSOURCES_HASH       = 100;
  DHT_MAX_RETURNEDKEYWORDFILES      = 200;
  CONTACT_FILE_LIMIT                = 5000;
  DHT_MAX_SHARED_KEYWORDFILES       = 50000;
  DHT_MAX_SHARED_HASHFILES          = 50000;
  DHT_REPUBLISHHASHTIMEms           = 10800000; // 3 hours (milliseconds)
  DHT_REPUBLISHKEYTIMEms     	      = 21600000;	// 6 hours (milliseconds)

  MAX_DHT_OUTSEARCHES               = 6;
  MAX_DHT_HASH_OUTPUBLISHREQS       = 3;
  MAX_DHT_HASH_SEARCHREQS           = 2;
  MAX_DHT_KEY_OUTPUBLISHREQS        = 3;
  SEARCHTOLERANCE				            = 16777216;
  K10						                    = 10;
  KPINGABLE                         = 4;
  KBASE						                  = 4;
  KK						                  	= 5;
  ALPHA_QUERY	   				            = 3;
  LOG_BASE_EXPONENT			            = 5;
  HELLO_TIMEOUT				              = 20;
  SEARCH_JUMPSTART			            = 1;
  SEARCH_LIFETIME				            = 45;
  SEARCHKEYWORD_LIFETIME		        = 45;
  SEARCHNODE_LIFETIME			          = 45;
  SEARCHNODECOMP_LIFETIME		        = 10;
  SEARCHSTOREFILE_LIFETIME	        = 140;
  SEARCHSTOREKEYWORD_LIFETIME	      = 140;
  SEARCHFINDSOURCE_LIFETIME	        = 45;
  SEARCHFILE_TOTAL			            = 300;
  SEARCHKEYWORD_TOTAL			          = 300;
  SEARCHSTOREFILE_TOTAL		          = 10;
  SEARCHSTOREKEYWORD_TOTAL	        = 10;
  SEARCHNODECOMP_TOTAL		          = 10;
  SEARCHFINDSOURCE_TOTAL		        = 20;
  DHT_BOOTSTRAP_INTERVAL            = 15;

  TAG_ID_DHT_STATS         = 0;
  TAG_ID_DHT_TITLE         = 1;
  TAG_ID_DHT_ARTIST        = 2;
  TAG_ID_DHT_ALBUM         = 3;
  TAG_ID_DHT_CATEGORY      = 4;
  TAG_ID_DHT_LANGUAGE      = 5;
  TAG_ID_DHT_DATE          = 6;
  TAG_ID_DHT_PARAM2        = 7;
  TAG_ID_DHT_COMMENTS      = 8;
  TAG_ID_DHT_URL           = 9;
  TAG_ID_DHT_FILENAME      = 10;
  TAG_ID_DHT_KEYWGENRE     = 11;



  SECOND=1;
  MINUTE=60;
  HOUR=3600;

  DHT_DISCONNECTDELAY	            = 1200;	//20 mins

implementation

end.

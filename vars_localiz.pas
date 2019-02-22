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
localized vars, used to display multilanguage strings in the UI
}

unit vars_localiz;

interface

uses
  Classes, SysUtils, Helper_unicode, Registry, const_ares, helper_strings,
  helper_diskio, Windows, CometPageView, ufrm_settings;

const
  MIN_TRANSLATIONTABLE_INDEX=108;
  MAX_TRANSLATIONTABLE_INDEX=844;

type
Tdb_language=array [MIN_TRANSLATIONTABLE_INDEX..MAX_TRANSLATIONTABLE_INDEX] of widestring;

const
db_english_lang: array [MIN_TRANSLATIONTABLE_INDEX..MAX_TRANSLATIONTABLE_INDEX] of string = (
{108}'Filter Executable files and potentially dangerous file types',
{109}'Send',
{110}'Load',
{111}'Clear',
{112}'Avatar',
{113}'Display chat event''s date/time',
{114}'When you are away, you may activate away status. '+const_ares.appname+' replies to private chat requests with an away message. Here you may configure your custom away message.',
{115}'Block all private messages',
{116}'Reply with an away message to private chats',
{117}'Start server',
{118}'Stop server',
{119}'Filesharing',
{120}'Block Emotes',
{121}'Choked',
{122}'Optimistic Unchoke',
{123}'Interested',
{124}'Personal message',
{125}'Keep connection Alive',
{126}'Accept incoming connections on port:',
{127}'upload(s) allowed at once',
{128}'upload(s) per user     (0=no limit)',
{129}'Upload bandwidth (kb/s 0=no limit)',
{130}'Increase on Idle',
{131}'Download bandwidth (kb/s 0=no limit)',
{132}'',
{133}'Downloads are saved into folder:',
{134}'Change folder',
{135}'Restore to default folder',
{136}' Hit ''Start scan'' to scan your system',
{137}'Start scan',
{138}'Stop scan',
{139}'Check all',
{140}'Uncheck all',
{141}'Check folder(s) you want to share with online comunity.',
{142}'Legend',
{143}'This folder isn''t shared, but other child folders are shared.',
{144}'Folder is shared, all files in this folder are shared.',
{145}'',
{146}'My computer is behind a firewall or can''t accept incoming connections',
{147}'',
{148}'',
{149}'Load '+const_ares.appname+' when windows starts',
{150}'Auto-connect to network when I start '+const_ares.appname,
{151}'Start '+const_ares.appname+' minimized',
{152}'Exit '+const_ares.appname+' when I click on close button',
{153}'This screen allows you to select which folder you would like to share, making it available for other comunity''s users. Other users cannot modify content of these folders.',
{154}'',
{155}'',
{156}'',
{157}'',
{158}'Show taskbar button',
{159}'Show ''What I''m listening to''',
{160}'Show status on main window''s caption',
{161}'Show transfer percentage',
{162}'Block large hints',
{163}'Pause video when moving between tabs',
{164}'Ask for confirmation when cancelling downloads',
{165}'',
{166}'',
{167}'',
{168}'',
{169}'',
{170}'',
{171}'',
{172}'',
{173}'',
{174}'',
{175}'',
{176}'',
{177}'',
{178}'',
{179}'',
{180}'',
{181}'',
{182}'',
{183}'',
{184}'',
{185}'',
{186}'',
{187}'',
{188}'',
{189}'',
{190}'',
{191}'',
{192}'',
{193}'Nickname:',
{194}'',
{195}'Ok',
{196}'Cancel',
{197}'Apply',
{198}'',
{199}'Close',
{200}'Search for text',
{201}'Audio Files',
{202}'Video Files',
{203}'Playlist Files',
{204}'Any File',
{205}'Clear Search History',
{206}'Advanced search',
{207}'',
{208}'Simple search',
{209}'',
{210}'Found',
{211}'Main',
{212}'Connect',
{213}'Disconnect',
{214}'Preferences',
{215}'',
{216}'',
{217}'Search Field',
{218}'',
{219}'',
{220}'',
{221}'',
{222}'',
{223}'',
{224}'',
{225}'',
{226}'',
{227}'',
{228}'',
{229}'',
{230}'Library',
{231}'Share and Organize your Media',
{232}'Search',
{233}'Search for Files on '+const_ares.appname+' Network',
{234}'Transfer',
{235}'Progress of Downloads and Uploads',
{236}'Web',
{237}'Browse the Internet',
{238}'Screen',
{239}'Play your Media',
{240}'Chat',
{241}'Meet new friends in '+const_ares.appname+' chat',
{242}'Fullscreen',
{243}'Set fullscreen mode',
{244}'',
{245}'',
{246}'',
{247}'',
{248}'Original size',
{249}'Fit to screen/Set to original video size',
{250}'Exit channel',
{251}'Refresh list',
{252}'Join channel',
{253}'Send a private message',
{254}'Browse user''s files',
{255}'Host your Channel',
{256}'Share Settings - Click here to configure shared folders',
{257}'Rescan your library',
{258}'Folders',
{259}'Show/Hide folders',
{260}'Details',
{261}'Show/Hide details',
{262}'Share/Unshare',
{263}'Delete file',
{264}'Add file to playlist',
{265}'Reconnect to host',
{266}'File',
{267}'Send File',
{268}'Accept Incoming Files',
{269}'Show Transfers',
{270}'Hide Transfers',
{271}'Edit',
{272}'Select All',
{273}'Copy',
{274}'Save to disk',
{275}'',
{276}'Set me Away',
{277}'Block this Host',
{278}'Cancell All',
{279}'Connecting to host, please wait...',
{280}'Connection established',
{281}'Connection closed by remote peer',
{282}'Remote host unreachable',
{283}'Ok open it!',
{284}'Generating preview',
{285}'Copying file',
{286}'Mute',
{287}'',
{288}'',
{289}'Cancel',
{290}'Cancel selected transfer',
{291}'Pause/Resume',
{292}'Pause/Resume selected download',
{293}'Play/Preview',
{294}'Play/Preview selected file',
{295}'Locate file',
{296}'Locate selected file/Open incoming file folder',
{297}'Clear Idle',
{298}'Clear completed/cancelled transfers',
{299}'Add file to playlist',
{300}'Add folder to playlist',
{301}'Remove selected file',
{302}'Clear playlist',
{303}'Load/Save playlist',
{304}'',
{305}'Load playlist',
{306}'Save playlist',
{307}'Remove All',
{308}'Remove Selected',
{309}'Sort',
{310}'Alpha-sort ascending',
{311}'Alpha-sort descending',
{312}'Shuffle list',
{313}'',
{314}'Shuffle',
{315}'Repeat',
{316}'New search',
{317}'Make a new search',
{318}'Download',
{319}'Download selected file',
{320}'',
{321}'Show/Hide Search Field',
{322}'Back',
{323}'Forward',
{324}'Stop',
{325}'Refresh',
{326}'Play',
{327}'Pause',
{328}'Previous',
{329}'Next',
{330}'Volume',
{331}'Show playlist',
{332}'Close playlist',
{333}'',
{334}'',
{335}'Playlist',
{336}'Hide details',
{337}'Shared',
{338}'Hide folders',
{339}'Check to share file, uncheck to unshare this file',
{340}'in queue',
{341}'Try also',
{342}'Personal details',
{343}'',
{344}'',
{345}'',
{346}'',
{347}'',
{348}'Transfer',
{349}'',
{350}'Chat',
{351}'Private messages',
{352}'Not connected',
{353}'File posting',
{354}'Private messages',
{355}'Fileshare',
{356}'Auto-scan',
{357}'Manual configure',
{358}'Download folder',
{359}'General',
{360}'Network',
{361}'connected as',
{362}'',
{363}'Files',
{364}'files',
{365}'Unable to connect',
{366}'Last seen',
{367}'Availability',
{368}'Connecting',
{369}'Connecting to network',
{370}'',
{371}'',
{372}'Connected, handshaking...',
{373}' Browse failed',
{374}'',
{375}'Handshake error, blocking connection',
{376}'no directories found',
{377}'Scan completed',
{378}'directory found',
{379}'Performing search, please wait...',
{380}'Search finished without any result',
{381}'Would you like to choose your nickname now?',
{382}'',
{383}'Are you sure you want to erase search history?',
{384}'Erase search history',
{385}'',
{386}'',
{387}'',
{388}'',
{389}'',
{390}'Your chat party wants to send you one or more files, would you like to start the file session?',
{391}'Incoming file session',
{392}'',
{393}'',
{394}'',
{395}'',
{396}'',
{397}'',
{398}'Are you sure you want to cancel download?',
{399}'Cancel Download',
{400}'',
{401}'',
{402}'',
{403}'',
{404}'',
{405}'',
{406}'',
{407}'directories found',
{408}'Handshake error, connection reset by peer',
{409}'Handshake error, timeout waiting for peer reply',
{410}'Disconnected',
{411}'Disconnected, buffer overflow',
{412}'Logged in, retrieving user''s list...',
{413}'Topic changed',
{414}'sharing',
{415}'files, has joined',
{416}'has parted',
{417}'Disconnected, send timeout',
{418}'You are muzzled',
{419}'Images & Videos',
{420}'Downloaded',
{421}'Hosted channel',
{422}'Channel',
{423}'Shared size',
{424}'Total size',
{425}'queued',
{426}'Queued',
{427}'',
{428}'Channel name:',
{429}'Wrong name',
{430}'Please choose one with at least 4 character',
{431}'',
{432}'',
{433}'',
{434}'Connecting to remote channel',
{435}'Free slots',
{436}'KB/sec',
{437}'You are already hosting a chat channel called',
{438}'FILE NOT SHARED',
{439}'There''s no undo feature',
{440}'WARNING, harddisk file erase',
{441}'Delete file',
{442}'Delete files',
{443}'Transmitted',
{444}'File transfer already in progress',
{445}'Please take a look to transfer tab',
{446}'Duplicated request',
{447}'Selected file is already in your library',
{448}'Please take a look to library tab',
{449}'Duplicated file',
{450}'This media type is filtered',
{451}'Filtered Media',
{452}'Hide '+const_ares.appname,
{453}'Show '+const_ares.appname,
{454}'result for',
{455}'results for',
{456}'my shared folder',
{457}'',
{458}'please wait...',
{459}'*THIS FILE IS ALREADY IN YOUR LIBRARY*',
{460}'*YOU ARE ALREADY DOWNLOADING THIS FILE*',
{461}'Processing',
{462}'Paused',
{463}'',
{464}'Leech Paused',
{465}'Cancelled',
{466}'Completed',
{467}'Downloading',
{468}'Idle',
{469}'Searching',
{470}'Connecting',
{471}'WARNING',
{472}'Searching',
{473}'Users',
{474}'Connecting to remote user',
{475}'Chat - connecting to remote host',
{476}'You',
{477}'banned (it will be unbanned when you restart the program)',
{478}' Searching for',
{479}'anything',
{480}'Hash priority',
{481}'Server queue',
{482}'Highest',
{483}'Higher',
{484}'Normal',
{485}'Lower',
{486}'Lowest',
{487}'Ignore/Unignore',
{488}'Muzzle',
{489}'Unmuzzle',
{490}'Ban',
{491}'Unban',
{492}'Kill',
{493}'',
{494}'Share Settings',
{495}'Open/Play',
{496}'Open External',
{497}'Locate File',
{498}'Search for files containing text:',
{499}'Find more from the same',
{500}'Pause All/Unpause All',
{501}'View Playlist',
{502}'Quit '+const_ares.appname,
{503}'',
{504}'Block User',
{505}'Unshare File',
{506}'Fit to Screen',
{507}'',
{508}'Stop Search',
{509}'Select All',
{510}'Copy to Clipboard',
{511}'Save to disk',
{512}'Search Now',
{513}'Date',
{514}'Show queue',
{515}'See who''s in your queue',
{516}'Show upload',
{517}'See uploads',
{518}'Filter',
{519}'Regular View',
{520}'Virtual View',
{521}'Show the library in virtual view',
{522}'Show the library in regular view',
{523}'User',
{524}'Title',
{525}'Artist',
{526}'Quality',
{527}'Year',
{528}'Version',
{529}'Filetype',
{530}'Colours',
{531}'Author',
{532}'Folder',
{533}'Length',
{534}'received',
{535}'sent',
{536}'Resolution',
{537}'Media Type',
{538}'Language',
{539}'Category',
{540}'Download',
{541}'Scan in progress',
{542}'Upload',
{543}'Uploads',
{544}'Downloads',
{545}'Album',
{546}'Company',
{547}'Date',
{548}'Requested size',
{549}'File size',
{550}'Size',
{551}'Format',
{552}'Filename',
{553}'URL',
{554}'Name',
{555}'Topic',
{556}'Welcome to the ',
{557}' channel',
{558}'Speed',
{559}'Group by Album',
{560}'Group by Author',
{561}'Group by Artist',
{562}'Group by Category',
{563}'Group by Company',
{564}'Group by Genre',
{565}'All',
{566}'Audio',
{567}'Video',
{568}'Image',
{569}'Document',
{570}'Other',
{571}'Software',
{572}'',
{573}'',
{574}'',
{575}'',
{576}'',
{577}'',
{578}'',
{579}'',
{580}'',
{581}'Shared virtual folders',
{582}'Shared folders',
{583}'Shared files',
{584}'Your library',
{585}'Search for Video files',
{586}'Search for Audio files',
{587}'Search for generic media',
{588}'Search for Image files',
{589}'Search for Documents',
{590}'Search for Softwares',
{591}'',
{592}'',
{593}'',
{594}'Type',
{595}'File',
{596}'Uploaded',
{597}'Status',
{598}'Media Type',
{599}'Location',
{600}'Requested',
{601}'today',
{602}'total',
{603}'Genre',
{604}'Remaining',
{605}'Progress',
{606}'Total transfer speed',
{607}'Comments',
{608}'Estimated time remaining',
{609}'Volume transmitted',
{610}'Volume downloaded',
{611}'Number of sources',
{612}'sources',
{613}'source',
{614}'Bandwidth',
{615}'Unknown',
{616}'unknown',
{617}'of',
{618}'Uploading',
{619}'',
{620}'',
{621}'',
{622}'',
{623}'',
{624}'',
{625}'',
{626}'',
{627}'',
{628}'',
{629}'',
{630}'',
{631}'on',
{632}'from',
{633}'',
{634}'',
{635}'',
{636}'',
{637}'',
{638}'',
{639}'',
{640}'',
{641}'',
{642}'',
{643}'',
{644}'',
{645}'',
{646}'',
{647}'',
{648}'',
{649}'',
{650}'',
{651}'',
{652}'',
{653}'',
{654}'',
{655}'',
{656}'',
{657}'',
{658}'',
{659}'',
{660}'',
{661}'',
{662}'',
{663}'',
{664}'',
{665}'',
{666}'',
{667}'',
{668}'',
{669}'',
{670}'',
{671}'',
{672}'',
{673}'',
{674}'',
{675}'',
{676}'',
{677}'',
{678}'',
{679}'',
{680}'',
{681}'',
{682}'',
{683}'Clear screen',
{684}'',
{685}'',
{686}'',
{687}'',
{688}'',
{689}'',
{690}'',
{691}'',
{692}'',
{693}'Age',
{694}'Sex',
{695}'Country',
{696}'State/City',
{697}'Male',
{698}'Female',
{699}'Preferred Language',
{700}'Channels',
{701}'Shared',
{702}'',
{703}'Retrieving list, please wait...',
{704}'List empty, please try later',
{705}'Scanning',
{706}'',
{707}'',
{708}'sharing',
{709}'files',
{710}'connected as',
{711}'Hide search field',
{712}'Available space',
{713}'Browse in progress:',
{714}'Browse completed:',
{715}'Poor',
{716}'Average',
{717}'Good',
{718}'Very good',
{719}'Scanning is now taking place in your '+const_ares.appname+' program.'+CRLF+CRLF+'When '+const_ares.appname+' finds new media in your shared folders, it must compute an unique Hash identifier for each new file.'+
     'This operation may take a while, depending on the size of files to be hashed and speed of your computer.'+CRLF+CRLF+'You can see which file is being hashed right above here.'+
     'You can also modify the priority '+const_ares.appname+' gives to hashing.'+CRLF+'Be aware that chosing high thread priority shorten time needed to compute hash values, but may slow down your computer.'+CRLF+
     'We are glad you have chosen '+const_ares.appname+' as your peer to peer program.',
{720}'Hash calculation in progress',
{721}'Media search in progress ',
{722}'',
{723}'',
{724}'Cancel upload',
{725}'Other',
{726}'Audio',
{727}'Software',
{728}'Video',
{729}'Document',
{730}'Image',
{731}'Started',
{732}'Available sources',
{733}'Actual progress',
{734}'Total tries',
{735}'Retry interval',
{736}'Last request',
{737}'',
{738}'Expiration',
{739}'',
{740}'',
{741}'Save As',
{742}'At least',
{743}'At best',
{744}'Equal to',
{745}'Circa',
{746}'Longer than',
{747}'Shorter than',
{748}'Smaller than',
{749}'Bigger than',
{750}'Locally paused',
{751}'download(s) allowed at once',
{752}'Unknown command',
{753}'Proxy',
{754}'',
{755}'Don''t use proxy',
{756}'Use Sock4 proxy',
{757}'Use Sock5 proxy',
{758}'Proxy server address',
{759}'Username',
{760}'Password',
{761}'Remote user is browsing your library',
{762}'Allow browse of my library',
{763}'',
{764}'',
{765}'',
{766}'Direct chat',
{767}'Send folder',
{768}'Offline',
{769}'Channel Search',
{770}'Grant slot',
{771}'Browse failed, list unavailable',
{772}'Shareable File Types',
{773}'',
{774}'',
{775}'Download HashLink',
{776}'Insert HashLink here',
{777}'Export HashLink',
{778}'File Corrupted',
{779}'File Access Error',
{780}'',
{781}'',
{782}'',
{783}'',
{784}'',
{785}'Grant browse',
{786}'',
{787}'Downloaded on',
{788}'Recent downloads',
{789}'Allow regular folder browse',
{790}'Open folder',
{791}'Auto accept files',
{792}'',
{793}'',
{794}'',
{795}'Hashlinks',
{796}'Handle Ed2k links',
{797}'Handle Magnet links',
{798}'',
{799}'Control Panel',
{800}'Configure and control your '+const_ares.appname,
{801}'Check connection',
{802}'Testing...',
{803}'Test failed',
{804}'Test passed',
{805}'Proxy bouncer',
{806}'Currently using',
{807}'Load list',
{808}'Save list',
{809}'Use multiple proxy servers',
{810}'New tab',
{811}'Go',
{812}'Show Join/Part notice',
{813}'Favorites',
{814}'Add to Favorites',
{815}'Last',
{816}'Search for Other files',
{817}'Disconnect source',
{818}'You are about to open a potentially dangerous file type. The file may contain a virus or trojan.'+CRLF+'Are you sure you want to continue?',
{819}'Busy',
{820}'Chatroom',
{821}'Pushing',
{822}'Waiting for peer',
{823}'Requesting',
{824}'Auto Join',
{825}'Connected',
{826}'Auto add to favorites',
{827}'Make '+const_ares.appname+' my default torrent client',
{828}'Active',
{829}'Save to Disk',
{830}'New Radio',
{831}'Handle m3u and pls files',
{832}'Directory', {shoutcast stations}
{833}'Enable/Disable Audio',
{834}'Speak',
{835}'Recording',
{836}'sent by',
{837}'Send Picture',
{838}'Play AudioClip',
{839}'Save AudioClip',
{840}'Template download failed',
{841}'Copy Link Location',
{842}'has joined',
{843}'Join channel with remote template',
{844}'Join channel without template'
);


STR_FILTERPOTENTIALYDANGEROUS=108;
STR_SEND_DIRECTCHAT=109;
STR_LOAD=110;
STR_CLEAR=111;
STR_AVATAR=112;
STR_CONF_CHATTIME=113;
STR_CONF_PVT_TIP=114;
STR_CONF_BLOCK_PVT=115;
STR_CONF_PVTAWAY=116;
STR_CONF_CHAT_STARTSERVER=117;
STR_CONF_CHAT_STOPSERVER=118;
STR_FILESHARING=119;
STR_CONF_BLOCK_EMOTES=120;
STR_TORRENT_CHOKED=121;
STR_TORRENT_OPTUNCHOKE=122;
STR_TORRENT_INTERESTED=123;
STR_PERSONAL_MESSAGE=124;
STR_KEEP_ALIVE_CONNECTION=125;
STR_CONF_ACCEPTPORT=126;
STR_CONF_UPATONCE=127;
STR_CONF_UPPERUSER=128;
STR_CONF_UPBAND=129;
STR_CONF_INCREASEONIDLE=130;
STR_CONF_DLBAND=131;
STR_CONF_SAVEINFOLD=133;
STR_CONF_CHANGEFOLD=134;
STR_CONF_RESTOREDETAULDLFOLDER=135;
STR_HIT_START_TOBEGIN=136;
STR_CONF_START_SCAN=137;
STR_CONF_STOP_SCAN=138;
STR_CONF_CHECKALL=139;
STR_CONF_UNCHECKALL=140;
STR_CONF_MANUALFILESHARE_TIP=141;
STR_CONF_LEGEND=142;
STR_CONF_THISFOLDERNOTSHARE=143;
STR_CONF_THISFOLDERSHARED=144;
STR_CONF_CANTSUPERNODE=146;
STR_CONF_GENERAL_TIP=148;
STR_CONF_HKEYSETTINGS=149;
STR_CONF_AUTOCONNECT=150;
STR_CONF_STARTMINIM=151;
STR_CONF_CLOSEARESWHENSHUT=152;
STR_CONF_FILESHARE_TIP=153;
STR_CONT_SHOWCHATTASKBTN=158;
STR_CONF_WHATSONG=159;
STR_CONF_SHOWSPECCAPT=160;
STR_CONF_SHOWTRANPERCENT=161;
STR_CONF_BLOCKLARGEHINTS=162;
STR_CONF_PAUSEVIDEOWHENMOVING=163;
STR_CONF_ASKWHENCANCELLINGDL=164;
STR_CONF_NICKNAME=193;
STR_OK=195;
STR_CANCEL=196;
STR_APPLY=197;
STR_CLOSE=199;
STR_SEARCHFORTEXT=200;
STR_AUDIO_FILES=201;
STR_VIDEO_FILES=202;
STR_PLAYLIST_FILES=203;
STR_ANY_FILE=204;
PURGE_SEARCH_STR=205;
MORE_SEARCH_OPTION_STR=206;
LESS_SEARCH_OPTION_STR=208;
STR_FOUND=210;
STR_MAIN_MENU=211;
STR_MAIN_CONNECT_MENU=212;
STR_MAIN_DISCONNECT_MENU=213;
STR_MAIN_PREFERENCES_MENU=214;
STR_VIEW_SEARCHFIELD_MENU=217;
STR_LIBRARY=230;
STR_HINT_BTN_LIBRARY=231;
STR_SEARCH=232;
STR_HINT_BTN_SEARCH=233;
STR_TRANSFER=234;
STR_HINT_BTN_TRANSFER=235;
STR_WEB=236;
STR_HINT_BTN_WEB=237;
STR_SCREEN=238;
STR_HINT_BTN_SCREEN=239;
STR_CHAT=240;
STR_HINT_CHAT_BTN=241;
STR_FULLSCREEN=242;
STR_HINT_FULLSCREEN=243;
STR_ACTUALSIZE=248;
STR_HINT_ACTUALSIZE=249;
STR_EXIT_CHANNEL=250;
STR_REFRESH_LIST=251;
STR_JOIN_CHANNEL=252;
STR_PVT_HINT=253;
STR_BRS_HINT=254;
STR_HOST_A_CHANNEL=255;
STR_HINT_SHARESETTING=256;
STR_HINT_REFRESH_LIBRARY=257;
STR_FOLDERS=258;
STR_HINT_FOLDERS=259;
STR_DETAILS=260;
STR_HINT_DETAILS=261;
STR_HINT_SHAREUN=262;
STR_HINT_DELETEFILE=263;
STR_HINT_ADDTOPLAYLIST=264;
STR_RECONNECTTOHOST_MENU=265;
STR_FILE_MENU=266;
STR_SENDFILE_MENU=267;
STR_ACCEPTINCOMIN_MENU=268;
STR_SHOWTRANSFERS_MENU=269;
STR_HIDETRANSFERS_MENU=270;
STR_EDIT_MENU=271;
STR_SELECTALL_MENU=272;
STR_COPY_MENU=273;
STR_OPENINNOTEPAD_MENU=274;
STR_SETMEAWAY_MENU=276;
STR_BLOCKTHISHOST_MENU=277;
STR_CANCELLALL_MENU=278;
STR_CONNECTING_PLEASE_WAIT=279;
STR_CONNECTION_ESTABLISHED=280;
STR_CONNECTIONCLOSED=281;
STR_FEAILED_TO_CONNECT=282;
STR_OKOPENIT=283;
STR_GENERATING_PREVIEW=284;
STR_COPYINGFILE=285;
STR_MUTE=286;
STR_CANCEL_TRANSFER=289;
STR_HINT_CANCEL_TRANSFER=290;
STR_PAUSE_RESUME=291;
STR_HINT_PAUSE_RESUME=292;
STR_PLAYPREVIEW=293;
STR_HINT_PLAYPREVIEW=294;
STR_LOCATE_FILE=295;
STR_HINT_LOCATE_FILE=296;
STR_CLEARIDLE=297;
STR_HINT_CLEARIDLE=298;
STR_ADD_FILETOPLAYLIST=299;
STR_ADD_FOLDERTOPLAYLIST=300;
STR_DELETEFILEFROMPLAYLIST=301;
STR_CLEARPLAYLIST=302;
STR_LOADSAVEPLAYLIST=303;
STR_LOADPLAYLIST=305;
STR_SAVEPLAYLIST=306;
STR_REMOVEALL=307;
STR_REMOVESELECTED=308;
STR_SORT=309;
STR_ALPHASORTASCENDING=310;
STR_ALPHASORTDESCENDING=311;
STR_SHUFFLELIST=312;
STR_SHUFFLE=314;
STR_REPEAT=315;
STR_NEW_SEARCH=316;
STR_HINT_NEW_SEARCH=317;
STR_DOWNLOAD_BTN=318;
STR_HINT_DOWNLOAD_BTN=319;
STR_HINT_SEARCHFIELD_BTN=321;
STR_BACK=322;
STR_FORWARD=323;
STR_STOP=324;
STR_REFRESH=325;
STR_PLAY=326;
STR_PAUSE=327;
STR_PREVIOUS=328;
STR_NEXT=329;
STR_VOLUME=330;
STR_SHOW_PLAYLIST=331;
STR_CLOSE_PLAYLIST=332;
STR_PLAYLIST=335;
STR_HIDE_DETAILS=336;
STR_SHARED=337;
STR_HIDE_FOLDERS=338;
STR_IN_QUEUE=340;
STR_RELATED_ARTISTS=341;
STR_CONFIG_PERSONAL_DETAIL=342;
STR_CONFIG_TRANSFER=348;
STR_CONFIG_CHAT=350;
STR_NOT_CONNECTED=352;
STR_CONFIG_PRIVATE_MSG=354;
STR_CONFIG_FILESHARE=355;
STR_CONFIG_SHARE_SYSTEMSCAN=356;
STR_CONFIG_SHARE_MANUAL=357;
STR_CONFIG_SHARE_DOWNLOAD_FOLDER=358;
STR_CONFIG_GENERAL=359;
STR_CONFIG_NETWORK=360;
STR_FILES_CHAT=363;
STR_FILES_STAT=364;
STR_UNABLE_TO_CONNECT=365;
STR_LAST_SEEN=366;
STR_AVAILIBILITY=367;
STR_CONNECTING_TO_NETWORK=368;
STR_CONNECTING_TO_SUPERNODE=369;
STR_CONNECTED_HANDSHAKING=372;
STR_BROWSE_FAILED=373;
STR_SOCKET_CANALE_FAILED_HANDSHAKE_BLOCKING=375;
STR_NO_DIR_FOUND=376;
STR_SCAN_COMPLETED=377;
STR_DIRECTORY_FOUND=378;
STR_SEARCHING_THE_NET=379;
STR_SEARCHING_THE_NET_NO_RESULT=380;
STR_WOULD_YOU_LIKE_TO_CHOSE_NICK=381;
STR_CHOSE_YOUR_NICK=382;
STR_SURE_TO_ERASE_HISTORY=383;
STR_ERASE_HISTORY=384;
STR_WARNING_INCOMING_FILE=390;
STR_INCOMING_FILE=391;
STR_ARES_YOU_SURETOCANCEL=398;
STR_CANCEL_DL=399;
STR_DIRECTORY_FOUNDS=407;
STR_SOCKET_CANALE_FAILED_HANDSHAKE_RESET=408;
STR_SOCKET_CANALE_FAILED_HANDSHAKE_TIMEOUT=409;
STR_DISCONNECTED=410;
STR_DISCONNECTED_OVERFLOW=411;
STR_LOGGED_IN_RETRIEVING_LIST=412;
STR_TOPIC_CHANGED=413;
STR_SHARING_CHAT=414;
STR_FILES_HAS_JOINED=415;
STR_HAS_PARTED=416;
STR_DISCONNECTED_SEND_TIMEOUT=417;
STR_YOUR_ARE_MUZZLED=418;
STR_IMAGE_AND_VIDEOS=419;
STR_DOWNLOADED=420;
STR_HOSTED_CHANNEL=421;
STR_CHANNEL=422;
STR_SHARED_SIZE=423;
STR_TOTAL_SIZE=424;
STR_QUEUED_HINT=425;
STR_QUEUED_STATUS=426;
STR_CHANNEL_NAME=428;
STR_WRONG_NAME=429;
STR_PLEASE_CHOSE_ANOTHER_NAME=430;
STR_CONNECTING_TO_REMOTE_CHAN=434;
STR_KB_SEC=436;
STR_YOUR_ARE_ALREADY_HOSTING=437;
STR_THERES_NO_UNDO=439;
STR_WARNING_HD_ERASE=440;
STR_DELETE_FILE=441;
STR_DELETE_FILES=442;
STR_TRANSMITTED=443;
STR_TRANSFER_ALREADY_IN_PROGRESS=444;
STR_TAKE_A_LOOK_TO_TRANSFER_TAB=445;
STR_DUPLICATE_REQUEST=446;
STR_FILE_ALREADY_IN_LIBRARY=447;
STR_TAKE_A_LOOK_TO_YOUR_LIBRARY=448;
STR_DUPLICATE_FILE=449;
STR_ARES_IS_CONFIGURED_TO_BLOCK_THIS=450;
STR_FILTERED_MEDIATYPE=451;
STR_HIDE_ARES=452;
STR_SHOW_ARES=453;
STR_RESULT_FOR=454;
STR_RESULTS_FOR=455;
STR_PLEASE_WAIT=458;
STR_ALREADY_IN_LIB=459;
STR_ALREADY_DOWNLOADING=460;
STR_PROCESSING=461;
STR_PAUSED=462;
STR_LEECH_PAUSED=464;
STR_CANCELLED=465;
STR_COMPLETED=466;
STR_DOWNLOADING=467;
STR_IDLE=468;
STR_SEARCHING=469;
STR_CONNECTING=470;
STR_WARNING=471;
STR_MORE_SOURCES_NEEDED=47;
STR_USERS=473;
STR_CONNECTING_TO_REMOTE_USER=474;
STR_CHAT_CONNECTING=475;
STR_YOU=476;
STR_BANNED_HINT=477;
STR_SEARCHING_FOR=478;
STR_ANYTHING=479;
STR_HASH_PRIORITY=480;
STR_SERVER_QUEUE=481;
STR_HIGHEST=482;
STR_HIGHER=483;
STR_NORMAL=484;
STR_LOWER=485;
STR_LOWERST=486;
STR_IGNOREUN=487;
STR_MUZZLE=488;
STR_UNMUZZLE=489;
STR_BAN=490;
STR_UNBAN=491;
STR_KILL=492;
STR_SHARESETTING=494;
STR_OPENPLAY=495;
STR_OPENEXTERNAL=496;
STR_LOCATEFILE=497;
STR_FORTEXT=498;
STR_FINDMOREOFTHESAME=499;
STR_PAUSE_RESUMEALL=500;
STR_VIEW_PLAYLIST=501;
STR_QUITARES=502;
STR_BLOCKUSER=504;
STR_UNSHAREFILE=505;
STR_FITTOSCREEN=506;
STR_STOPSEARCH=508;
STR_SELECTALL_POPUP=509;
STR_COPYTOCLIP_POPUP=510;
STR_OPENINNOTEPAD_POPUP=511;
STR_SEARCHNOW=512;
STR_DATE=513;
STR_SHOW_QUEUE=514;
STR_HINT_SHOW_QUEUE=515;
STR_SHOW_UPLOAD=516;
STR_SHOW_UPLOAD_HINT=517;
STR_FILTER=518;
STR_REGULAR_VIEW=519;
STR_VIRTUAL_VIEW=520;
STR_VIRTUAL_VIEW_HINT=521;
STR_REGULAR_VIEW_HINT=522;
STR_USER=523;
STR_TITLE=524;
STR_ARTIST=525;
STR_QUALITY=526;
STR_YEAR=527;
STR_VERSION=528;
STR_FILETYPE=529;
STR_COLOURS=530;
STR_AUTHOR=531;
STR_FOLDER=532;
STR_LENGTH=533;
STR_RECEIVED=534;
STR_SENT=535;
STR_RESOLUTION=536;
STR_MEDIATYPE=537;
STR_LANGUAGE=538;
STR_CATEGORY=539;
STR_DOWNLOAD=540;
STR_SCAN_IN_PROGRESS=541;
STR_UPLOAD=542;
STR_UPLOADS=543;
STR_DOWNLOADS=544;
STR_ALBUM=545;
STR_COMPANY=546;
STR_DATE_COLUMN=547;
STR_REQUESTED_SIZE=548;
STR_FILE_SIZE=549;
STR_SIZE=550;
STR_FORMAT=551;
STR_FILENAME=552;
STR_URL=553;
STR_NAME=554;
STR_TOPIC=555;
STR_WELCOME_CHANNEL_TOPIC1=556;
STR_WELCOME_CHANNEL_TOPIC2=557;
STR_SPEED=558;
STR_GROUP_BY_ALBUM=559;
STR_GROUP_BY_AUTHOR=560;
STR_GROUP_BY_ARTIST=561;
STR_GROUP_BY_CATEGORY=562;
STR_GROUP_BY_COMPANY=563;
STR_GROUP_BY_GENRE=564;
STR_ALL=565;
STR_AUDIO=566;
STR_VIDEO=567;
STR_IMAGE=568;
STR_DOCUMENT=569;
STR_OTHER=570;
STR_SOFTWARE=571;
STR_SHARED_VIRTUAL_FOLDERS=581;
STR_SHARED_FOLDERS=582;
STR_SHARED_FILES=583;
STR_YOUR_LIBRARY=584;
STR_SEARCH_FOR_VIDEO_FILES=585;
STR_SEARCH_FOR_AUDIO_FILES=586;
STR_SEARCH_FOR_GENERIC_MEDIA=587;
STR_SEARCH_FOR_IMAGE_FILES=588;
STR_SEARCH_FOR_DOCUMENTS=589;
STR_SEARCH_FOR_SOFTWARES=590;
STR_TYPE=594;
STR_FILE=595;
STR_UPLOADED=596;
STR_STATUS=597;
STR_MEDIA_TYPE=598;
STR_LOCATION=599;
STR_REQUESTED=600;
STR_TODAY=601;
STR_TOTAL=602;
STR_GENRE=603;
STR_REMAINING=604;
STR_PROGRESS=605;
STR_TOTAL_TRANSFER_SPEED=606;
STR_COMMENT=607;
STR_ESTIMATED_TIME_REMAINING=608;
STR_VOLUME_TRANSMITTED=609;
STR_VOLUME_DOWNLOADED=610;
STR_NUMBER_OF_SOURCES=611;
STR_SOURCES=612;
STR_SOURCE=613;
STR_BANDWIDTH=614;
STR_UNKNOWN=615;
STR_UNKNOW_LOWER=616;
STR_OF=617;
STR_UPLOADING=618;
STR_ON=631;
STR_FROM=632;
STR_CLEARSSCREEN=683;
STR_AGE=693;
STR_SEX=694;
STR_COUNTRY=695;
STR_STATECITY=696;
STR_MALE=697;
STR_FEMALE=698;
STR_CONF_PREFERRED_LANGUAGE=699;
STR_CHANNELS=700;
STR_SHARED_PLUR=701;
STR_RETRIEVINGLIST_PLEASEWAIT=703;
//STR_LISTEMPTY_TRYLATER=704;
STR_SCANNING=705;
STR_SHARING=708;
STR_FILES=709;
STR_CONNECTED_AS=710;
STR_HIDESEARCHFIELD=711;
STR_AVAILABLE_SPACE=712;
STR_BROWSEINPROGRESS=713;
STR_BROWSECOMPLETED=714;
STR_POOR=715;
STR_AVERAGE=716;
STR_GOOD=717;
STR_VERYGOOD=718;
STR_HASH_HINT=719;
STR_HASH_CALCULATIONINPROGRESS=720;
STR_MEDIASEARCHINPROGRESS=721;
STR_CANCELUPLOAD=724;
STR_OTHERMIME=725;
STR_AUDIOMIME=726;
STR_SOFTWAREMIME=727;
STR_VIDEOMIME=728;
STR_DOCUMENTMIME=729;
STR_IMAGEMIME=730;
STR_STARTED=731;
STR_SOURCES_AVAILABLE=732;
STR_ACTUALPROGRESS=733;
STR_TOTALTRIES=734;
STR_RETRYINTERVAL=735;
STR_LASTREQUESTED=736;
STR_EXPIRATION=738;
STR_SAVEAS=741;
STR_ATLEAST=742;
STR_ATBEST=743;
STR_EQUALTO=744;
STR_CIRCA=745;
STR_LONGERTHAN=746;
STR_SHORTERTHAN=747;
STR_SMALLERTHAN=748;
STR_BIGGERTHAN=749;
STR_LOCAL_PAUSED=750;
STR_CONF_DLATONCE=751;
STR_UNKNOWNCOMMAND=752;
STR_CONFIG_PROXY=753; //proxy
STR_CONFIG_PROXY_NOTUSINGPROXY=755;
STR_CONFIG_PROXY_USING_SOCK4=756;
STR_CONFIG_PROXY_USING_SOCK5=757;
STR_CONFIG_PROXY_SOCKSADDR=758;
STR_CONFIG_PROXY_USERNAME=759;
STR_CONFIG_PROXY_PASSWORD=760;
STR_USERISBROWSINGYOU=761;
STR_DISALLOWPVTBROWSE=762;
STR_CHAT_WITH_USER=766;
STR_SENDFOLDER_MENU=767;
STR_OFFLINE=768;
STR_CHAT_SEARCH=769;
STR_GRANT_SLOT=770;
STR_BROWSE_FAILED_USER_OFFLINE=771;
STR_CHATROOM_SHAREABLE_TYPES=772;
STR_DOWNLOAD_HASHLINK=775;
STR_EXPORT_HASHLINK=777;
STR_ERROR_FILECORRUPTED=778;
STR_ERROR_FILELOCKED=779;
STR_GRANTBROWSE_MENU=785;
STR_DOWNLOADED_ON=787;
STR_RECENT_DOWNLOADS=788;
STR_SENDFULLPATH_BROWSE=789;
STR_OPENFOLDER=790;
STR_AUTOACCEPTFILES=791;
STR_CONFIG_HASHLINKS=795;
STR_CONFIGINCLUDEMAGNETLINKS=797;
STR_MAIN_CONTROL_PANEL=799;
STR_MAIN_CONTROL_PANEL_HINT=800;
STR_CONFIG_CHECKPROXY=801;
STR_CHECKPROXY_TESTING=802;
STR_CHECKPROXY_FAILED=803;
STR_CHECKPROXY_SUCCEDED=804;
STR_ANON_PROXY=805;
STR_ACTUAL_ANONPROXY=806;
STR_LOAD_PROXYIES=807;
STR_SAVE_LIST=808;
STR_USEMULTIPLEPROXIES=809;
STR_NEW_WINDOW=810;
STR_GO=811;
STR_CONF_SHOW_JP=812;
STR_FAVORITES=813;
STR_ADD_TOFAVORITES=814;
STR_LAST_JOINED=815;
STR_SEARCH_FOR_OTHERS=816;
STR_REMOVE_SOURCE=817; //2956+
STR_WARN_DANGEROUS_FILEEXT=818; //2961+
STR_BUSY=819;
STR_CONFIG_CHATROOM=820;
STR_PUSHING=821;
STR_WAITINGFORPEERACK=822;
STR_REQUESTING=823;
STR_AUTOJOIN=824;
STR_CONNECTED=825;
STR_AUTOADD_TO_FAVORITES=826;
STR_BITTORRENT_ASSOCIATION=827;
STR_ACTIVE=828;
STR_RIPTODISK=829;
STR_TUNEIN=830;
STR_HANDLE_M3UANDPLS=831;
STR_DIRECTORY_SHOUTCAST=832;
STR_TOGGLE_CHAT_VCAUDIO=833;
STR_TOGGLE_CHAT_VCSPEAK=834;
STR_RECORDING=835;
STR_SENTBY=836;
STR_SENDPICTURE=837;
STR_PLAYCHAT_VC=838;
STR_SAVECHAT_VC=839;
STR_UNABLE_TO_DOWNLOAD_TEMPLATE=840;
STR_COPY_LINK=841;
STR_CHAT_HAS_JOINED_SIMPLE=842;
STR_JOIN_WITHREMOTETEMPLATE=843;
STR_JOIN_WITHOUTTEMPLATE=844;
//STR_CONF_AUTOCLOSEROOM=834;

country_strings: array [1..233] of string = (
  'Afghanistan',
  'Albania',
  'Algeria',
  'Andorra',
  'Angola',
  'Anguilla',
  'Antarctica',
  'Antigua and Barbuda',
  'Argentina',
  'Armenia',
  'Aruba',
  'Australia',
  'Austria',
  'Azerbaijan',
  'Bahamas',
  'Bahrain',
  'Bangladesh',
  'Barbados',
  'Belarus',
  'Belgium',
  'Belize',
  'Benin',
  'Bermuda',
  'Bhutan',
  'Bolivia',
  'Bosnia and Herzegovina',
  'Botswana',
  'Brazil',
  'Brunei',
  'Bulgaria',
  'Burkina Faso',
  'Burundi',
  'Cambodia',
  'Cameroon',
  'Canada',
  'Cape Verde',
  'Cayman Islands',
  'Central African Republic',
  'Chad',
  'Chile',
  'China',
  'Christmas Islands',
  'Cocos Islands',
  'Colombia',
  'Comoros',
  'Congo',
  'Congo',
  'Cook Islands',
  'Costa Rica',
  'Croatia',
  'Cuba',
  'Cyprus',
  'Czech Republic',
  'Denmark',
  'Djibouti',
  'Dominica',
  'Dominican Republic',
  'Dutch antilles',
  'EastTimor',
  'Ecuador',
  'Egypt',
  'El Salvador',
  'Equatorial Guinea',
  'Eritrea',
  'Estonia',
  'Ethiopia',
  'Falkland Islands',
  'Faroe Islands',
  'Fiji Islands',
  'Finland',
  'France',
  'French Polynesia',
  'Gabon',
  'Gambia',
  'Gaza',
  'Georgia',
  'Germany',
  'Ghana',
  'Gibraltar',
  'Greece',
  'Greenland',
  'Grenada',
  'Guadaloupe',
  'Guatemala',
  'Guernsey',
  'Guinea',
  'Guinea-Bissau',
  'Guyana',
  'Guyana',
  'Haiti',
  'Honduras',
  'Hong Kong',
  'Hungary',
  'Iceland',
  'India',
  'Indonesia',
  'Iran',
  'Iraq',
  'Ireland',
  'Isle of Man',
  'Israel',
  'Italy',
  'Ivory coast',
  'Jamaica',
  'Japan',
  'Jersey',
  'Jordan',
  'Kazakhstan',
  'Kenya',
  'Kiribati',
  'Kuwait',
  'Kyrgyzstan',
  'Laos',
  'Latvia',
  'Lebanon',
  'Lesotho',
  'Liberia',
  'Libya',
  'Liechtenstein',
  'Lithuania',
  'Luxembourg',
  'Macao',
  'Macedonia',
  'Madagascar',
  'Malawi',
  'Malaysia',
  'Maldives',
  'Mali',
  'Malta',
  'Marshall Islands',
  'Martinique',
  'Mauritania',
  'Mauritius',
  'Mayotte',
  'Mexico',
  'Micronesia',
  'Moldova',
  'Monaco',
  'Mongolia',
  'Montserrat',
  'Morocco',
  'Mozambique',
  'Myanmar',
  'Namibia',
  'Nauru',
  'Nepal',
  'Netherlands',
  'New Caledonia',
  'New Zealand',
  'Nicaragua',
  'Niger',
  'Nigeria',
  'Niue',
  'Norfolk Island',
  'North Korea',
  'Norway',
  'Oman',
  'Pakistan',
  'Palau',
  'Panama',
  'Papua New-Guinea',
  'Paraguay',
  'Peru',
  'Philippines',
  'Pitcairn island',
  'Poland',
  'Portugal',
  'Puerto Rico',
  'Qatar',
  'Reunion',
  'Romania',
  'Russia',
  'Rwanda',
  'Samoa',
  'San Marino',
  'Sao Tome and Principe',
  'Saudi Arabia',
  'Senegal',
  'Seychelles',
  'Sierra Leone',
  'Singapore',
  'Slovakia',
  'Slovenia',
  'Solomon island',
  'Somalia',
  'South Africa',
  'South Georgia Island and South Sandwich Islands',
  'South Korea',
  'Spain',
  'Sri Lanka',
  'St Helens',
  'St Kitts and Nevis',
  'St Lucia',
  'St Pierre and Miquelon',
  'St Vincent and the Grenadines',
  'Sudan',
  'Suriname',
  'Svalbard',
  'Swaziland',
  'Sweden',
  'Switzerland',
  'Syria',
  'Taiwan',
  'Tajikistan',
  'Tanzania',
  'Thailand',
  'Togo',
  'Tokelau',
  'Tonga',
  'Trinidad and Tobago',
  'Tunisia',
  'Turkey',
  'Turkmenistan',
  'Turks and Caicos Islands',
  'Tuvalu',
  'Uganda',
  'Ukraine',
  'United Arab Emirates',
  'United Kingdom',
  'United States',
  'Uruguay',
  'Uzbekistan',
  'Vanuatu',
  'Venezuela',
  'Vietnam',
  'Virgin Islands',
  'Wallis and Futuna',
  'West Bank',
  'Western Sahara',
  'Yemen',
  'Yugoslavia',
  'Zambia',
  'Zimbabwe'
);

function parse_lines_lang(superwstr: WideString): Integer;
procedure localiz_loadlanguage;

procedure load_default_language_english;
procedure mainGui_apply_language;
procedure mainGui_apply_languageFirst;

procedure mainGui_update_localiz_headers;
function GetLangStringA(LangStrId:integer): string;
function GetLangStringW(LangStrId:integer): WideString;
procedure FreeLanguageDb;
procedure CreateLanguageDb;
procedure InitLanguageDb;

function getDefLang: WideString;
function GetOsLanguage: string;

procedure mainGui_enumlangs;
procedure SetCurrentLanguage_Index;

var
db_language:^Tdb_Language=nil;

implementation

uses
 vars_global,ufrmmain,ares_types,helper_gui_misc,utility_ares,
 helper_search_gui,helper_registry;


function GetLangStringA(LangStrId:integer): string;
begin
result := '';

if ((LangStrId>MAX_TRANSLATIONTABLE_INDEX) or
    (LangStrId<MIN_TRANSLATIONTABLE_INDEX)) then exit;

 if ((defLangEnglish) or (db_language=nil)) then Result := db_english_lang[LangStrId]
  else begin
   Result := widestrtoutf8str(db_language[LangStrId]);
   if length(result)=0 then Result := db_english_lang[LangStrId];
  end;
end;

function GetLangStringW(LangStrId:integer): WideString;
begin
result := '';

if ((LangStrId>MAX_TRANSLATIONTABLE_INDEX) or
    (LangStrId<MIN_TRANSLATIONTABLE_INDEX)) then exit;

 if ((defLangEnglish) or (db_language=nil)) then Result := db_english_lang[LangStrId]
  else begin
   Result := db_language[LangStrId];
   if length(Result)=0 then Result := db_english_lang[LangStrId];
  end;
end;

procedure mainGui_update_localiz_headers;
var
i,h: Integer;
begin
with ares_frmmain do begin

with treeview_download.header do begin
 columns[0].text := GetLangStringW(STR_FILE);
 columns[1].text := GetLangStringW(STR_TYPE);
 columns[2].text := GetLangStringW(STR_USER);
 columns[3].text := GetLangStringW(STR_STATUS);
 columns[4].text := GetLangStringW(STR_PROGRESS);
 columns[5].text := GetLangStringW(STR_SPEED);
 columns[6].text := GetLangStringW(STR_REMAINING);
 columns[7].text := GetLangStringW(STR_DOWNLOADED);
end;

with treeview_upload.header do begin
 columns[0].text := GetLangStringW(STR_FILE);
 columns[1].text := GetLangStringW(STR_TYPE);
 columns[2].text := GetLangStringW(STR_USER);
 columns[3].text := GetLangStringW(STR_STATUS);
 columns[4].text := GetLangStringW(STR_PROGRESS);
 columns[5].text := GetLangStringW(STR_SPEED);
 columns[6].text := GetLangStringW(STR_REMAINING);
 columns[7].text := GetLangStringW(STR_UPLOADED);
end;

with treeview_queue.header do begin
 columns[0].text := GetLangStringW(STR_USER);
 columns[1].text := GetLangStringW(STR_FILE);
 columns[2].text := GetLangStringW(STR_SIZE);
end;

with listview_chat_channel.Header do
 if columns[0].text<>'' then begin
  columns[0].text := GetLangStringW(STR_NAME);
  columns[1].text := GetLangStringW(STR_LANGUAGE);
  columns[2].text := GetLangStringW(STR_USERS);
  columns[3].text := GetLangStringW(STR_TOPIC);
 end;


with treeview_chat_favorites.header do begin
  columns[0].text := GetLangStringW(STR_NAME);
  columns[1].text := GetLangStringW(STR_LAST_JOINED);
  columns[2].text := GetLangStringW(STR_TOPIC);
end;
end;

end;

procedure mainGui_apply_languageFirst;
var
pnl: TCometPagePanel;
begin
with ares_frmmain do begin
 pnl := tabs_pageview.panels[IDTAB_LIBRARY];
 pnl.btncaption := GetLangStringW(STR_LIBRARY);
  pnl := tabs_pageview.panels[IDTAB_SCREEN];
  pnl.btncaption := GetLangStringW(STR_SCREEN);
   pnl := tabs_pageview.panels[IDTAB_SEARCH];
   pnl.btncaption := GetLangStringW(STR_SEARCH);
    pnl := tabs_pageview.panels[IDTAB_TRANSFER];
    pnl.btncaption := GetLangStringW(STR_TRANSFER);
     pnl := tabs_pageview.panels[IDTAB_CHAT];
     pnl.btncaption := GetLangStringW(STR_CHAT);
      pnl := tabs_pageview.panels[IDTAB_OPTION];
      pnl.btncaption := GetLangStringW(STR_MAIN_CONTROL_PANEL);

   btn_start_search.caption := GetLangStringW(STR_SEARCHNOW);
   btn_stop_search.caption := GetLangStringW(STR_STOPSEARCH);

   lbl_srcmime_all.caption := GetLangStringW(STR_ALL);
   lbl_srcmime_audio.caption := GetLangStringW(STR_AUDIO);
   lbl_srcmime_video.caption := GetLangStringW(STR_VIDEO);
   lbl_srcmime_image.caption := GetLangStringW(STR_IMAGE);
   lbl_srcmime_document.caption := GetLangStringW(STR_DOCUMENT);
   lbl_srcmime_software.caption := GetLangStringW(STR_SOFTWARE);
   lbl_srcmime_other.caption := GetLangStringW(STR_OTHER);
   
  helper_search_gui.searchpanel_invalidatemimeicon(0);
  lbl_capt_search.caption := GetLangStringW(STR_SEARCH_FOR_GENERIC_MEDIA);

end;
end;

procedure mainGui_apply_language;
var
pnl: TCometPagePanel;
begin
ares_FrmMain.caption := ' '+appname+' '+versioneares;
mainGui_update_localiz_headers;

with ares_frmmain do begin

 pnl := tabs_pageview.panels[IDTAB_LIBRARY];
 pnl.btncaption := GetLangStringW(STR_LIBRARY);
  pnl := tabs_pageview.panels[IDTAB_SCREEN];
  pnl.btncaption := GetLangStringW(STR_SCREEN);
   pnl := tabs_pageview.panels[IDTAB_SEARCH];
   pnl.btncaption := GetLangStringW(STR_SEARCH);
    pnl := tabs_pageview.panels[IDTAB_TRANSFER];
    pnl.btncaption := GetLangStringW(STR_TRANSFER);
     pnl := tabs_pageview.panels[IDTAB_CHAT];
     pnl.btncaption := GetLangStringW(STR_CHAT);
      pnl := tabs_pageview.panels[IDTAB_OPTION];
      pnl.btncaption := GetLangStringW(STR_MAIN_CONTROL_PANEL);

 //options
 btn_opt_connect.caption := GetLangStringA(STR_MAIN_CONNECT_MENU);
 btn_opt_connect.hint := GetLangStringA(STR_MAIN_CONNECT_MENU);
 btn_opt_disconnect.caption := GetLangStringA(STR_MAIN_DISCONNECT_MENU);
 btn_opt_disconnect.Hint := GetLangStringA(STR_MAIN_DISCONNECT_MENU);
 if frm_settings<>nil then frm_settings.apply_language;

   //chat btns
 btn_chat_refchanlist.caption := GetLangStringA(STR_REFRESH_LIST);
 btn_chat_refchanlist.hint := btn_chat_refchanlist.caption;
 btn_chat_join.caption := GetLangStringA(STR_JOIN_CHANNEL);
 btn_chat_join.hint := btn_chat_join.caption;
 btn_chat_host.caption := GetLangStringA(STR_HOST_A_CHANNEL);
 btn_chat_host.hint := btn_chat_host.caption;
 btn_chat_fav.caption := GetLangStringA(STR_FAVORITES);
 btn_chat_fav.hint := btn_chat_fav.caption;
 pnl_chat_fav.capt := GetLangStringW(STR_FAVORITES);

 
 (panel_chat.Panels[0] as TCometPagePanel).btncaption := GetLangStringW(STR_CHANNELS);



 //screen
 {btn_vid_fullscreen.caption := GetLangStringA(STR_FULLSCREEN);
 btn_vid_fullscreen.hint := btn_vid_fullscreen.caption;
 btn_vid_smaller.caption := GetLangStringA(STR_SMALLER);
 btn_vid_smaller.hint := btn_vid_smaller.caption;
 btn_vid_bigger.caption := GetLangStringA(STR_BIGGER);
 btn_vid_bigger.hint := GetLangStringA(STR_HINT_BIGGER);
 btn_vid_actualsize.caption := GetLangStringA(STR_FITTOSCREEN);
 btn_vid_actualsize.hint := GetLangStringA(STR_HINT_ACTUALSIZE); }

 //library
  btn_lib_virtual_view.caption := GetLangStringA(STR_VIRTUAL_VIEW);
  btn_lib_virtual_view.hint := GetLangStringA(STR_VIRTUAL_VIEW_HINT);
  btn_lib_regular_view.caption := GetLangStringA(STR_REGULAR_VIEW);
  btn_lib_regular_view.hint := GetLangStringA(STR_REGULAR_VIEW_HINT);
   btn_lib_regular_view.left := btn_lib_virtual_view.left+btn_lib_virtual_view.width+5;
 btn_lib_refresh.caption := '';
 btn_lib_refresh.hint := GetLangStringA(STR_HINT_REFRESH_LIBRARY);
 btn_lib_toggle_folders.caption := GetLangStringA(STR_FOLDERS);
 btn_lib_toggle_folders.hint := GetLangStringA(STR_HINT_FOLDERS);
 btn_lib_toggle_details.caption := GetLangStringA(STR_DETAILS);
 btn_lib_toggle_details.hint := GetLangStringA(STR_HINT_DETAILS);
 btn_lib_delete.caption := '';
 btn_lib_delete.hint := GetLangStringA(STR_HINT_DELETEFILE);
 btn_lib_addtoplaylist.caption := '';
 btn_lib_addtoplaylist.hint := GetLangStringA(STR_HINT_ADDTOPLAYLIST);
 openfolder1.caption := GetLangStringW(STR_OPENFOLDER);


      
 //transfer
 btn_tran_cancel.caption := GetLangStringA(STR_CANCEL_TRANSFER);
 btn_tran_cancel.hint := GetLangStringA(STR_HINT_CANCEL_TRANSFER);
 btn_tran_play.caption := GetLangStringA(STR_PLAYPREVIEW);
 btn_tran_play.hint := GetLangStringA(STR_HINT_PLAYPREVIEW);
 btn_tran_locate.caption := GetLangStringA(STR_LOCATE_FILE);
 btn_tran_locate.hint := GetLangStringA(STR_HINT_LOCATE_FILE);
 btn_tran_clearidle.caption := GetLangStringA(STR_CLEARIDLE);
 btn_tran_clearidle.hint := GetLangStringA(STR_HINT_CLEARIDLE);

 //search
// panel_search.Headercaption := ' '+GetLangStringW(STR_SEARCH);
 //btn_src_hide.hint := GetLangStringA(STR_HIDESEARCHFIELD);
 pnl := pagesrc.panels[0];
 pnl.btncaption := GetLangStringW(STR_NEW_SEARCH);
 
 with combo_sel_quality.items do begin
  clear;
 add('');
  add(GetLangStringW(STR_ATBEST));
 add(GetLangStringW(STR_EQUALTO));
  add(GetLangStringW(STR_ATLEAST));
 end;

 with combo_sel_duration.items do begin
  clear;
 add('');
  add(GetLangStringW(STR_SHORTERTHAN));
   add(GetLangStringW(STR_CIRCA));
 add(GetLangStringW(STR_LONGERTHAN));
 end;

 with combo_sel_size.items do begin
  clear;
 add('');
  add(GetLangStringW(STR_SMALLERTHAN));
 add(GetLangStringW(STR_CIRCA));
  add(GetLangStringW(STR_BIGGERTHAN));
 end;

 //vari
 btn_playlist_close.hint := GetLangStringA(STR_CLOSE_PLAYLIST);

// panel_details_library.HeaderCaption := ' '+GetLangStringW(STR_DETAILS);
// btn_lib_hidedetails.hint := GetLangStringA(STR_HIDE_DETAILS);

 btn_tran_toggle_queup.caption := GetLangStringA(STR_SHOW_QUEUE);
 btn_tran_toggle_queup.hint := GetLangStringA(STR_HINT_SHOW_QUEUE);

 lbl_lib_fileshared.caption := GetLangStringW(STR_SHARED);

 //popup library popup1
 AddRemovefolderstosharelist2.caption := GetLangStringW(STR_SHARESETTING);
 ShareUn1.caption := GetLangStringW(STR_HINT_SHAREUN);
 OpenPlay1.caption := GetLangStringW(STR_OPENPLAY);
 Openwithexternalplayer2.caption := GetLangStringW(STR_OPENEXTERNAL);
 Locate1.caption := GetLangStringW(STR_LOCATEFILE);
 DeleteFile2.caption := GetLangStringW(STR_HINT_DELETEFILE);
  AddtoPlaylist4.caption := GetLangStringW(STR_ADD_FOLDERTOPLAYLIST); //add to playlist da treeview1
  AddtoPlaylist5.caption := AddtoPlaylist4.caption;
 Addtoplaylist1.caption := GetLangStringW(STR_HINT_ADDTOPLAYLIST);
 Findmoreofthesameartist1.caption := GetLangStringW(STR_FINDMOREOFTHESAME);
 Artist1.caption := GetLangStringW(STR_ARTIST);
 Genre1.caption := GetLangStringW(STR_GENRE);
 ExportHashLink1.caption := GetLangStringW(STR_EXPORT_HASHLINK);
 ExportHashlink4.caption := ExportHashLink1.caption;
 //popup download popup3
 OpenPreview2.caption := GetLangStringW(STR_PLAYPREVIEW);
 Openexternal1.caption := GetLangStringW(STR_OPENEXTERNAL);
 Addtoplaylist2.caption := GetLangStringW(STR_HINT_ADDTOPLAYLIST);
 Locate2.caption := GetLangStringW(STR_LOCATEFILE);
 Findmorefromthesame2.caption := GetLangStringW(STR_FINDMOREOFTHESAME);
 Artist3.caption := GetLangStringW(STR_ARTIST);
 Genre3.caption := GetLangStringW(STR_GENRE);
 PauseResume1.caption := GetLangStringW(STR_PAUSE_RESUME);
 PauseallUnpauseAll1.caption := GetLangStringW(STR_PAUSE_RESUMEALL);
 Cancel2.caption := GetLangStringW(STR_CANCEL_TRANSFER);
 ClearIdle2.caption := GetLangStringW(STR_CLEARIDLE);
 RemoveSource1.caption := GetLangStringW(STR_REMOVE_SOURCE);
 //popup tray popup17
 tray_Play.caption := GetLangStringW(STR_PLAY);
 tray_Pause.caption := GetLangStringW(STR_PAUSE);
 tray_Stop.caption := GetLangStringW(STR_STOP);
 tray_showPlaylist.caption := GetLangStringW(STR_VIEW_PLAYLIST);
 tray_quit.caption := GetLangStringW(STR_QUITARES);
 if vars_global.app_minimized then tray_Minimize.caption := GetLangStringW(STR_SHOW_ARES)
  else tray_Minimize.caption := GetLangStringW(STR_HIDE_ARES);
 //popup menu lista canali popupmenu_list_channel
 Joinchannel1.caption := GetLangStringW(STR_JOIN_CHANNEL);
 saveas1.caption := GetLangStringW(STR_OPENINNOTEPAD_MENU);
 Exporthashlink5.caption := GetLangStringW(STR_EXPORT_HASHLINK);
 AddtoFavorites1.caption := GetLangStringW(STR_ADD_TOFAVORITES);

 //popup chat favorites
 Remove1.caption := GetLangStringW(STR_REMOVESELECTED);
 Join1.caption := GetLangStringW(STR_JOIN_CHANNEL);
 autojoin1.caption := GetLangStringW(STR_AUTOJOIN);
 Exporthashlink6.caption := GetLangStringW(STR_EXPORT_HASHLINK);
 
 //popupmenu caption player
  OpenExternal3.caption := GetLangStringW(STR_OPENEXTERNAL);
  Locate3.caption := GetLangStringW(STR_LOCATEFILE);
  Addtoplaylist6.caption := GetLangStringW(STR_HINT_ADDTOPLAYLIST);
   new1.caption := GetLangStringW(STR_TUNEIN);
   Riptodisk1.caption := GetLangStringW(STR_RIPTODISK);
   Locate4.caption := Locate3.caption;
   Enable1.caption := GetLangStringW(STR_ACTIVE);
   ExportHashlink7.caption := ExportHashLink1.caption;
   directory1.caption := GetLangStringW(STR_DIRECTORY_SHOUTCAST);
   
 //queued menu PopupMenu7
 Blockhost1.caption := GetLangStringW(STR_BLOCKUSER);
 GrantSlot1.caption := GetLangStringW(STR_GRANT_SLOT);
 MenuItem8.caption := GetLangStringW(STR_OPENPLAY);
 MenuItem9.caption := GetLangStringW(STR_OPENEXTERNAL);
 MenuItem10.caption := GetLangStringW(STR_LOCATEFILE);
 MenuItem11.caption := GetLangStringW(STR_HINT_ADDTOPLAYLIST);
 //PopupMenuvideo
 Fullscreen2.caption := GetLangStringW(STR_FULLSCREEN);
 fittoscreen1.caption := GetLangStringW(STR_FITTOSCREEN);
 Originalsize1.caption := GetLangStringW(STR_ACTUALSIZE);
 Play1.caption := GetLangStringW(STR_PLAY);
 Pause1.caption := GetLangStringW(STR_PAUSE);
 Stop2.caption := GetLangStringW(STR_STOP);
 Volume1.caption := GetLangStringW(STR_VOLUME);
 //netstreams
 play_netstream.caption := GetLangStringW(STR_OPENPLAY);
 //FlatButton6.caption := STR_CLOSE;

  // popup uploads PopupMenu5
  GrantSlot2.caption := GetLangStringW(STR_GRANT_SLOT);
  RemoveSource2.caption := RemoveSource1.caption;
  OpenPlay2.caption := GetLangStringW(STR_OPENPLAY);
  OpenExternal2.caption := GetLangStringW(STR_OPENEXTERNAL);
  LocateFile1.caption := GetLangStringW(STR_LOCATEFILE);
  Addtoplaylist3.caption := GetLangStringW(STR_HINT_ADDTOPLAYLIST);
  Cancel1.caption := GetLangStringW(STR_CANCELUPLOAD);
  BanUser1.caption := GetLangStringW(STR_BLOCKUSER);
  ClearIdle1.caption := GetLangStringW(STR_CLEARIDLE);

  //poup search view PopupMenu2
  Play3.caption := GetLangStringW(STR_PLAY);
  Download1.caption := GetLangStringW(STR_DOWNLOAD);
  Findmorefromthesame1.caption := GetLangStringW(STR_FINDMOREOFTHESAME);
  Artist2.caption := GetLangStringW(STR_ARTIST);
  Genre2.caption := GetLangStringW(STR_GENRE);
  NewSearch1.caption := GetLangStringW(STR_NEW_SEARCH);
  Stopsearch1.caption := GetLangStringW(STR_STOPSEARCH);


   //pannello search
   lbl_srcmime_all.caption := GetLangStringW(STR_ALL);
   lbl_srcmime_audio.caption := GetLangStringW(STR_AUDIO);
   lbl_srcmime_video.caption := GetLangStringW(STR_VIDEO);
   lbl_srcmime_image.caption := GetLangStringW(STR_IMAGE);
   lbl_srcmime_document.caption := GetLangStringW(STR_DOCUMENT);
   lbl_srcmime_software.caption := GetLangStringW(STR_SOFTWARE);
   lbl_srcmime_other.caption := GetLangStringW(STR_OTHER);
   Btn_start_search.caption := GetLangStringW(STR_SEARCHNOW);
   btn_stop_search.caption := GetLangStringW(STR_STOPSEARCH);
   //lbl_src_hint.caption := GetLangStringW(STR_FORTEXT);
   label_back_src.caption := GetLangStringW(STR_BACK);
  end;
   ufrmmain.ares_frmmain.radiosearchmimeclick(nil);

   //details library
  with ares_frmmain do begin
    lbl_title_detlib.caption := GetLangStringW(STR_TITLE);
    lbl_descript_detlib.caption := GetLangStringW(STR_COMMENT);
    lbl_url_detlib.caption := GetLangStringW(STR_URL);
    lbl_categ_detlib.caption := GetLangStringW(STR_CATEGORY);
    lbl_author_detlib.caption := GetLangStringW(STR_AUTHOR);
    lbl_album_detlib.caption := GetLangStringW(STR_ALBUM);
    lbl_language_detlib.caption := GetLangStringW(STR_LANGUAGE);
    lbl_year_detlib.caption := GetLangStringW(STR_DATE);

    //filtro in library narrow list
    edit_lib_search.glyphindex := 12;
    if edit_lib_search.text='' then edit_lib_search.text := GetLangStringW(STR_SEARCH);
    if edit_src_filter.text='' then edit_src_filter.text := GetLangStringW(STR_FILTER);
   // lbl_chat_filter.caption := GetLangStringW(STR_FILTER)+':';
  end;

    mainGui_sizectrls;
end;


procedure SetCurrentLanguage_Index;
var
Ind: Integer;
deflang: WideString;
reg: Tregistry;
begin
reg := tregistry.create;
with reg do begin
 openkey(areskey,true);
  deflang := utf8strtowidestr(hexstr_to_bytestr(ReadString('General.Language')));
  //if lowercase(deflang)='spanishla' then deflang := 'Spanish';
 closekey;
 destroy;
end;

if deflang='' then deflang := 'English';

 ind := frm_settings.Combo_opt_gen_gui_lang.items.indexof(deflang);
 if ind<>-1 then frm_settings.Combo_opt_gen_gui_lang.itemindex := ind
  else begin
   ind := frm_settings.Combo_opt_gen_gui_lang.items.indexof('English');
   if ind<>-1 then frm_settings.Combo_opt_gen_gui_lang.itemindex := ind;
  end;

end;

procedure mainGui_enumlangs;
var
 doserror: Integer;
 dirinfo:ares_types.tsearchrecW;
 str: WideString;
begin
//get available langs
with frm_settings do begin

 Combo_opt_gen_gui_lang.items.clear;
 Combo_opt_gen_gui_lang.items.add('English');

 doserror := helper_diskio.findfirstW(app_path+'\Lang\*.txt',FAANYFILE,dirinfo);
 while (doserror=0) do begin
  str := dirinfo.name;
  delete(str,length(str)-3,4);  //remove ext .txt
  if Combo_opt_gen_gui_lang.items.indexof(str)=-1 then Combo_opt_gen_gui_lang.items.add(str);
 doserror := helper_diskio.findnextW(dirinfo);
 end;
 helper_diskio.findcloseW(dirinfo);

 combo_opt_gen_gui_lang.Sorted := True;
 SetCurrentLanguage_Index;
 end;
end;

function GetOsLanguage: string;

 function PRIMARYLANGID(lgid : Word) : LongInt;
 begin
  Result := lgid and $3FF;
 end;

 function SUBLANGID(lgid : Word) : LongInt;
 begin
  Result := lgid shr 10;
 end;
 
 function MAKELANGID(sPrimaryLanguage : Word; sSubLanguage : Word) : Word;
  begin
  Result := (sSubLanguage shl 10) or
             sPrimaryLanguage;
 end;

var
  ID:LangID;
  lang,
  sub:longint;
begin
result := 'English';
try

  ID := GetSystemDefaultLangID;

  lang := PRIMARYLANGID(id);
  sub := SUBLANGID(id);

  case lang of
   $01: Result := 'Arabic';
   $04: Result := 'Chinese';
   $05: Result := 'Czech';
   $06: Result := 'Dansk';
   $13: Result := 'Dutch';
   $0b: Result := 'Finnish';
   $0c: Result := 'French';
   $07: Result := 'German';
   $10: Result := 'Italian';
   $11: Result := 'Japanese';
   $40: Result := 'Kyrgyz';
   $15: Result := 'Polish';
   $16: Result := 'Portugues';
   $1b: Result := 'Slovak';
   $0a:if sub=1 then Result := 'Spanish'
       else Result := 'Spanish'; //'SpanishLa';
   $1d: Result := 'Swedish';
   $1f: Result := 'Turkish'
    else Result := 'English';
  end;
except
end;

end;

function getDefLang: WideString;
var
 reg: Tregistry;
 stream: THandleStream;
begin

reg := tregistry.create;
with reg do begin
 openkey(areskey,true);
  Result := utf8strtowidestr(hexstr_to_bytestr(ReadString('General.Language')));
  //if lowercase(deflang)='spanishla' then deflang := 'Spanish';
 closekey;
 destroy;
end;

if result='' then begin
 Result := GetOsLanguage;
 set_regstring('General.Language',bytestr_to_hexstr(result));
 exit;
end;


  if not fileexistsW(app_path+'\Lang\'+result+'.txt') then begin
   Result := 'English';
   exit;
  end;
  
  stream := helper_diskio.myfileopen(app_path+'\Lang\'+result+'.txt',ARES_READONLY_BUT_SEQUENTIAL);
  if stream=nil then begin
   Result := 'English';
   exit;
  end;
  FreeHandleStream(stream);


end;

procedure localiz_loadlanguage;
var
 stream: Thandlestream;
 buffer: array [0..2047] of char;
 previous_len: Integer;
 utf8str: string;
 len: Integer;
 deflang: WideString;
begin
//deflang := ares_frmmmain.Combo_opt_gen_gui_lang.text;
try
deflang := getDefLang;

 if lowercase(deflang)='english' then begin
  defLangEnglish := True;
  load_default_language_english;
  exit;
 end;

stream := helper_diskio.myfileopen(app_path+'\Lang\'+deflang+'.txt',ARES_READONLY_BUT_SEQUENTIAL);
if stream=nil then begin
 load_default_language_english;
 defLangEnglish := True;
 exit;
end;

utf8str := '';
try
  defLangEnglish := False;
  CreateLanguageDb;
  
with stream do begin
 while (position+1<size) do begin
  len := read(buffer,sizeof(buffer));
  if len<1 then break;
   previous_len := length(utf8str);
   SetLength(utf8str,previous_len+len);
   move(buffer,utf8str[previous_len+1],len);
 end;
end;
FreeHandleStream(Stream);

 parse_lines_lang(utf8strtowidestr(utf8str));

except
FreeHandleStream(Stream);
end;


except
end;
end;

function parse_lines_lang(superwstr: WideString): Integer;
var
  trovato: Boolean;
  i: Integer;
  linea: WideString;
  cmd: Integer;
  str,fontn: string;
  fonts: Integer;
begin
  fonts := 8;
  if ((ares_frmmain.font.name<>'Tahoma') or (ares_frmmain.font.size<>8)) then begin
   ares_frmmain.font.name := 'Tahoma';
   ares_frmmain.font.size := 8;
    vars_global.font_chat.name := 'Verdana';
    vars_global.font_chat.size := 10;
    vars_global.font_chat.style := [];
   mainGui_applyfont;
  end;
  
  result := length(superwstr);
  
   while (length(superwstr)>0) do begin
  
    trovato := False;
    for i := 1 to length(superwstr)-1 do begin
       if ((integer(superwstr[i])=13) and (integer(superwstr[i+1])=10)) then begin
  
        SetLength(linea,i-1);
        linea := copy(superwstr,1,i-1);
  
         delete(superwstr,1,i+1);
         Result := length(superwstr);
         trovato := True;
         break;
       end;
    end;
  
    if not trovato then break;
  
    if length(linea)<4 then continue;
  
    if linea[4]<>'|' then begin  //FONT?
      str := widestrtoutf8str(linea);
      if pos('FONT NAME="',str)=1 then begin
        delete(str,1,11);
       fontn := copy(str,1,pos('"',str)-1);
        delete(str,1,pos('"',str));
       if pos(' SIZE="',str)=1 then begin
        delete(str,1,7);
        fonts := strtointdef(copy(str,1,pos('"',str)-1),8);
        delete(str,1,pos('"',str));
       end;
      try
       ares_FrmMain.Font.Name := fontn;
       ares_FrmMain.font.size := fonts;
      except
       ares_FrmMain.font.name := 'Tahoma';
       ares_FrmMain.font.size := 8;
      end;
          if pos(' FONT_CHAT NAME="',str)=1 then begin
            delete(str,1,17);
            fontn := copy(str,1,pos('"',str)-1);
             delete(str,1,pos('"',str));
              if pos(' SIZE="',str)=1 then begin
               delete(str,1,7);
               fonts := strtointdef(copy(str,1,pos('"',str)-1),8);
              end;
              try
               vars_global.Font_Chat.Name := fontn;
               vars_global.font_chat.size := fonts;
               vars_global.font_chat.style := [];
              except
               vars_global.font_chat.name := 'Verdana';
               vars_global.font_chat.size := 10;
               vars_global.font_chat.style := [];
              end;
           end;
          mainGui_applyfont;
      end;
  
      continue;
    end;
  
  
    cmd := strtointdef(string(copy(linea,1,3)),0);
    if cmd=0 then break;
     delete(linea,1,4);
     linea := strip_nl(linea);
  
     if ((cmd>=MIN_TRANSLATIONTABLE_INDEX) and (cmd<=MAX_TRANSLATIONTABLE_INDEX)) then db_language[cmd] := linea;
  end;
end;

procedure load_default_language_english;
begin
  try
    ares_frmmain.font.name := 'Tahoma';
    ares_frmmain.font.size := 8;
    vars_global.font_chat.name := 'Verdana';
    vars_global.font_chat.size := 10;
    vars_global.font_chat.style := [];
    helper_gui_misc.mainGui_applyfont;
  except
  end;
  
  FreeLanguageDb;
end;

procedure InitLanguageDb;
var
  i: Integer;
begin
  if db_language=nil then 
    exit;
  for i := MIN_TRANSLATIONTABLE_INDEX to MAX_TRANSLATIONTABLE_INDEX do 
    db_language[i] := '';
end;

procedure CreateLanguageDb;
begin
  if db_language<>nil then 
    exit;
  db_language := AllocMem(sizeof(Tdb_Language));
end;

procedure FreeLanguageDb;
begin
  if db_language=nil then 
    exit;
  InitLanguageDb;
  FreeMem(db_language,sizeof(Tdb_Language));
  db_language := nil;
end;

end.
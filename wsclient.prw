#INCLUDE "protheus.ch"
#INCLUDE "apwebsrv.ch"

/* ===============================================================================
WSDL Location    http://localhost:8090/ws/ADVPLWS.apw?WSDL
Gerado em        24/03/24 02:11:52
Observaï¿½ï¿½es      Cï¿½digo-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alteraï¿½ï¿½es neste arquivo podem causar funcionamento incorreto
                 e serï¿½o perdidas caso o cï¿½digo-fonte seja gerado novamente.
=============================================================================== */

User Function _EQAONVV ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSADVPLWS
------------------------------------------------------------------------------- */

WSCLIENT WSADVPLWS

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD GETCLIENTES
	WSMETHOD SETPEDVENDA

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cCNPJ_CPF                 AS string
	WSDATA   cCODIGO                   AS string
	WSDATA   cLOJA                     AS string
	WSDATA   oWSGETCLIENTESRESULT      AS ADVPLWS_ARRAYOFCLIENTEDEF
	WSDATA   oWSPEDIDO                 AS ADVPLWS_PEDIDO_VENDA
	WSDATA   oWSITENS                  AS ADVPLWS_ITEMPV
	WSDATA   oWSSETPEDVENDARESULT      AS ADVPLWS_RESULTADO

	// Estruturas mantidas por compatibilidade - Nï¿½O USAR
	WSDATA   oWSPEDIDO_VENDA           AS ADVPLWS_PEDIDO_VENDA
	WSDATA   oWSITEMPV                 AS ADVPLWS_ITEMPV

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSADVPLWS
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Cï¿½digo-Fonte Client atual requer os executï¿½veis do Protheus Build [7.00.210324P-20231005] ou superior. Atualize o Protheus ou gere o Cï¿½digo-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSADVPLWS
	::oWSGETCLIENTESRESULT := ADVPLWS_ARRAYOFCLIENTEDEF():New()
	::oWSPEDIDO          := ADVPLWS_PEDIDO_VENDA():New()
	::oWSITENS           := ADVPLWS_ITEMPV():New()
	::oWSSETPEDVENDARESULT := ADVPLWS_RESULTADO():New()

	// Estruturas mantidas por compatibilidade - Nï¿½O USAR
	::oWSPEDIDO_VENDA    := ::oWSPEDIDO
	::oWSITEMPV          := ::oWSITENS
Return

WSMETHOD RESET WSCLIENT WSADVPLWS
	::cCNPJ_CPF          := NIL 
	::cCODIGO            := NIL 
	::cLOJA              := NIL 
	::oWSGETCLIENTESRESULT := NIL 
	::oWSPEDIDO          := NIL 
	::oWSITENS           := NIL 
	::oWSSETPEDVENDARESULT := NIL 

	// Estruturas mantidas por compatibilidade - Nï¿½O USAR
	::oWSPEDIDO_VENDA    := NIL
	::oWSITEMPV          := NIL
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSADVPLWS
Local oClone := WSADVPLWS():New()
	oClone:_URL          := ::_URL 
	oClone:cCNPJ_CPF     := ::cCNPJ_CPF
	oClone:cCODIGO       := ::cCODIGO
	oClone:cLOJA         := ::cLOJA
	oClone:oWSGETCLIENTESRESULT :=  IIF(::oWSGETCLIENTESRESULT = NIL , NIL ,::oWSGETCLIENTESRESULT:Clone() )
	oClone:oWSPEDIDO     :=  IIF(::oWSPEDIDO = NIL , NIL ,::oWSPEDIDO:Clone() )
	oClone:oWSITENS      :=  IIF(::oWSITENS = NIL , NIL ,::oWSITENS:Clone() )
	oClone:oWSSETPEDVENDARESULT :=  IIF(::oWSSETPEDVENDARESULT = NIL , NIL ,::oWSSETPEDVENDARESULT:Clone() )

	// Estruturas mantidas por compatibilidade - Nï¿½O USAR
	oClone:oWSPEDIDO_VENDA := oClone:oWSPEDIDO
	oClone:oWSITEMPV     := oClone:oWSITENS
Return oClone

// WSDL Method GETCLIENTES of Service WSADVPLWS

WSMETHOD GETCLIENTES WSSEND cCNPJ_CPF,cCODIGO,cLOJA WSRECEIVE oWSGETCLIENTESRESULT WSCLIENT WSADVPLWS
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETCLIENTES xmlns="http://localhost:8090/">'
cSoap += WSSoapValue("CNPJ_CPF", ::cCNPJ_CPF, cCNPJ_CPF , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CODIGO", ::cCODIGO, cCODIGO , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("LOJA", ::cLOJA, cLOJA , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</GETCLIENTES>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://localhost:8090/GETCLIENTES",; 
	"DOCUMENT","http://localhost:8090/",,"1.031217",; 
	"http://localhost:8090/ws/ADVPLWS.apw")

::Init()
::oWSGETCLIENTESRESULT:SoapRecv( WSAdvValue( oXmlRet,"_GETCLIENTESRESPONSE:_GETCLIENTESRESULT","ARRAYOFCLIENTEDEF",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SETPEDVENDA of Service WSADVPLWS

WSMETHOD SETPEDVENDA WSSEND oWSPEDIDO,oWSITENS WSRECEIVE oWSSETPEDVENDARESULT WSCLIENT WSADVPLWS
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SETPEDVENDA xmlns="http://localhost:8090/">'
cSoap += WSSoapValue("PEDIDO", ::oWSPEDIDO, oWSPEDIDO , "PEDIDO_VENDA", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ITENS", ::oWSITENS, oWSITENS , "ITEMPV", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</SETPEDVENDA>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://localhost:8090/SETPEDVENDA",; 
	"DOCUMENT","http://localhost:8090/",,"1.031217",; 
	"http://localhost:8090/ws/ADVPLWS.apw")

::Init()
::oWSSETPEDVENDARESULT:SoapRecv( WSAdvValue( oXmlRet,"_SETPEDVENDARESPONSE:_SETPEDVENDARESULT","RESULTADO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure ARRAYOFCLIENTEDEF

WSSTRUCT ADVPLWS_ARRAYOFCLIENTEDEF
	WSDATA   oWSCLIENTEDEF             AS ADVPLWS_CLIENTEDEF OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT ADVPLWS_ARRAYOFCLIENTEDEF
	::Init()
Return Self

WSMETHOD INIT WSCLIENT ADVPLWS_ARRAYOFCLIENTEDEF
	::oWSCLIENTEDEF        := {} // Array Of  ADVPLWS_CLIENTEDEF():New()
Return

WSMETHOD CLONE WSCLIENT ADVPLWS_ARRAYOFCLIENTEDEF
	Local oClone := ADVPLWS_ARRAYOFCLIENTEDEF():NEW()
	oClone:oWSCLIENTEDEF := NIL
	If ::oWSCLIENTEDEF <> NIL 
		oClone:oWSCLIENTEDEF := {}
		aEval( ::oWSCLIENTEDEF , { |x| aadd( oClone:oWSCLIENTEDEF , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT ADVPLWS_ARRAYOFCLIENTEDEF
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CLIENTEDEF","CLIENTEDEF",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSCLIENTEDEF , ADVPLWS_CLIENTEDEF():New() )
			::oWSCLIENTEDEF[len(::oWSCLIENTEDEF)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure PEDIDO_VENDA

WSSTRUCT ADVPLWS_PEDIDO_VENDA
	WSDATA   cCLIENTE                  AS string
	WSDATA   cCOND_PAGTO               AS string
	WSDATA   cLOJA                     AS string
	WSDATA   cTIPO_FRETE               AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT ADVPLWS_PEDIDO_VENDA
	::Init()
Return Self

WSMETHOD INIT WSCLIENT ADVPLWS_PEDIDO_VENDA
Return

WSMETHOD CLONE WSCLIENT ADVPLWS_PEDIDO_VENDA
	Local oClone := ADVPLWS_PEDIDO_VENDA():NEW()
	oClone:cCLIENTE             := ::cCLIENTE
	oClone:cCOND_PAGTO          := ::cCOND_PAGTO
	oClone:cLOJA                := ::cLOJA
	oClone:cTIPO_FRETE          := ::cTIPO_FRETE
Return oClone

WSMETHOD SOAPSEND WSCLIENT ADVPLWS_PEDIDO_VENDA
	Local cSoap := ""
	cSoap += WSSoapValue("CLIENTE", ::cCLIENTE, ::cCLIENTE , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("COND_PAGTO", ::cCOND_PAGTO, ::cCOND_PAGTO , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("LOJA", ::cLOJA, ::cLOJA , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("TIPO_FRETE", ::cTIPO_FRETE, ::cTIPO_FRETE , "string", .T. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure ITEMPV

WSSTRUCT ADVPLWS_ITEMPV
	WSDATA   nPRECO                    AS float
	WSDATA   cPRODUTO                  AS string
	WSDATA   nQUANTIDADE               AS float
	WSDATA   cTES                      AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT ADVPLWS_ITEMPV
	::Init()
Return Self

WSMETHOD INIT WSCLIENT ADVPLWS_ITEMPV
Return

WSMETHOD CLONE WSCLIENT ADVPLWS_ITEMPV
	Local oClone := ADVPLWS_ITEMPV():NEW()
	oClone:nPRECO               := ::nPRECO
	oClone:cPRODUTO             := ::cPRODUTO
	oClone:nQUANTIDADE          := ::nQUANTIDADE
	oClone:cTES                 := ::cTES
Return oClone

WSMETHOD SOAPSEND WSCLIENT ADVPLWS_ITEMPV
	Local cSoap := ""
	cSoap += WSSoapValue("PRECO", ::nPRECO, ::nPRECO , "float", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("PRODUTO", ::cPRODUTO, ::cPRODUTO , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("QUANTIDADE", ::nQUANTIDADE, ::nQUANTIDADE , "float", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("TES", ::cTES, ::cTES , "string", .T. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure RESULTADO

WSSTRUCT ADVPLWS_RESULTADO
	WSDATA   lERRO                     AS boolean
	WSDATA   cMENSAGEM                 AS string
	WSDATA   nSTATUS                   AS float
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT ADVPLWS_RESULTADO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT ADVPLWS_RESULTADO
Return

WSMETHOD CLONE WSCLIENT ADVPLWS_RESULTADO
	Local oClone := ADVPLWS_RESULTADO():NEW()
	oClone:lERRO                := ::lERRO
	oClone:cMENSAGEM            := ::cMENSAGEM
	oClone:nSTATUS              := ::nSTATUS
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT ADVPLWS_RESULTADO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::lERRO              :=  WSAdvValue( oResponse,"_ERRO","boolean",NIL,"Property lERRO as s:boolean on SOAP Response not found.",NIL,"L",NIL,NIL) 
	::cMENSAGEM          :=  WSAdvValue( oResponse,"_MENSAGEM","string",NIL,"Property cMENSAGEM as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::nSTATUS            :=  WSAdvValue( oResponse,"_STATUS","float",NIL,"Property nSTATUS as s:float on SOAP Response not found.",NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure CLIENTEDEF

WSSTRUCT ADVPLWS_CLIENTEDEF
	WSDATA   cCNPJ_CPF                 AS string
	WSDATA   cCODIGO                   AS string
	WSDATA   cENDERECO                 AS string
	WSDATA   cLOJA                     AS string
	WSDATA   cNOME                     AS string
	WSDATA   cTIPO                     AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT ADVPLWS_CLIENTEDEF
	::Init()
Return Self

WSMETHOD INIT WSCLIENT ADVPLWS_CLIENTEDEF
Return

WSMETHOD CLONE WSCLIENT ADVPLWS_CLIENTEDEF
	Local oClone := ADVPLWS_CLIENTEDEF():NEW()
	oClone:cCNPJ_CPF            := ::cCNPJ_CPF
	oClone:cCODIGO              := ::cCODIGO
	oClone:cENDERECO            := ::cENDERECO
	oClone:cLOJA                := ::cLOJA
	oClone:cNOME                := ::cNOME
	oClone:cTIPO                := ::cTIPO
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT ADVPLWS_CLIENTEDEF
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCNPJ_CPF          :=  WSAdvValue( oResponse,"_CNPJ_CPF","string",NIL,"Property cCNPJ_CPF as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCODIGO            :=  WSAdvValue( oResponse,"_CODIGO","string",NIL,"Property cCODIGO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cENDERECO          :=  WSAdvValue( oResponse,"_ENDERECO","string",NIL,"Property cENDERECO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cLOJA              :=  WSAdvValue( oResponse,"_LOJA","string",NIL,"Property cLOJA as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cNOME              :=  WSAdvValue( oResponse,"_NOME","string",NIL,"Property cNOME as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cTIPO              :=  WSAdvValue( oResponse,"_TIPO","string",NIL,"Property cTIPO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
Return



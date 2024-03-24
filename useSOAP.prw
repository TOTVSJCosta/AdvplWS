#include "totvs.ch"
#include "apWebSRV.ch"

user function WSClient()
    local aClientes AS Array
    local oResult   AS Object
    local oWS       := WSADVPLWS():New()

    if !empty(oWS)
        // busca clientes
        // oWS:cCNPJ_CPF := "47321510000124"
        // oWS:cCodigo := "000001"
        // oWS:cLoja := "01"
        oWS:GETCLIENTES()
        aClientes := OWS:OWSGETCLIENTESRESULT:OWSCLIENTEDEF
        
        // grava pedido de venda
        OWS:OWSPEDIDO:CCLIENTE        := "000001"
        OWS:OWSPEDIDO:CLOJA            := "01"
        OWS:OWSPEDIDO:CCOND_PAGTO     := "001"
        OWS:OWSPEDIDO:CTIPO_FRETE     := 'F'

        OWS:OWSITENS:CPRODUTO      := "PRD1"
        OWS:OWSITENS:NQUANTIDADE   := 1
        OWS:OWSITENS:NPRECO        := 10
        OWS:OWSITENS:CTES          := "501"

        oWS:SETPEDVENDA()
        oResult := oWS:oWSSETPEDVENDARESULT
    endif
return

user function AdvplWS()
    local cRet      AS String
    local oCliente  AS Object
    local oWSDL := TWsdlManager():New()

    if  oWSDL:ParseURL("http://localhost:8090/ws/ADVPLWS.apw?WSDL") .and.;
        oWSDL:SetOperation("GETCLIENTES")

        if oWSDL:SendSOAPmsg()
            cRet := oWSDL:GetParsedResponse()
        else
        endif
    else
    endif


return

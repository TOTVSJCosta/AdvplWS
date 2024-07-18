#include "totvs.ch"
#include "ApWebSrv.ch"

user function WS_Client()
    //local oWSCl := WSSA1_TrWS():New()

    //Get
    OWSCL:CCCGC := ""
    OWSCL:CCCODIGO := ""
    OWSCL:CCLOJA := ""
    //Put
    OWSCL:OWSOSA1LINHA:CCCODIGO:="300000"
    OWSCL:OWSOSA1LINHA:CCLoja:="01"
    OWSCL:OWSOSA1LINHA:CCNome:="cliente 300000 loja 01"

    if oWSCl:PutSA1Info()
        alert("Hora servidor:  + oWSCl:cGetSrvTimeResult")
    else
        alert("ERRO")
    endif

return

WSSTRUCT SA1Linha
    WSDATA cCodigo  AS String
    WSDATA cLoja    AS String
    WSDATA cNome    AS String
ENDWSSTRUCT

WSSERVICE SA1_TrWS DESCRIPTION "Webservice tabela de clientes SA1"
    WSDATA cResultado   AS String OPTIONAL
    WSDATA cCGC         AS String OPTIONAL
    WSDATA cCodigo      AS String OPTIONAL
    WSDATA cLoja        AS String OPTIONAL
    WSDATA aSA1Info     AS Array OF SA1Linha
    WSDATA oSA1Linha    AS SA1Linha

    WSMETHOD GetSA1Info DESCRIPTION "Obtem informações do cadastro de clientes"
    WSMETHOD PutSA1Info DESCRIPTION "Grava cliente"
ENDWSSERVICE

WSMETHOD PutSA1Info WSSEND cResultado WSRECEIVE oSA1Linha WSSERVICE SA1_TrWS
    RPCSetEnv("99", "01")
    
    local oModel := FWLoadModel("CRMA980")
    
    RecLock("SA1", .t.)
        sa1->A1_FILIAL := xfilial("SA1")
        sa1->A1_COD := oSA1Linha:cCodigo
        sa1->A1_LOJA := oSA1Linha:cLoja
        sa1->A1_NOME := oSA1Linha:cNome
    SA1->(msUnlock())
return .T.

WSMETHOD GetSA1Info WSSEND aSA1Info WSRECEIVE cCGC, cCodigo, cLoja WSSERVICE SA1_TrWS
    local cCond := "%1 <> 1%"
    local cAlias := GetNextAlias()

    default ::cCGC := ""
    default ::cCodigo := ""
    default ::cLoja := ""

    RPCSetEnv("99", "01")

    if empty(::cCGC + ::cCodigo + ::cLoja)
        cCond := "%1 = 1%"
    elseif !empty(::cCGC)
        cCond := "%A1_CGC = '" + ::cCGC + "'%"
    elseif !empty(::cCodigo) .and. !empty(::cLoja)
        cCond := "%A1_COD = '" + ::cCodigo + "' AND A1_LOJA = '" + ::cLoja + "'%"
    endif

    beginSQL Alias cAlias
        SELECT
            A1_COD,A1_LOJA,A1_NOME,A1_PESSOA,A1_TIPO,A1_CGC,A1_END,A1_MUN,A1_EST
        FROM
            %TABLE:SA1% SA1
        WHERE
            %Exp:cCond%
        ORDER BY
            A1_COD,A1_LOJA
    endSQL
    if (cAlias)->(eof())
        ::cResultado := "Nenhum cliente localizado..."
    else
        while (cAlias)->(!eof())
            aAdd(::aSA1Info, WSClassNew("SA1Linha"))

            oLinha := aTail(::aSA1Info)
            oLinha:cCodigo  := (cAlias)->A1_COD
            oLinha:cLoja    := (cAlias)->A1_LOJA
            oLinha:cNome    := (cAlias)->A1_NOME

            (cAlias)->(dbSkip())
        end
    endif
    (cAlias)->(dbCloseArea())
return .T.

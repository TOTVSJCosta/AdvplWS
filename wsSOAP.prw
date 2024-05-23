#include "totvs.ch"
#include "apWebSRV.ch"

WSSTRUCT endereco
    WSDATA logradouro   AS String
    WSDATA numero       AS Integer OPTIONAL
    WSDATA cep          AS String
    WSDATA bairro       AS String
    WSDATA cidade       AS String
    WSDATA uf           AS String
    WSDATA ibge         AS String OPTIONAL
ENDWSSTRUCT

WSSTRUCT ClienteDef
    WSDATA codigo    AS String
    WSDATA loja      AS String
    WSDATA nome      AS String
    WSDATA tipo      AS String
    WSDATA cnpj_cpf  AS String
    WSDATA endereco  AS endereco
ENDWSSTRUCT

WSSTRUCT ItemPV
    WSDATA produto    AS String
    WSDATA quantidade AS Float 
    WSDATA preco      AS Float 
    WSDATA TES        AS String
ENDWSSTRUCT

WSSTRUCT pedido_venda
    WSDATA cliente      AS String
    WSDATA loja         AS String
    WSDATA cond_pagto   AS String
    WSDATA tipo_frete   AS String
ENDWSSTRUCT

WSSTRUCT resultado
    WSDATA erro     AS Boolean
    WSDATA status   AS Float
    WSDATA mensagem AS String
ENDWSSTRUCT

WSSERVICE AdvplWS DESCRIPTION "Treinamento Advpl Webservice"
    WSDATA CNPJ_CPF AS String OPTIONAL
    WSDATA codigo   AS String OPTIONAL
    WSDATA loja     AS String OPTIONAL
    WSDATA pedido   AS pedido_venda
    WSDATA itens    AS ItemPV
    WSDATA msgRet   AS resultado
    WSDATA clientes AS Array OF ClienteDef

    WSMETHOD GetClientes DESCRIPTION "Obtem a lista de clientes cadastrados via CPF ou CNPJ"
    WSMETHOD SetPedVenda DESCRIPTION "Inclusao de pedido de venda"
ENDWSSERVICE

WSMETHOD GetClientes WSSEND clientes WSRECEIVE CNPJ_CPF,codigo,loja WSSERVICE AdvplWS
    local cAlias := GetNextAlias()
    local cWhere := "%1<>1%"

    default CNPJ_CPF  := ""
    default codigo    := ""
    default loja      := ""

    if empty(CNPJ_CPF + codigo + loja)
        cWhere := "%1=1%"
    elseif !empty(CNPJ_CPF)
        cWhere := "%A1_CGC='" + CNPJ_CPF + "'%"
    elseif !empty(codigo) .and. !empty(loja)
        cWhere := "%A1_COD='" + codigo + "' AND A1_LOJA='" + ::loja + "'%"
    endif
    RPCSetEnv("99", "01")

    BEGINSQL ALIAS cAlias
        SELECT A1_COD,A1_LOJA,A1_NOME,A1_PESSOA,A1_END,A1_CGC
        FROM %TABLE:SA1% SA1
        WHERE A1_FILIAL = %XFILIAL:SA1% AND %NOTDEL% AND %exp:cWhere%
        ORDER BY A1_COD,A1_LOJA
    ENDSQL

    while (cAlias)->(!eof())
        aAdd(clientes, WsClassNew("ClienteDef"))

        aTail(clientes):cnpj_cpf := (cAlias)->A1_CGC
        aTail(clientes):codigo   := (cAlias)->A1_COD
        aTail(clientes):loja     := (cAlias)->A1_LOJA
        aTail(clientes):nome     := rtrim((cAlias)->A1_NOME)
        aTail(clientes):tipo     := rtrim((cAlias)->A1_PESSOA)
        aTail(::clientes):endereco := WsClassNew("endereco")
        aTail(::clientes):endereco:logradouro := rtrim((cAlias)->A1_END)
        aTail(::clientes):endereco:cep := rtrim((cAlias)->A1_END)
        aTail(::clientes):endereco:bairro := rtrim((cAlias)->A1_END)
        aTail(::clientes):endereco:cidade := rtrim((cAlias)->A1_END)
        aTail(::clientes):endereco:uf := rtrim((cAlias)->A1_END) 

        aTail(::clientes):JSON     := jsonObject():New()
        aTail(::clientes):JSON["codigo"]   := (cAlias)->A1_COD
        aTail(::clientes):JSON["loja"]     := (cAlias)->A1_LOJA
        aTail(::clientes):JSON["pessoa"]   := (cAlias)->A1_PESSOA
        aTail(::clientes):JSON["nome"]     := rtrim((cAlias)->A1_NOME)
        aTail(::clientes):JSON["cnpj_cpf"] := (cAlias)->A1_CGC
        aTail(::clientes):JSON     := aTail(::clientes):JSON:toJSON()
        BEGINCONTENT VAR cWhere
            {
                'cnpj_cpf': '%Exp:aTail(::clientes):cnpj_cpf%',
                'codigo': '%Exp:aTail(::clientes):codigo%',
                'loja': '%Exp:aTail(::clientes):loja%',
                'nome': '%Exp:aTail(::clientes):nome%',
                'tipo': '%Exp:aTail(::clientes):tipo%'
            }
        ENDCONTENT
        aTail(::clientes):JSON := strtran(cWhere, chr(10))
        (cAlias)->(dbSkip())
    end
    (cAlias)->(dbCloseArea())
return .T.

WSMETHOD SetPedVenda WSSEND msgRet WSRECEIVE pedido,itens WSSERVICE AdvplWS
    local aCabec := {}
    local aItens := {}

    if !empty(::pedido) .and. !empty(::itens)
        aAdd(aCabec, {"C5_CLIENTE", ::pedido:cliente, NIL})
        aAdd(aCabec, {"C5_LOJA",    ::pedido:loja, NIL})
        aAdd(aCabec, {"C5_CONDPAG", ::pedido:cond_pagto, NIL})
        aAdd(aCabec, {"C5_TPFRETE", ::pedido:tipo_frete, NIL})
            
        aAdd(aItens, {"C6_PRODUTO", ::itens:produto, nil})
        aAdd(aItens, {"C6_QTDVEN",  ::itens:quantidade, nil})
        aAdd(aItens, {"C6_PRCVEN",  ::itens:preco, nil})
        aAdd(aItens, {"C6_TES",     ::itens:TES, nil})
        aItens := {{aItens}}
    
        lMsErroAuto := .f.
        MSExecAuto({|a,b,c,d| MATA410(a,b,c,d)}, aCabec, aItens, 3)          

        If lMsErroAuto
            ::mensagem:erro     := .t.
            ::mensagem:status   := 402
            ::mensagem:mensagem := "Erro na inclusao do Pedido de venda "
            //MOSTRAERRO()
        Else
            ::mensagem:erro     := .f.
            ::mensagem:status   := 200
            ::mensagem:mensagem := "Pedido de venda numero: " + SC5->C5_NUM + " gerado com sucesso"
        EndIf
    else
        ::mensagem:erro     := .t.
        ::mensagem:status   := 401
        ::mensagem:mensagem := "Não foi recebido parametro com a estrutura do pedido a ser incluido"
    endif
return .t.

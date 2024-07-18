#include "totvs.ch"
#include "ApWebSrv.ch"


WSSERVICE Aula1807 DESCRIPTION "Implementação da aula dia 18/07"
    WSDATA cServerTime AS String
    WSDATA cResultado AS String OPTIONAL

    WSMETHOD GetSrvTime DESCRIPTION "Obtem data e hora atual no servidor"
ENDWSSERVICE

WSMETHOD GetSrvTime WSSEND cServerTime WSRECEIVE cResultado WSSERVICE Aula1807
    self:cServerTime := DateTimeUTC()

return .T.

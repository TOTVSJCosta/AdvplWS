#include "totvs.ch"

user function WSDLClient()
    local cURL := "http://localhost:8090/ws/AULA1807.apw?WSDL"
    local oWSDL := TWsdlManager():New()
    local xRes, oXML, cErro := ""

    if oWSDL:ParseURL(cURL)
        oWSDL:SetOperation("GETSRVTIME")

        xRes := oWSDL:GetSoapMsg()

        if oWSDL:SendSoapMsg()
            //cRes := oWSDL:GetParsedResponse()
            xRes := oWSDL:GetSoapResponse()

            oXML := XmlParser(xRes, '', @cErro, @cErro)

            xRes := OXML:_SOAP_ENVELOPE:_SOAP_BODY
            xRes := xRes:_GETSRVTIMERESPONSE:_GETSRVTIMERESULT:TEXT

            alert("Hora servidor: " + xRes)

            freeObj(oXML)
        else
            alert("erro")
        endif
    else
        conout("erro " + oWSDL:cError)
    endif
return

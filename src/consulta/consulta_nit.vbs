On Error Resume Next

' Crear el objeto de Internet Explorer
Set IE = CreateObject("InternetExplorer.Application")

' Manejo de errores al crear el objeto
If Err.Number <> 0 Then
    WScript.Echo "No se pudo crear el objeto de Buscador. Error: " & Err.Description
    WScript.Quit
End If

' Mostrar Internet Explorer y navegar a la página
IE.Visible = False
IE.Navigate "https://muisca.dian.gov.co/WebRutMuisca/DefConsultaEstadoRUT.faces"

' Esperar a que la página cargue completamente
Do While IE.Busy Or IE.ReadyState <> 4
    WScript.Sleep 20
Loop

' Buscar el campo de entrada por el atributo "name" y establecer el valor
Set inputElement = IE.Document.getElementsByName("vistaConsultaEstadoRUT:formConsultaEstadoRUT:numNit")(0)

If Not inputElement Is Nothing Then
    inputElement.Value = WScript.Arguments(0)
Else
    WScript.Echo "No se encontró el campo de entrada con el atributo 'name'."
    IE.Quit
    Set IE = Nothing
    WScript.Quit
End If

' Buscar el botón por el atributo "id" y hacer clic
Set buttonElement = IE.Document.getElementById("vistaConsultaEstadoRUT:formConsultaEstadoRUT:btnBuscar")

If Not buttonElement Is Nothing Then
    buttonElement.Click
Else
    WScript.Echo "No se encontró el botón con el atributo 'id'."
    IE.Quit
    Set IE = Nothing
    WScript.Quit
End If

' Esperar a que la página cargue completamente
Do While IE.Busy Or IE.ReadyState <> 4
    WScript.Sleep 20
Loop

' Extraer los valores necesarios y construir el JSON
Dim jsonData, id, dv, primerApellido, segundoApellido, primerNombre, segundoNombre, razonSocial, fechaActual, estado

' Extrae el valor de cada campo
id = IE.Document.getElementById("vistaConsultaEstadoRUT:formConsultaEstadoRUT:numNit").Value
dv = IE.Document.getElementById("vistaConsultaEstadoRUT:formConsultaEstadoRUT:dv").innerText

If dv = "" Then
    Dim errorMessage
    errorMessage = "{""error"": {""type"": 404, ""id"": " & id & "}}"
    WScript.Echo errorMessage
    IE.Quit
    Set IE = Nothing
    WScript.Quit
End If

primerApellido = IE.Document.getElementById("vistaConsultaEstadoRUT:formConsultaEstadoRUT:primerApellido").innerText
segundoApellido = IE.Document.getElementById("vistaConsultaEstadoRUT:formConsultaEstadoRUT:segundoApellido").innerText
primerNombre = IE.Document.getElementById("vistaConsultaEstadoRUT:formConsultaEstadoRUT:primerNombre").innerText
segundoNombre = IE.Document.getElementById("vistaConsultaEstadoRUT:formConsultaEstadoRUT:otrosNombres").innerText
razonSocial = IE.Document.getElementById("vistaConsultaEstadoRUT:formConsultaEstadoRUT:razonSocial").innerText
fechaActual = Now
estado = IE.Document.getElementById("vistaConsultaEstadoRUT:formConsultaEstadoRUT:estado").innerText

' Construir el JSON
jsonData = "{"
jsonData = jsonData & """id"": " & id & ","
jsonData = jsonData & """dv"": " & dv & ","

If razonSocial <> "" Then
    ' Si razonSocial tiene un valor, incluirla y excluir nombres y apellidos
    jsonData = jsonData & """razonSocial"": """ & razonSocial & ""","
Else
    jsonData = jsonData & """primer_apellido"": """ & primerApellido & ""","
    jsonData = jsonData & """segundo_apellido"": """ & segundoApellido & ""","
    jsonData = jsonData & """primer_nombre"": """ & primerNombre & ""","
    jsonData = jsonData & """segundo_nombre"": """ & segundoNombre & ""","
End If

jsonData = jsonData & """fecha_actual"": """ & fechaActual & ""","
jsonData = jsonData & """estado"": """ & estado & """"
jsonData = jsonData & "}"

' Cerrar el navegador y limpiar la memoria
IE.Quit
Set IE = Nothing

' Asegurarse de que el proceso de Internet Explorer se cierre completamente
WScript.Sleep 5

Set objShell = CreateObject("WScript.Shell")
objShell.Run "taskkill /F /IM iexplore.exe", 0, True
Set objShell = Nothing

' Enviar respuesta en JSON
WScript.Echo jsonData

On Error GoTo 0

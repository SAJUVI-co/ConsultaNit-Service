Option Explicit

Dim IE
Set IE = CreateObject("InternetExplorer.Application")

Sub IniciarIE()
    IE.Visible = false
    IE.Navigate "https://muisca.dian.gov.co/WebRutMuisca/DefConsultaEstadoRUT.faces"
    
    ' Esperar carga
    Do While IE.Busy Or IE.ReadyState <> 4
        WScript.Sleep 5 ' Tiempo de espera más corto
    Loop
End Sub

Function Consulta(nit)
    On Error Resume Next

    ' Buscar el campo de entrada
    Dim inputElement
    Set inputElement = IE.Document.getElementsByName("vistaConsultaEstadoRUT:formConsultaEstadoRUT:numNit")(0)

    If inputElement Is Nothing Then
        WScript.Echo "No se encontró el campo de entrada"
        Exit Function
    End If

    ' Limpiar el campo y establecer nuevo NIT
    inputElement.Value = nit
    WScript.Sleep 5 ' Tiempo de espera más corto

    ' Buscar y hacer clic en el botón
    Dim buttonElement
    Set buttonElement = IE.Document.getElementById("vistaConsultaEstadoRUT:formConsultaEstadoRUT:btnBuscar")

    If buttonElement Is Nothing Then
        WScript.Echo "No se encontró el botón"
        Exit Function
    End If

    buttonElement.Click

    ' Esperar a que cargue la respuesta
    Do While IE.Busy Or IE.ReadyState <> 4
        WScript.Sleep 5 ' Tiempo de espera más corto
    Loop

    ' Extraer información
    Dim jsonData, id, dv, primerApellido, segundoApellido, primerNombre, segundoNombre, razonSocial, fechaActual, estado
    
    ' Obtener valores de los elementos
    id = IE.Document.getElementById("vistaConsultaEstadoRUT:formConsultaEstadoRUT:numNit").Value
    Set dv = IE.Document.getElementById("vistaConsultaEstadoRUT:formConsultaEstadoRUT:dv")

    ' Si el campo dv no existe o está vacío, mostrar error y pasar al siguiente
    If dv Is Nothing Or dv.innerText = "" Then
        WScript.Echo "Error: No se encontró el DV para el NIT " & nit & ". Pasando al siguiente NIT."
        Exit Function
    End If

    dv = dv.innerText

    ' Obtener otros valores
    primerApellido = IE.Document.getElementById("vistaConsultaEstadoRUT:formConsultaEstadoRUT:primerApellido").innerText
    segundoApellido = IE.Document.getElementById("vistaConsultaEstadoRUT:formConsultaEstadoRUT:segundoApellido").innerText
    primerNombre = IE.Document.getElementById("vistaConsultaEstadoRUT:formConsultaEstadoRUT:primerNombre").innerText
    segundoNombre = IE.Document.getElementById("vistaConsultaEstadoRUT:formConsultaEstadoRUT:otrosNombres").innerText
    razonSocial = IE.Document.getElementById("vistaConsultaEstadoRUT:formConsultaEstadoRUT:razonSocial").innerText
    fechaActual = Now
    estado = IE.Document.getElementById("vistaConsultaEstadoRUT:formConsultaEstadoRUT:estado").innerText

    ' Verificar si se encontró el estado
    If estado Is Nothing Then
        estado = "No disponible"
    End If

    ' Construir el JSON
    jsonData = "{"
    jsonData = jsonData & """nit"": """ & nit & ""","
    jsonData = jsonData & """dv"": """ & dv & ""","

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

    WScript.Echo jsonData
End Function

' Iniciar IE una sola vez
IniciarIE

' Leer NITs desde el archivo
Dim fso, file
Set fso = CreateObject("Scripting.FileSystemObject")
Set file = fso.OpenTextFile("nits.txt", 1) ' Leer archivo de NITs

Do While Not file.AtEndOfStream
    Dim nit
    nit = file.ReadLine
    Consulta(nit)
Loop

file.Close
IE.Quit
Set IE = Nothing

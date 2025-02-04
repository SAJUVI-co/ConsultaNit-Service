On Error Resume Next

' Crear el objeto de Internet Explorer
Set IE = CreateObject("InternetExplorer.Application")

' Manejo de errores al crear el objeto
If Err.Number <> 0 Then
    MsgBox "No se pudo crear el objeto de Internet Explorer. Error: " & Err.Description
    WScript.Quit
End If

' Mostrar Internet Explorer y navegar a la página
IE.Visible = False
IE.Navigate "https://muisca.dian.gov.co/WebRutMuisca/DefConsultaEstadoRUT.faces"

' Esperar a que la página cargue completamente
Do While IE.Busy Or IE.ReadyState <> 4
    WScript.Sleep 10
Loop

' Buscar el campo de entrada por el atributo "name" y establecer el valor
Set inputElement = IE.Document.getElementsByName("vistaConsultaEstadoRUT:formConsultaEstadoRUT:numNit")(0)

If Not inputElement Is Nothing Then
    inputElement.Value = WScript.Arguments(0)
Else
    MsgBox "No se encontró el campo de entrada con el atributo 'name'."
    WScript.Quit
End If

' Buscar el botón por el atributo "id" y hacer clic
Set buttonElement = IE.Document.getElementById("vistaConsultaEstadoRUT:formConsultaEstadoRUT:btnBuscar")

If Not buttonElement Is Nothing Then
    buttonElement.Click
Else
    MsgBox "No se encontró el botón con el atributo 'id'."
    WScript.Quit
End If

' Esperar a que la página cargue completamente
Do While IE.Busy Or IE.ReadyState <> 4
    WScript.Sleep 10
Loop

' Extraer los valores necesarios y construir el JSON
Dim jsonData, id, dv, primerApellido, segundoApellido, primerNombre, segundoNombre, fechaActual, estado

' Extraer el valor de cada campo
id = IE.Document.getElementById("vistaConsultaEstadoRUT:formConsultaEstadoRUT:numNit").Value
dv = IE.Document.getElementById("vistaConsultaEstadoRUT:formConsultaEstadoRUT:dv").innerText
primerApellido = IE.Document.getElementById("vistaConsultaEstadoRUT:formConsultaEstadoRUT:primerApellido").innerText
segundoApellido = IE.Document.getElementById("vistaConsultaEstadoRUT:formConsultaEstadoRUT:segundoApellido").innerText
primerNombre = IE.Document.getElementById("vistaConsultaEstadoRUT:formConsultaEstadoRUT:primerNombre").innerText
segundoNombre = IE.Document.getElementById("vistaConsultaEstadoRUT:formConsultaEstadoRUT:otrosNombres").innerText
fechaActual = Now
estado = IE.Document.getElementById("vistaConsultaEstadoRUT:formConsultaEstadoRUT:estado").innerText
currentTime = Now
' descripcion = IE.Document.getElementsByClassName("fondoTituloLeftAjustado")(0).innerText
IE.Quit
Set IE = Nothing
' Construir el JSON
jsonData = "{"
jsonData = jsonData & """id"": " & id & ","
jsonData = jsonData & """dv"": " & dv & ","
jsonData = jsonData & """primer_apellido"": """ & primerApellido & ""","
jsonData = jsonData & """segundo_apellido"": """ & segundoApellido & ""","
jsonData = jsonData & """primer_nombre"": """ & primerNombre & ""","
jsonData = jsonData & """segundo_nombre"": """ & segundoNombre & ""","
jsonData = jsonData & """fecha_actual"": """ & fechaActual & ""","
jsonData = jsonData & """estado"": """ & estado & """"
' jsonData = jsonData & """descripcion"": """ & descripcion & """"
jsonData = jsonData & "}"

WScript.Echo jsonData

jsonFile.WriteLine jsonData
jsonFile.Close

On Error GoTo 0

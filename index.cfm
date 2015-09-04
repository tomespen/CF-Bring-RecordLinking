<cfsilent>
<cfscript>

request.bringcfc = createObject("component","bring").init();

request.bringcfc.params = {
	FirstName = "",
	MiddleName = "",
	LastName = "",
	AddressName = "Rødtvetveien",
	AddressNumber = "35",
	ZipCode = "0955"
};
</cfscript>

</cfsilent>
<html lang="en">
<head>
	<title>Bring API</title>
	<meta charset="UTF-8">
	<script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
</head>
<body>
	<h1>Bring API!</h1>

<cfset request.reply = request.bringcfc.singleLookup(argumentCollection=request.bringcfc.params)>
<cfset request.replym = request.bringcfc.multiLookup(argumentCollection=request.bringcfc.params)>

<cfif isJson(request.reply)>
	<cfdump var="#DeserializeJSON(request.reply)#" label="Single">
<cfelse>
	<cfdump var="#request.reply#">
</cfif>
<hr />
<cfif isJson(request.replym)>
	<cfdump var="#DeserializeJSON(request.replym)#" label="Multi">
<cfelse>
	<cfdump var="#request.replym#">
</cfif>

</body>
</html>
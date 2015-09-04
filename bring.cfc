<cfcomponent output="false">
	<cfscript>

	/**
	* @author      Tom Espen Pedersen - tom.espen.pedersen@gmail.com
	* @version     0.1.b
	* @since       2015-05-04 (4th May 2015)
	*/


	variables.bring = structNew();
	variables.bring.apiUri = "https://api.bringcrm.no/recordlinking/v2/";
	variables.bring.apiKey = "API-KEY";
	variables.bring.apiAccount = "API-ACCOUNT";
	</cfscript>

	<cffunction name="init" output="false">
		<cfreturn this>
	</cffunction>


	<cffunction name="multiLookup" output="false" returntype="any" hint="I do a multiLookup vs Bring's API">
		<!--- Query args --->
		<cfargument name="MaxMatches" 			default="10" required="false" hint="Max number of matches returned, default = 10" type="numeric">

		<!--- Person spesific args --->
		<cfargument name="Fulltext"				required="false" default="" hint="Fulltext. Searches in all fields." type="string">
		<cfargument name="FirstName"			required="false" default="" hint="FirstName" type="string">
		<cfargument name="MiddleName"			required="false" default="" hint="MiddleName" type="string">
		<cfargument name="LastName"				required="false" default="" hint="LastName" type="string">
		<cfargument name="AddressName"			required="false" default="" hint="AddressName" type="string">
		<cfargument name="AddressNumber"		required="false" default="" hint="AddressNumber" type="string">
		<cfargument name="AddressLetter"		required="false" default="" hint="AddressLetter" type="string">
		<cfargument name="ZipCode"				required="false" default="" hint="ZipCode" type="string">
		<cfargument name="City"					required="false" default="" hint="City" type="string">
		<cfargument name="Mobile"				required="false" default="" hint="Mobile" type="string">
		<cfargument name="Phone"				required="false" default="" hint="Phone" type="string">
		<cfargument name="CompanyName"			required="false" default="" hint="CompanyName" type="string">
		<cfargument name="CompanyOrgNo"			required="false" default="" hint="CompanyOrgNo" type="string">

		<cfscript>
		local.querystring = "Multi/" & arguments.MaxMatches & "?";

		if (len(trim(arguments.Fulltext)))		{ local.querystring = local.querystring & "Fulltext=" & arguments.Fulltext & "&"; }
		if (len(trim(arguments.FirstName)))		{ local.querystring = local.querystring & "FirstName=" & arguments.FirstName & "&"; }
		if (len(trim(arguments.MiddleName)))	{ local.querystring = local.querystring & "MiddleName=" & arguments.MiddleName & "&"; }
		if (len(trim(arguments.LastName)))		{ local.querystring = local.querystring & "LastName=" & arguments.LastName & "&"; }
		if (len(trim(arguments.AddressName)))	{ local.querystring = local.querystring & "AddressName=" & arguments.AddressName & "&"; }
		if (len(trim(arguments.AddressNumber)))	{ local.querystring = local.querystring & "AddressNumber=" & arguments.AddressNumber & "&"; }
		if (len(trim(arguments.AddressLetter)))	{ local.querystring = local.querystring & "AddressLetter=" & arguments.AddressLetter & "&"; }
		if (len(trim(arguments.ZipCode)))		{ local.querystring = local.querystring & "ZipCode=" & arguments.ZipCode & "&"; }
		if (len(trim(arguments.City)))			{ local.querystring = local.querystring & "City=" & arguments.City & "&"; }
		if (len(trim(arguments.Mobile)))		{ local.querystring = local.querystring & "Mobile=" & arguments.Mobile & "&"; }
		if (len(trim(arguments.Phone)))			{ local.querystring = local.querystring & "Phone=" & arguments.Phone & "&"; }
		if (len(trim(arguments.CompanyName)))	{ local.querystring = local.querystring & "CompanyName=" & arguments.CompanyName & "&"; }
		if (len(trim(arguments.CompanyOrgNo)))	{ local.querystring = local.querystring & "CompanyOrgNo=" & arguments.CompanyOrgNo & "&"; }

		/* Clean up extra &amp; at end of querystring */
		if (right(local.querystring, 1) eq "&") {
			local.querystring = left(local.querystring, (len(local.querystring)-1));
		}


		/* Create HTTP client */
		local.httpService = new http();
		local.httpService.setMethod("get"); /* Method */
		local.httpService.setCharset("utf-8");  /* Charset */
		local.httpService.setUseragent(variables.bring.apiAccount);  /* useragent = apiAccount for easier debug for Bring */

		local.httpService.setUrl(variables.bring.apiUri & local.querystring);  /* Set url and querystring */

		local.httpService.addParam(type="header", name="x-bdn-key", value=variables.bring.apiKey);  /* Set headers */
		local.httpService.addParam(type="header", name="x-bdn-account", value=variables.bring.apiAccount); /* Set headers */

		local.bringHTTP = local.httpService.send().getPrefix(); /* Send request */

		if ( isDefined("local.bringHTTP.filecontent") and len(trim(local.bringHTTP.filecontent)) and isJSON(local.bringHTTP.filecontent) ) {
			return local.bringHTTP.filecontent;
		} else {
			return local;
		}

		</cfscript>
	</cffunction>



	<cffunction name="singleLookup" output="false" returntype="any" hint="I do a singleLookup vs Bring's API">
		<!--- Washing args --->
		<cfargument name="WashDegree" 			default="5" required="false" hint="0-8. The lower the value the stricter match. For automatic processes, keep this value lower than 5. Above 5 should be handled manually. Default is 5." type="numeric">
		<cfargument name="ContactFields" 		default="KrId,Phone,Mobile,FirstName,MiddleName,LastName,StreetName,StreetNumber,StreetLetter,StreetZipCode,StreetCity,BoxName,BoxNumber,BoxOffice,BoxCity,MatchScore,Age,Gender,ReservationBRREG,DeceasedDate" required="false" type="string" hint="Fields to return, defaults all fields">
		<cfargument name="AnalyzeFields" 		required="false" default="" type="string" hint="Unknown">
		<cfargument name="ScoringModels"		required="false" default=""  type="string" hint="Unknown">

		<!--- Person spesific args --->
		<cfargument name="DateOfBirth"			required="false" default="" hint="dd.MM.yyyy" type="string">
		<cfargument name="FirstName"			required="false" default="" hint="FirstName" type="string">
		<cfargument name="MiddleName"			required="false" default="" hint="MiddleName" type="string">
		<cfargument name="LastName"				required="false" default="" hint="LastName" type="string">

		<cfargument name="AddressName"			required="false" default="" hint="AddressName" type="string">
		<cfargument name="AddressNumber"		required="false" default="" hint="AddressNumber" type="string">
		<cfargument name="AddressLetter"		required="false" default="" hint="AddressLetter" type="string">

		<cfargument name="ZipCode"				required="false" default="" hint="ZipCode" type="string">
		<cfargument name="City"					required="false" default="" hint="City" type="string">
		<cfargument name="Mobile"				required="false" default="" hint="Mobile" type="string">
		<cfargument name="Phone"				required="false" default="" hint="Phone" type="string">

		<cfscript>
		/* Build query string */
		local.querystring = "Single/" & arguments.WashDegree & "?";

		if (len(trim(arguments.ContactFields)))	{ local.querystring = local.querystring & "ContactFields=" & arguments.ContactFields & "&"; }
		if (len(trim(arguments.AnalyzeFields)))	{ local.querystring = local.querystring & "AnalyzeFields=" & arguments.AnalyzeFields & "&"; }
		if (len(trim(arguments.ScoringModels)))	{ local.querystring = local.querystring & "ScoringModels=" & arguments.ScoringModels & "&"; }

		if (len(trim(arguments.DateOfBirth)))	{ local.querystring = local.querystring & "DateOfBirth=" & arguments.DateOfBirth & "&"; }
		if (len(trim(arguments.FirstName))) 	{ local.querystring = local.querystring & "FirstName=" & arguments.FirstName & "&"; }
		if (len(trim(arguments.MiddleName))) 	{ local.querystring = local.querystring & "MiddleName=" & arguments.MiddleName & "&"; }
		if (len(trim(arguments.LastName))) 		{ local.querystring = local.querystring & "LastName=" & arguments.LastName & "&"; }

		if (len(trim(arguments.AddressName))) 	{ local.querystring = local.querystring & "AddressName=" & arguments.AddressName & "&"; }
		if (len(trim(arguments.AddressNumber))) { local.querystring = local.querystring & "AddressNumber=" & arguments.AddressNumber & "&"; }
		if (len(trim(arguments.AddressLetter))) { local.querystring = local.querystring & "AddressLetter=" & arguments.AddressLetter & "&"; }

		if (len(trim(arguments.ZipCode))) 		{ local.querystring = local.querystring & "ZipCode=" & arguments.ZipCode & "&"; }
		if (len(trim(arguments.City))) 			{ local.querystring = local.querystring & "City=" & arguments.City & "&"; }
		if (len(trim(arguments.Mobile))) 		{ local.querystring = local.querystring & "Mobile=" & arguments.Mobile & "&"; }
		if (len(trim(arguments.Phone))) 		{ local.querystring = local.querystring & "Phone=" & arguments.Phone & "&"; }

		/* Clean up extra &amp; at end of querystring */
		if (right(local.querystring, 1) eq "&") {
			local.querystring = left(local.querystring, (len(local.querystring)-1));
		}


		/* Create HTTP client */
		local.httpService = new http();
		local.httpService.setMethod("get"); /* Method */
		local.httpService.setCharset("utf-8"); /* Charset */
		local.httpService.setUseragent(variables.bring.apiAccount); /* useragent = apiAccount for easier debug for Bring */

		local.httpService.setUrl(variables.bring.apiUri & local.querystring); /* Set url and querystring */

		local.httpService.addParam(type="header", name="x-bdn-key", value=variables.bring.apiKey); /* Set headers */
		local.httpService.addParam(type="header", name="x-bdn-account", value=variables.bring.apiAccount); /* Set headers */

		local.bringHTTP = local.httpService.send().getPrefix(); /* Send request */

		if ( isDefined("local.bringHTTP.filecontent") and len(trim(local.bringHTTP.filecontent)) and isJSON(local.bringHTTP.filecontent) ) {
			return local.bringHTTP.filecontent;
		} else {
			return local;
		}

		</cfscript>
	</cffunction>



	<cffunction name="genderToString" output="false" returntype="string">
		<cfargument type="string" name="gender" required="true">

		<cfscript>
			if		(arguments.gender eq "1")	{ return "Man"; }
			else if	(arguments.gender eq "2")	{ return "Woman"; }
			else if	(arguments.gender eq "3")	{ return "Unknown"; }
			else if	(arguments.gender eq "4")	{ return "Unknown"; }
			else								{ return "Invalid"; }
		</cfscript>

	</cffunction>
</cfcomponent>
return {
-- 	MODULE SETTINGS
	ECONOMY = {
-- 		Module enabled
		Enabled = true;
		
-- 		Symbol for economy currency (ex: $, €, £, etc.)	
		Symbol = "$";

-- 		Starting balance for new players
		Starting_Balance = 100;
	};

	RP_NAME = {
-- 		Module enabled.
--		If disabled, you can create plugins to hook into the datastore and create your own RP name.
--		Functions are provided for formatting the name like below.
		Enabled = true;

-- 		Default color for the RP name
		Default_Color = Color3.fromRGB(255, 255, 255); 

--[[	Should players be able to change their own names.
		NOTICE: This will allow name change client requests from all users.
		If you want to restrict name changing to the server or commands, set this to false.
]]		Allow_Player_Entry = true; 

-- 		Maximum length of the RP name.
		Max_Name_Length = 20;
		
--[[	Display key for each user. You can use custom tags here.
		Format:

		{RPNAME}: The RP name of the user.
		{USERNAME}: The username of the user.
		{DISPLAYNAME}: The user's display name. This will default to their username.

		{MONEY}: The user's money. This does not include the currency prefix.
		{MONEY_FULL}: The user's money. This includes the currency prefix.

		{GROUPRANK:<GROUPID>}: ex. {GROUPRANK:1234567} will display the user's rank in the group with the ID 1234567.
		{GROUPROLE:<GROUPID>}: ex. {GROUPROLE:1234567} will display the user's role in the group with the ID 1234567.

		{CUSTOM:TAG}: A custom tag that you can set up in your scripts. ex. {CUSTOM:TEST}.

		You can use rich text in this. ex. {RPNAME} <b>is cool</b>!
]]		Display_Type = "{RPNAME} (@{USERNAME}) {GROUPROLE:17281326} {MONEY_FULL} {DISPLAYNAME} {CUSTOM:TEST}",

-- 		Cost to change name, does nothing if ECONOMY module is disabled.
		Name_Change_Cost = 0; 
	};

	DATA = {
-- 		Module enabled
		Enabled = true;

-- 		Data Key used to access the datastore. You can make this any string.
-- 		Note that changing this after using the framework WILL result in data loss.
		Data_Key = "SRPFrameworkData";

--		Determines whether the framework automatically saves or not.
		Auto_Save = true;

-- 		Determines how often (In seconds) the framework should automatically save data.
		Auto_Save_Interval = 60;

	};


-- 	GENERAL SETTINGS

-- 	Camera mode for players
	CAMERA_MODE = "Default"; -- {"ForceFirstPerson", "ForceThirdPerson", "Default"}

--[[ 	
⚠ DO NOT TOUCH ANYTHING BELOW THIS LINE UNLESS YOU KNOW WHAT YOU'RE DOING ⚠

Below are all of the internal settings for the framework. You won't need to worry about touching
any of these unless you're adding new modules or editing existing ones, even then there probably isn't
a reason to touch these. Most of these are used for internal purposes and are not meant to be changed,
and changing them in a way that is not intended may cause the framework to break or not work properly.
I will not provide support for any issues that arise from changing these settings. You have been warned.

------------------------------------------------------------------------------------------------------------------------]]
	VERSION = 0.1
}


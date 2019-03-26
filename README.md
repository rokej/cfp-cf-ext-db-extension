# This extension modifies the deployment manifest to use external databases.
## Clone the cfp-cf-ext-db-extension repository
It is recommended to apply all this extension before the initial deployment. If you apply this after the initial deployment, it requires re-deployment which will cause data loss.

## Preparing external databases
You must prepare external databases prior to applying the extension. All required databases can be created on different database servers but the database server type and the connection port number must be the same. MySQL and Postgres are currently supported.
1. Log into database server(s) and create these databases. Optionally you can name these databases differently. Make note of the names and use them later when you configure the extension.
	- cloud_controller
	- credhub
	- diego
	- locket
	- network_connectivity
	- network_policy
	- routing-api
	- uaa
2. If you are using Postgres database, connect to each database and install citext extention using the following SQL.
```
create extension citext;
```
3. Ensure that the connection port is open in the firewall and remote connection is allowed for these databases.

## Creating the extension zip
Clone this git repository and in the project root, create the extension zip file.
```
zip -r ../cfp-cf-ext-db-extension.zip *
```

## Registering the extension
1. Copy the zip file to the IBM Cloud Foundry installer directory of the inception VM.
2. Run the following command to register the extension. Ensure the extension zip file path is correct.
```
./cm extension -e cfp-cf-ext-db-extension register -p ./cfp-cf-ext-db-extension
```
3. You must configure the extension. You can do this in command line or using Cloud Foundry deployment tool UI.

## Configuring the extension in command line
1. Create the ext-db-uiconfig.yml file in the IBM Cloud Foundry installer directory using the following content as an example. Replace with the actual values.
```YAML
uiconfig:
  bbs_db_host: 9.21.107.54
  bbs_db_name: diego
  bbs_db_password: postgres
  bbs_db_user: postgres
  cc_db_host: 9.21.107.54
  cc_db_name: cloud_controller
  cc_db_password: postgres
  cc_db_user: postgres
  configuration_name: externaldb
  credhub_db_host: 9.21.107.54
  credhub_db_name: credhub
  credhub_db_password: postgres
  credhub_db_user: postgres
  db_port: 5432				# This port number is used to connect to all databases.
  db_type: postgres		# This database type is used for all databases. Valid values are postgres or mysql.
  locket_db_host: 9.21.107.54
  locket_db_name: locket
  locket_db_password: postgres
  locket_db_user: postgres
  policy_server_db_host: 9.21.107.54
  policy_server_db_name: network_policy
  policy_server_db_password: postgres
  policy_server_db_user: postgres
  routing_api_db_host: 9.21.107.54
  routing_api_db_name: routing-api
  routing_api_db_password: postgres
  routing_api_db_user: postgres
  silk_controller_db_host: 9.21.107.54
  silk_controller_db_name: network_connectivity
  silk_controller_db_password: postgres
  silk_controller_db_user: postgres
  uaa_db_host: 9.21.107.54
  uaa_db_name: uaa
  uaa_db_password: postgres
  uaa_db_user: postgres
```
2. In the IBM Cloud Foundry installer directory, run this command to save the extension configuration.
```
./cm extension -e cfp-cf-ext-db-extension save -c ext-db-uiconfig.yml
```
3. Insert the extension in the main deployment.
```
./cm states insert -i cfp-cf-ext-db-extension
```

## Configuring the extension using Cloud Foundry deployment tool UI
1. Log into the Cloud Foundry deployment tool UI.
2. Click on the main menu icon at the top left corner and choose `1. Register new extensions`.
3. Find `cfp-cf-ext-db-extension` and click on the `+` button to insert the extension in the main deployment.
4. Click on the main menu icon at the top left corner and choose `2. Configuration`.
5. Choose `External database` configuration for `cfp-cf-ext-db-extension` extension and click on the pencil to edit the configuration.
6. Provide all required values under each database tab.
7. Save and exit.


Now the extension is part of the main deployment steps to deploy Cloud Foundry with the external databases.


_Note: If you have trouble loading changes to the extension with the same name, do an unregister first, then register the extension again._
```
./cm extension -e cfp-cf-ext-db-extension unregister
```

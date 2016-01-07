## Overview
Build docker images with (BigFix) Endpoint Manager components like the server
and the agent.  See the READMEs in beserver and the individual OS folders in besclient for details.

The besserver now includes a Vagrant box so the server can be provisioned into a Vagrant VM, see the besserver README for details.

BES_CLIENT=NUMBER OF ENDPOINTS
E.G.
BES_CLIENT=1 (produces 1 x CentOS6 Endpoint, 1 x CentOS7 Endpoints, 1 x Ubuntu14 Endpoint. 3 Endpoints Total)
BES_CLIENT=2 (produces 2 x CentOS6 Endpoint, 2 x CentOS7 Endpoints, 2 x Ubuntu14 Endpoint. 6 Endpoints Total)
BES_CLIENT=3 (produces 3 x CentOS6 Endpoint, 3 x CentOS7 Endpoints, 3 x Ubuntu14 Endpoint. 9 Endpoints Total)

***************************************************************************************************
Launch vagrant with the following command to use default settings with Evaluation Licence version
***************************************************************************************************
./launchInstall.sh 3 9.2.6.94 true true true license up

where arguments are as follows:
    3 == The number of client sets to generate
    9.2.6.94 == The bigfix version to be installed
    true == Accepts bigfix license
    true == Run dashboard variable creation scripts (populates the dashboard with data after configuration)
    true == Run scripts to ensure all specified sites are gathered and assigned to, will wait until all specified sites have gathered
    license == License type to use, can be 'license' for full license use or 'eval' for evaluation user
    up == Vagrant command to allow running of the Vagrantfile to create vm and initiate deployment processes
    *final additional variable* can be used to provision an existing machine if it not running.
    example:
        ./launchInstall.sh 3 9.2.6.94 true true true license up --provision
            or if the machine is still running
        ./launchInstall.sh 3 9.2.6.94 true true true license provision
***************************************************************************************************
Note: for new licence versions, you must have either a license.BESLicenseAuthorization file or a license.pvk and license.crt file 
stored in the directory bfdocker/besserver/remotedb/license/ before deployment. If all three files are present the deployment will
use the .crt and .pvk files over the .BESLicenseAuthorization file, so if a new license is to be used ensure to delete old .pvk, 
.crt and .BESLicenseAuthorization files from this directory and insert new .BESLicenceAuthorization file. It is recommended to only
use the generated .pvk and .crt files from the authorization file used in the this deployment as usernames and passwords must
match in order to work correctly.
***************************************************************************************************

--------------------
to connect console:
--------------------
hostname: 127.0.0.1
port: 2222
username: EvaluationUser
pass: BigFix1t4Me

--------------------
to destroy vagrant vm:
--------------------
VAGRANT_DETECTED_OS=cygwin vagrant destroy

--------------------------------------
some hepler commands for development:
--------------------------------------
python checkSiteGathered.py localhost "EvaluationUser:BigFix1t4Me" "Bigfix4QRadar Test" 30 200 30 10 "domain" 52311
python subscribeSiteToAllComputers.py localhost "EvaluationUser:BigFix1t4Me" "Bigfix4QRadar Test" 200 60 "domain" 52311
-----------------------------------------------------------------------------------------------------------------------
***************************************************************************************************

## Quick-Tip:
For a quick set-up, run the lanuchInstall.sh script in cygwin with no arguments - 
This will convert all of the .sh and .txt files it finds in the project directory from dos 
format to unix in case the scripts were modified with windows crlf formatted line endings. 
Running the launchInstall.sh script with no arguments will convert files and run vagrant up
with the default values of: 
	BES_CLIENT=2 BES_VERSION=9.2.6.94 BF_ACCEPT=true DASH_VAR=true PYTHON_SCRIPTS=true LICENSE_TYPE=eval up (With Evaluation License)
Example:
	./launchInstall.sh
You can also run the script and specify just the number of client machine sets you want to
create (a set includes one centOS6, one centOS7 and one Ubuntu client), with the remaining 
values still set to default, though you may specify the remaining values also if you wish,
for example:
	./launchInstall.sh 5 		Will create 5 sets of clients with default settings and evaluation licence
	./launchInstall.sh 5 9.X.X.X true true true	eval up    	Will create 5 sets of clients with a specified bigfix version on evaluation licence
	./launchInstall.sh 5 9.X.X.X true true true	license    	Will create 5 sets of clients with a specified bigfix version on production licence using .BESLicenceAuthorization file
        or the license.pvk and license.crt files if they are present
	./launchInstall.sh 5 9.X.X.X true true true	license up --provision 	For provisioning changes on boot-up
	./launchInstall.sh 5 9.X.X.X true true true	license provision 		For provisiong changes while VM is still running
##
***************************************************************************************************
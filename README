IBM MDM Log Analyzer
--------------------

This application was designed for a wide purpose. You can run a script into
the MDM server box and it will stream the `performance.log` to another
box, so it can process it and run the web server.

It is good to avoid unnecessary CPU overhead, since you can see the
transactions in real time.

Sometimes, the MDM generates a `performance.log` that's so big you won't
have enough space to keep all the logs in the file system. In a particular
client, the MDM log throughput was about 5GB/minute, so every minute the
`performance.log[1-10]` files rotated and in the end of the day we just
had one minute wide `performance.log[1-10]`.

#### Usage: ####

    [MDM Server] --streaming--> [Application Server]

You can also run both on the same machine. What usually happens though is
you get the `performance.log` from the costumer and analyze it offline
in your own box.

You will have amazing graphics to help you, and this tool is 100% open
source, so you can add features easily and share them with your team.

#### Configuration: ####

##### PUBLIC KEY TRUST LOGIN #####

Whichever way you plan on using this, first you'll need to be able to do
automatic logins using a public key.

If you'll run the collector script on the [MDM Server], run the following
commands on it. If, however, you'll run everything on the same box, run
the following commands on said box:

     $ ssh-keygen # press enter in all fields

Now we'll create the public key relationship. Get the `~/.ssh/id_rsa.pub`
file from the machine where you will run the collector script from. Copy
this and paste onto the [Application Server]'s `~/.ssh/authorized_keys`.

If you are running everything on the same machine, you can simply do:

    $ cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys

Now you can test it:

    $ ssh youruser@appmachine

If it doesn't ask for a password, it's working :)

##### Step 2 #####

Go to "`IBM-MDM-LogAnalyzer/script/load`".

Open the file "`script.sh`". You'll need to edit two evariables:
`HOME_PATH` which is the directory in your machine like
"`/home/hadoop/apps/IBM-MDM-LogAnalyzer`" and `DB2_HOME` which is where
your "`sqllib`" is. This script is responsible for parsing the
`performance.log` file and insert it into DB2.

Now open the "`streaming.sh`" file. You'll need to edit the variable
`LOCAL_MDM_DIR_LOGS` which will be the place where the `performance.log`
files are generated, like "`/opt/IBM/WebSphere/Profile/.../AppSrv01/logs`"
and the variable `REMOTE_SCRIPT_EXEC` which will be the same
as `HOME_PATH`. You'll also need to change your `USERNAME` and `IPADDRESS`
on that file.

Next, edit the
"`IBM-MDM-LogAnalyzer-master/lib/IBM/MDM/LogAnalyzer/Model/DB.pm`" file
and put your database informations in it.

#### BULK LOAD ####

Don't forget to configure the `IBM-MDM-LogAnalyzer/script/load/sql/load.pl`
file. You'll need to set up your user name, password and your
"`IBM-MDM-LogAnalyzer/script/load/sql`" directory.

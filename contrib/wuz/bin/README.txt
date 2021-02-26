Things you might want to do to get these two scripts running:

mv amijailed.sh and unjailme.exp in /home/<your user>/bin/

make sure to fill in variables in amijailed.sh

touch /var/log/althea_jailed.log

and set up  a crontab

 */5 * * * *  /home/ubuntu/bin/amijailed.sh >> /var/log/althea_jailed.log


Note that currently this script can run not as root.  If we add the LED stuff then we need to run as root.


to run unjailme.exp you'll need to run the following command:

sudo apt-get install expect

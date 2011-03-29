http://prdownloads.sourceforge.net/awstats/awstats-7.0.tar.gz

Sorry, configure.pl does not support automatic add to cron yet.
You can do it manually by adding the following command to your cron:
/usr/local/awstats/wwwroot/cgi-bin/awstats.pl -update -config=6693.cc
Or if you have several config files and prefer having only one command:
/usr/local/awstats/tools/awstats_updateall.pl now

A SIMPLE config file has been created: /etc/awstats/awstats.6693.cc.conf
You should have a look inside to check and change manually main parameters.
You can then manually update your statistics for '6693.cc' with command:
> perl awstats.pl -update -config=6693.cc
You can also build static report pages for '6693.cc' with command:
> perl awstats.pl -output=pagetype -config=6693.cc

Press ENTER to finish...


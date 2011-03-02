#!/usr/bin/env python
import sys
import telnetlib 

HOST="localhost" 
PORT="6667" 
MSG=sys.argv[1]

bot=telnetlib.Telnet(HOST, PORT) 
bot.read_until("go on") 
bot.write("NICK root_\n") 
bot.write("USER root_ 8 * : root_\n") 
bot.read_until("identify yourself") 
bot.write("PASS xhbot\n") 
bot.read_until("&bitlbee +v lotreal") 
bot.write("PRIVMSG &bitlbee :lotreal," + MSG + "\n") 
bot.write("QUIT\n") 
bot.close()

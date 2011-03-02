#!/usr/bin/env python
# #TODO# timeout return error exitcode:2
import sys
import telnetlib 

HOST="localhost" 
PORT="6667" 
MSG=sys.argv[1]

bot=telnetlib.Telnet(HOST, PORT)
bot.read_until("go on")
bot.write("NICK lot\n")
bot.write("USER lot 8 * : lot\n")

bot.read_until("identify yourself")
bot.write("PASS autosrv_bot\n")

bot.read_until("&bitlbee +v lotreal")
bot.write("PRIVMSG &bitlbee :lotreal," + MSG + "\n")
bot.write("QUIT\n")
bot.close()

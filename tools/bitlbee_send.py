#!/usr/bin/env python
# #TODO# timeout return error exitcode:2
import sys
import telnetlib 

HOST="localhost" 
PORT="6667" 
MSG=sys.argv[1]

bot=telnetlib.Telnet(HOST, PORT)
# bot.set_debuglevel(9)

bot.read_until("go on", 5)
bot.write("NICK lot\n")
bot.write("USER lot 8 * : lot\n")

bot.read_until("identify yourself", 5)
bot.write("PASS autosrv_bot\n")

bot.read_until("lotreal", 5)
bot.write("PRIVMSG &bitlbee :lotreal," + MSG + "\n")
bot.write("QUIT\n")
bot.close()

#!/usr/bin/env python
import sys
import telnetlib 

HOST="localhost" 
PORT="6667" 
MSG="bitlbee init success! ^^"

bot=telnetlib.Telnet(HOST, PORT) 
bot.read_until("go on") 
bot.write("NICK lot\n") 
bot.write("USER lot 8 * : Luo Tao\n") 
bot.read_until("identify yourself")

bot.write("PRIVMSG &bitlbee :register autosrv_bot\n")
bot.read_until("Account successfully created")

bot.write("PRIVMSG &bitlbee :account add jabber xxoo@gmail.com xxooxxoo talk.google.com:5223:ssl\n")
bot.read_until("Account successfully added")

bot.write("PRIVMSG &bitlbee :account on\n")
bot.read_until("Logged in")

bot.write("PRIVMSG &bitlbee :save\n")
bot.read_until("Configuration saved")

bot.write("PRIVMSG &bitlbee :lotreal," + MSG + "\n")
bot.write("QUIT\n") 
bot.close()

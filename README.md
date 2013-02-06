#Synopsis

Sandid is a router password brute forcer was created as proof of concept that we can automate the process checking of whatever the user has changed the default password that come shipped with the new router from Maroc Telecom

#Options

  --ip-addrs, -i <s>: IP address singel or a range
  
  --verbose, -v:      Activate the verbose mode
  
  --timeout, -t <i>:  Set time out (default: 1)
  
  --threads, -h <i>:  Set the number of threads (default: 10)
  
  --export, -e <s>:   Export the results to file
  
  --help, -l:   	  Show this message

#How does it work 

First it scan a range of ip address
then it check if the default passwords are used
login to the router and get PPP password that authenticate the user to the ISP internal network
and then export the list of PPP usernames and passowrds found 

#Disclaimer

This programme was writing for educational purpose only and to to raise awareness of the risk of the default configuration to push users and hopefully the ISP it self to change this situation also you can't hold me responsible for for any kind of lost of data or hardware damage that this programme can cause
use it at your own risque.

Senid a été crée à des fins éducatives mais aussi pour sensibiliser les gens et les FAI aux risques des configurations par défaut des routeurs, en espérant qu'ils réagissent pour changer cette situation. Sendi est à utiliser uniquement sur votre propre matériel, vous êtes seule responsable de tout type de dommages matériels ou immatériels que vous avez causé à vous-même ou à un tiers en utilisant Sendid.

#Licence 

Licensed under Creative Commune  Attribution-ShareAlike 3.0


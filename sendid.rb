require 'socket'
require 'timeout'
require 'net/telnet'
require './lib_trollop.rb'
require './func.rb'

args = Trollop::options do
	opt :ip_addrs , "IP address singel or a range", :type => :string
	opt :verbose  , "Activate the verbose mode"
	opt :timeout  , "Set time out", :default => 1
	opt :threads  , "Set the number of threads", :default =>10
	opt :export	  , "Export the results to file", :type => :string
end

Trollop::die :ip_addrs,"Argument missing" if args[:ip_addrs] == nil
Trollop::die :timeout, "Must be non-negative" if args[:timeout] <= 0
Trollop::die :threads, "Must be non-negative" if args[:threads] <= 0
Trollop::die :export , "Argument missing" if args[:export] == nil


$alive_hosts = Array.new
$verbose = args[:verbose]
$timeout = args[:timeout]
$threads_num = args[:threads]

ip_in = args[:ip_addrs]

begin



	time_start=Time.now
	hosts=ipgen(ip_in) 
	time_end=Time.now
	puts "[*] #{hosts.count} Ip adress generated in #{time_end - time_start} seconds" if $verbose && hosts.count > 1

	_ = "[*] starting the scan of #{hosts.count} hosts"
	_ = "[*] starting the scan of one host" if hosts.count == 1
	puts _

	time_start=Time.now

	threads=[]
	hosts.each do |host|

		if(Thread.list.count % $threads_num != 0) 
	    	mythread = Thread.new do
	    		scan(host)  
	    	end
	    threads << mythread
		else

	    	threads.each do |thread|
	      		thread.join
	    	end

	    	mythread = Thread.new do
	    		scan(host)
	    	end
	    threads << mythread
	  	end
	end

	threads.each do |thread|
		thread.join
	end	

	time_end=Time.now

	_ =  "[*] found #{$alive_hosts.count} alive hosts in #{time_end - time_start} seconds"
	_ =  "[*] found one alive host in #{time_end - time_start} seconds" if $alive_hosts.count == 1
	puts _
	
	puts "[*] alive hosts:" if $verbose  && $alive_hosts.count != 0


	puts "[*] start checking for hosts with weak password"

	time_start = Time.now

	$alive_hosts.each do |host|
		host_crd = checkpwd(host)
		if host_crd != nil
			output= "[*] the host:#{host}\n[+] #{host_crd["usr"]}\n[+] #{host_crd["pwd"]}\n"
			print output
			export(args[:export],output)
		else
			puts "[D] empty host_crd" 
		end 
	end
	
	time_end = Time.now

	puts "finished checking host in #{time_end - time_start} seconds"

rescue (Interrupt)
	puts "\n[*] Interrupted !!"
end
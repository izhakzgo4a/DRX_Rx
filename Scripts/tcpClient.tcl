set channel [socket localhost 12345]
 
while {[gets $channel line] > -1} {
    puts "\nReceived: $line"

    # Split the request line into words
    set wordList [regexp -inline -all -- {\S+} $line]
    set n [llength $wordList] ; # n is the length of the words list.

    # The format of the request is either:
    #  1.  "RegRd <hex-address>"  (n = 2)
    #  2.  "RegWr <hex-address> <hex-value>" (n = 3)

    if {$n == 2 && [lindex $wordList  0] eq "RegRd"} {
        set regAddr [lindex $wordList  1]    ; # extract the address

        # Read data from the specified address in hardware ..
        create_hw_axi_txn read_txn [get_hw_axis hw_axi_1] -type READ -address $regAddr -len 1 -force
        run_hw_axi [get_hw_axi_txns read_txn]
		set resp [report_hw_axi_txn [get_hw_axi_txns read_txn]]

        # Split the respond into words
        set respList [regexp -inline -all -- {\S+} $resp]
        set regData [lindex $respList end] ; # extrat the last item (the register data)

        # Send acknowledgment
        puts $channel "ack $regData"
        flush $channel
    } elseif {$n == 3 && [lindex $wordList  0] eq "RegWr"} {
        set regAddr [lindex $wordList  1]     ; # extract the address
        set regData [lindex $wordList  2]     ; # extract the value

        # Write the given value to the specified address in hardware:
        create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -type WRITE -address $regAddr -len 1 -data $regData -force
        run_hw_axi [get_hw_axi_txns write_txn]

        # Send acknowledgment
        puts $channel "ack 0"
        flush $channel
    } elseif {$n == 2 && [lindex $wordList  0] eq "hello"} {

        # Write the given value to the specified address in hardware:
        
        # Send acknowledgment
        puts "Invalid Request!"
        puts $channel "hello server"
        flush $channel
    }  else {
        puts "Invalid Request!"
        puts $channel "err invalid request"
        flush $channel
    }
}
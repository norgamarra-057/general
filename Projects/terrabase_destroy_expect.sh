#!/usr/bin/expect
set timeout -1
set dir [lindex $argv 0]

spawn terrabase destroy $dir
expect {
    "Are you sure you want to DESTROY this?" { send "y\r" }
}
expect eof


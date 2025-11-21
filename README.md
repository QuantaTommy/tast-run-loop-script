# tast-run-loop-script
Script to automatically run tast item in loop

# Usage
bash run_tast_loop.sh <ip> <test-item> <loop>

# Arguments
 - ip: DUT network IP address (Check with `ifconfig` on DUT)
 - test-item: test item of tast to run
 - loop: How many loops to run with tast

# Note
All tast run logs will be saved in tast_log_saved and separated to pass and fail cases.
There will also be tast_run_record.txt to display how many pass and fail times of tast run.

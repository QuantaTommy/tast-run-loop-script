#!/bin/bash

# Config arguments
ip=$1
item=$2
loop=$3
pass_count=0
fail_count=0
tast_log_dir="/mnt/host/source/out/tmp/tast/results"
tast_log_saved="tast_log_saved"
tast_log_saved_pass="$tast_log_saved/pass"
tast_log_saved_fail="$tast_log_saved/fail"
tast_run_record="$tast_log_saved/tast_run_record.txt"

# Create tast_log_saved folder to save tast_log if not created
if [ ! -d "$tast_log_saved" ]; then
  mkdir "$tast_log_saved"
fi

# Create pass and fail folders in tast_log_saved to save all tast_log separated by pass or fail case
# Remove all old tast_log
if [ ! -d "$tast_log_saved_pass" ]; then
  mkdir "$tast_log_saved_pass"
else
  rm -rf "$tast_log_saved_pass"/*
fi

if [ ! -d "$tast_log_saved_fail" ]; then
  mkdir "$tast_log_saved_fail"
else
  rm -rf "$tast_log_saved_fail"/*
fi

# Remove old tast_run record
if [ -f "$tast_run_record" ]; then
  rm "$tast_run_record"
fi

# tast run loop
while [ $loop != 0 ]; do
  tast run $ip $item

  # Get latest log file
  latest_log_folder="$tast_log_dir/latest"
  latest_log_folder_contents="$(ls -l $latest_log_folder)"
  latest_log_folder_contents_array=($latest_log_folder_contents)
  tast_results_log_folder_name=${latest_log_folder_contents_array[-1]}

  # Check if test result is fail
  if grep -q "FAIL" "$tast_log_dir/$tast_results_log_folder_name/full.txt"; then
    cp -r "$tast_log_dir/$tast_results_log_folder_name" "$tast_log_saved_fail/$tast_results_log_folder_name"
    (( fail_count++ ))
  else
    cp -r "$tast_log_dir/$tast_results_log_folder_name" "$tast_log_saved_pass/$tast_results_log_folder_name"
    (( pass_count++ ))
  fi
  
  # Record current pass and fail in total
  printf "tast run record:\nPass: $pass_count\nFail: $fail_count\n" > "$tast_run_record"

  (( loop-- ))
done

# Can set up a SSH key-based authentication if needed -- generate a key pair on a local machine using ssh-keygen and then copy public key to target machine using ssh-copy-id ubuntu@192.168.190
# Can also set up a passwordless SSH (need to install) -- sshpass -p 'your_password' ssh ubuntu@192.168.190

# sudo apt install tmux
# Execute the script once before use: chmod +x run_turtlebot.sh
# Use ./run_turtlebot.sh to run

#!/bin/bash

# Start a new tmux session
tmux new-session -d -s turtlebot

# Terminal 1: roscore
tmux send-keys -t turtlebot "roscore" C-m

# Wait for roscore to initialize
sleep 5

# Terminal 2: SSH and bring up turtlebot
tmux split-window -h
tmux send-keys -t turtlebot "ssh ubuntu@192.168.190" C-m
sleep 2  # Allow time for the SSH connection
# Assuming passwordless SSH is set up; if not, install and use sshpass
tmux send-keys -t turtlebot "turtlebot" C-m
sleep 2  # Allow time for the turtlebot command
tmux send-keys -t turtlebot "roslaunch turtlebot3_bringup turtlebot3_robot.launch" C-m

# Terminal 3: Teleop
tmux split-window -v
tmux send-keys -t turtlebot "export TURTLEBOT3_MODEL=\$burger" C-m
tmux send-keys -t turtlebot "roslaunch turtlebot3_teleop turtlebot3_teleop_key.launch" C-m

# Terminal 4: RQT
tmux split-window -h
tmux send-keys -t turtlebot "rqt" C-m

# Terminal 5: SLAM
tmux split-window -v
tmux send-keys -t turtlebot "export TURTLEBOT3_MODEL=burger" C-m
tmux send-keys -t turtlebot "roslaunch turtlebot3_slam turtlebot3_slam.launch" C-m

# Attach to the tmux session
tmux attach-session -t turtlebot

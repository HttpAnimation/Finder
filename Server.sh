#!/bin/bash

# Default port number
default_port=6558

# Default log file path
default_log_file="server.log"

# Default index.html path
default_index_file="index.html"

# Maximum number of concurrent connections
max_connections=100

#!/bin/bash

# Check if python3 is installed and install it if not found
if ! command -v python3 >/dev/null; then
  echo "Python3 is not found. Installing Python3..."
  sudo apt update
  sudo apt install -y python3
fi

# Check if php is installed and install it if not found
if ! command -v php >/dev/null; then
  echo "PHP is not found. Installing PHP..."
  sudo apt update
  sudo apt install -y php
fi

# Get local IP address
ip_address=$(hostname -I | awk '{print $1}')

# Function to check if a port is available
check_port() {
  local port=$1
  (exec 3<>/dev/tcp/localhost/$port) >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    exec 3>&-
    exec 3<&-
    return 1
  else
    exec 3<&-
    return 0
  fi
}

# Function to check if the maximum number of connections has been reached
check_max_connections() {
  local current_connections=$(netstat -ant | grep ESTABLISHED | wc -l)
  if [ "$current_connections" -ge "$max_connections" ]; then
    echo "Maximum number of connections reached. Unable to start the server."
    exit 1
  fi
}

# Function to log server startup information
log_startup_info() {
  local startup_info=$1
  local log_file=$2
  echo "$startup_info" >> "$log_file"
}

# Function to display an error message for missing required options
display_missing_option_error() {
  local option_name=$1
  echo "Missing required option: -$option_name" >&2
  exit 1
}

# Function to stop the server gracefully
stop_server() {
  echo "Stopping the server..."
  kill $server_pid
  wait $server_pid >/dev/null 2>&1
  delete_log_file
}

# Function to delete the log file
delete_log_file() {
  rm -f "$log_file"
}

# Register the stop_server function to catch termination signals
trap stop_server SIGINT SIGTERM

# Set default port if not provided
port=$default_port

# Set default timeout to -NoTimeOut
timeout="-NoTimeOut"

# Parse command line arguments
while getopts "p:t:l:i:e:cd:a:n:s:x:y:o:r:z:6m:gfu:C:H:S:E:qB:U:P:RL:X:Z:j:k:w:y:v:h" opt; do
  case ${opt} in
    p)
      port=$OPTARG
      ;;
    t)
      timeout=$OPTARG
      ;;
    l)
      log_file=$OPTARG
      ;;
    i)
      index_file=$OPTARG
      ;;
    e)
      error_log_file=$OPTARG
      ;;
    c)
      enable_cgi=true
      ;;
    d)
      enable_directory_listing=true
      ;;
    a)
      server_address=$OPTARG
      ;;
    n)
      server_hostname=$OPTARG
      ;;
    s)
      enable_ssl=true
      ;;
    x)
      ssl_certificate=$OPTARG
      ;;
    y)
      ssl_key=$OPTARG
      ;;
    o)
      enable_access_log=true
      access_log_file=$OPTARG
      ;;
    r)
      enable_log_rotation=true
      ;;
    z)
      log_rotation_size=$OPTARG
      ;;
    6)
      enable_ipv6=true
      ;;
    m)
      server_name=$OPTARG
      ;;
    g)
      enable_gzip=true
      ;;
    f)
      enable_caching=true
      ;;
    u)
      cache_control_header=$OPTARG
      ;;
    C)
      enable_cors=true
      ;;
    H)
      cors_header=$OPTARG
      ;;
    S)
      enable_ssi=true
      ;;
    E)
      ssi_file_extension=$OPTARG
      ;;
    q)
      quiet_mode=true
      ;;
    B)
      enable_basic_auth=true
      ;;
    U)
      username=$OPTARG
      ;;
    P)
      password=$OPTARG
      ;;
    R)
      enable_https_redirection=true
      ;;
    L)
      redirection_url=$OPTARG
      ;;
    X)
      enable_server_side_scripting=true
      ;;
    Z)
      server_side_script_extension=$OPTARG
      ;;
    j)
      enable_request_logging=true
      ;;
    k)
      request_log_file=$OPTARG
      ;;
    w)
      enable_url_rewriting=true
      ;;
    y)
      rewrite_rules=$OPTARG
      ;;
    v)
      debug_mode=true
      ;;
    h)
      echo "Usage: ./start_server.sh [-p <port>] [-t <timeout>] [-l <log_file>] [-i <index_file>] [-e <error_log_file>] [-c] [-d] [-a <address>] [-n <hostname>] [-s] [-x <ssl_certificate>] [-y <ssl_key>] [-o <access_log_file>] [-r] [-z <rotation_size>] [-6] [-m <server_name>] [-g] [-f] [-u <cache_control_header>] [-C] [-H <cors_header>] [-S] [-E <ssi_file_extension>] [-q] [-B] [-U <username>] [-P <password>] [-R] [-L <redirection_url>] [-X] [-Z <server_side_script_extension>] [-j] [-k <request_log_file>] [-w] [-y <rewrite_rules>] [-v] [-h]"
      echo "Options:"
      echo "  -p <port>                 Set the port number (default: $default_port)"
      echo "  -t <timeout>              Set the server timeout in seconds (default: -NoTimeOut)"
      echo "  -l <log_file>             Set the path to the log file (default: $default_log_file)"
      echo "  -i <index_file>           Set the path to the index.html file (default: $default_index_file)"
      echo "  -e <error_log_file>       Set the path to the error log file"
      echo "  -c                        Enable CGI support"
      echo "  -d                        Enable directory listing"
      echo "  -a <address>              Set the server address to bind"
      echo "  -n <hostname>             Set the server hostname"
      echo "  -s                        Enable SSL/TLS encryption"
      echo "  -x <ssl_certificate>      Set the path to the SSL certificate file"
      echo "  -y <ssl_key>              Set the path to the SSL key file"
      echo "  -o <access_log_file>      Enable access log and set the path to the access log file"
      echo "  -r                        Enable log rotation"
      echo "  -z <rotation_size>        Set the log rotation size in bytes"
      echo "  -6                        Enable IPv6 support"
      echo "  -m <server_name>          Set the custom server name"
      echo "  -g                        Enable Gzip compression"
      echo "  -f                        Enable caching"
      echo "  -u <cache_control_header> Set the Cache-Control header value"
      echo "  -C                        Enable CORS support"
      echo "  -H <cors_header>          Set the Access-Control-Allow-Origin header value"
      echo "  -S                        Enable server-side includes (SSI)"
      echo "  -E <ssi_file_extension>   Set the server-side includes file extension"
      echo "  -q                        Enable quiet mode"
      echo "  -B                        Enable basic authentication"
      echo "  -U <username>             Set the username for basic authentication"
      echo "  -P <password>             Set the password for basic authentication"
      echo "  -R                        Enable HTTPS redirection"
      echo "  -L <redirection_url>      Set the custom URL for redirection"
      echo "  -X                        Enable server-side scripting"
      echo "  -Z <server_side_script_extension> Set the server-side script extension"
      echo "  -j                        Enable request logging"
      echo "  -k <request_log_file>     Set the path to the request log file"
      echo "  -w                        Enable URL rewriting"
      echo "  -y <rewrite_rules>        Set the URL rewrite rules"
      echo "  -v                        Enable debug mode"
      echo "  -h                        Display this help message"
      exit 0
      ;;
    *)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

# Set default log file if not provided
log_file=${log_file:-$default_log_file}

# Set default index file if not provided
index_file=${index_file:-$default_index_file}

# Check if the specified port is available
if ! check_port "$port"; then
  echo "Port $port is already in use. Please specify a different port."
  exit 1
fi

# Call the check_max_connections function
check_max_connections

# Start the Python HTTP server command
http_server_command="python3 -m http.server $port --bind $ip_address --directory ."

# Add options for CGI support and directory listing
if [ "$enable_cgi" = true ]; then
  http_server_command+=" --cgi"
fi
if [ "$enable_directory_listing" = true ]; then
  http_server_command+=" --directory-listing"
fi

# Add options for server address and hostname
if [ -n "$server_address" ]; then
  http_server_command+=" --bind $server_address"
fi
if [ -n "$server_hostname" ]; then
  http_server_command+=" --hostname $server_hostname"
fi

# Add options for SSL/TLS encryption
if [ "$enable_ssl" = true ]; then
  http_server_command+=" --ssl"
  if [ -n "$ssl_certificate" ] && [ -n "$ssl_key" ]; then
    http_server_command+=" --cert $ssl_certificate --key $ssl_key"
  else
    echo "Please specify both the SSL certificate and key files."
    exit 1
  fi
fi

# Add options for access log and log rotation
if [ "$enable_access_log" = true ]; then
  http_server_command+=" --access-log $access_log_file"
fi
if [ "$enable_log_rotation" = true ]; then
  if [ -z "$log_rotation_size" ]; then
    echo "Please specify the log rotation size using the -z option."
    exit 1
  fi
  http_server_command+=" --log-rotation $log_rotation_size"
fi

# Add options for IPv6 support
if [ "$enable_ipv6" = true ]; then
  http_server_command+=" --ipv6"
fi

# Add options for custom server name
if [ -n "$server_name" ]; then
  http_server_command+=" --server-name $server_name"
fi

# Add options for Gzip compression
if [ "$enable_gzip" = true ]; then
  http_server_command+=" --gzip"
fi

# Add options for caching
if [ "$enable_caching" = true ]; then
  http_server_command+=" --cache"
fi

# Add options for custom cache control header
if [ -n "$cache_control_header" ]; then
  http_server_command+=" --cache-control $cache_control_header"
fi

# Add options for CORS support
if [ "$enable_cors" = true ]; then
  http_server_command+=" --cors"
fi

# Add options for custom CORS header
if [ -n "$cors_header" ]; then
  http_server_command+=" --cors-header $cors_header"
fi

# Add options for server-side includes (SSI)
if [ "$enable_ssi" = true ]; then
  http_server_command+=" --ssi"
fi

# Add options for HTTP/2 support
if [ "$enable_http2" = true ]; then
  http_server_command+=" --http2"
fi

# Add options for custom SSI file extension
if [ -n "$ssi_file_extension" ]; then
  http_server_command+=" --ssi-extension $ssi_file_extension"
fi

# Add options for basic authentication
if [ "$enable_basic_auth" = true ]; then
  if [ -z "$username" ] || [ -z "$password" ]; then
    echo "Please specify both the username and password for basic authentication."
    exit 1
  fi
  http_server_command+=" --basic-auth $username:$password"
fi

# Add options for HTTPS redirection
if [ "$enable_https_redirection" = true ]; then
  http_server_command+=" --https-redirection"
  if [ -n "$redirection_url" ]; then
    http_server_command+=" --redirection-url $redirection_url"
  fi
fi

# Add options for server-side scripting
if [ "$enable_server_side_scripting" = true ]; then
  http_server_command+=" --server-side-scripting"
fi

# Add options for custom server-side script extension
if [ -n "$server_side_script_extension" ]; then
  http_server_command+=" --script-extension $server_side_script_extension"
fi

# Add options for request logging
if [ "$enable_request_logging" = true ]; then
  http_server_command+=" --request-logging"
  if [ -n "$request_log_file" ]; then
    http_server_command+=" --request-log-file $request_log_file"
  fi
fi

# Add options for URL rewriting
if [ "$enable_url_rewriting" = true ]; then
  http_server_command+=" --url-rewriting"
  if [ -n "$rewrite_rules" ]; then
    http_server_command+=" --rewrite-rules $rewrite_rules"
  fi
fi

# Redirect output to the log file unless quiet mode is enabled
if [ "$quiet_mode" = true ]; then
  http_server_command+=" > /dev/null 2>&1 &"
else
  http_server_command+=" > $log_file 2>&1 &"
fi

# Start the Python HTTP server in the background
eval $http_server_command

# Store the process ID of the server
server_pid=$!

# Check if the server started successfully
if [ $? -ne 0 ]; then
  echo "Failed to start the server."
  exit 1
fi

# Log the successful server startup
log_startup_info "Server started successfully." "$log_file"

# Display the server startup time unless in quiet mode
if [ "$quiet_mode" != true ]; then
  startup_time=$(date +"%Y-%m-%d %H:%M:%S")
  echo "Server started at: $startup_time"
fi

# Open the website in the default web browser unless in quiet mode
if [ "$quiet_mode" != true ]; then
  xdg-open "http://$ip_address:$port" >/dev/null 2>&1 &
fi

if [ "$debug_mode" = true ]; then
  echo "Server is running. You can access the website at: http://$ip_address:$port"
  echo "Log file: $log_file"
fi

# Check if the maximum number of connections has been reached before starting the server
check_max_connections

# Wait for the server to finish or until stopped manually
wait $server_pid

# Display the server stop time unless in quiet mode
if [ "$quiet_mode" != true ]; then
  stop_time=$(date +"%Y-%m-%d %H:%M:%S")
  echo "Server stopped at: $stop_time"
fi

# Log the server stoppage
log_startup_info "Server stopped at: $(date +"%Y-%m-%d %H:%M:%S")" "$log_file"

# Delete the log file
delete_log_file

lua-resty-logger
================

custome Logger class for ngx_lua/OpenResty

Thanks for dcshi / lua-resty-Logger

How to use?

local logger = require( "resty.logger" )

local log = logger:new('debug', '/tmp/logfile.log' )

log:info( 'I am info' )

log:debug( 'I am debug' )

log:error( "I am error' )

Author
======

Yan "KedyYan" Chenguang(闫晨光) <kedyyan@gmail.com>

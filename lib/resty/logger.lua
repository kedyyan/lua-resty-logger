-- Copyright (C) 2013 YanChenguang (kedyyan)

local bit = require "bit"
local ffi = require "ffi"
local ffi_new = ffi.new
local ffi_str = ffi.string
local C = ffi.C
local bor = bit.bor

local setmetatable = setmetatable
local localtime 	= ngx.localtime()
local ngx 			= ngx
local type 			= type


ffi.cdef[[
int write(int fd, const char *buf, int nbyte);
int open(const char *path, int access, int mode);
int close(int fd);
]]

local O_RDWR   = 0X0002
local O_CREAT  = 0x0040
local O_APPEND = 0x0400
local S_IRWXU  = 0x01C0
local S_IRGRP  = 0x0020
local S_IROTH  = 0x0004

-- log level
local LVL_DEBUG = 1
local LVL_INFO  = 2
local LVL_ERROR = 3
local LVL_NONE  = 999

module(...)

_VERSION = '0.1'

local mt = { __index = _M }

function new(self, log_type, logfile)
	local log_level, log_fd = nil

	local level = nil
	if 'debug' == log_type then 
		level = LVL_DEBUG
	elseif 'info' == log_type then 
		level = LVL_INFO
	elseif 'error' == log_type then 
		level = LVL_ERROR
	else 
		level = LVL_NONE
	end

	return setmetatable({
		log_level = level,
		log_fd = C.open(logfile, bor(O_RDWR, O_CREAT, O_APPEND), bor(S_IRWXU, S_IRGRP, S_IROTH)),
	},mt)
end


function debug(self, msg)
	if self.log_level > LVL_DEBUG then return end;

	local c = localtime .. "|" .."D" .. "|" .. msg .. "\n";
	C.write(self.log_fd, c, #c);
end

function info(self, msg)
	if self.log_level > LVL_INFO then return end;

	local c = localtime .. "|" .."I" .. "|" .. msg .. "\n";
	C.write(self.log_fd, c, #c);
end


function error(self, msg)
	if self.log_level > LVL_ERROR then return end;

	local c = localtime .. "|" .."E" .. "|" .. msg .. "\n";
	C.write(self.log_fd, c, #c);
end

local class_mt = { 
	-- to prevent use of casual module global variables
	__newindex = function (table, key, val)
		error('attempt to write to undeclared variable "' .. key .. '"')
	end 
}

setmetatable(_M, class_mt)

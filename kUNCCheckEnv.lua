local request_variations = {
	"request",
	"http_request",
	"httprequest",
	"bunni_request",
	"httpreq",
	"http.request"
}
local identifyexecutor_variations = {
	"identifyexecutor",
	"identify_executor",
	"getexecutorname",
	"get_executor_name",
	"getexecutor_name",
	"get_executorname",
	"getexecname",
	"get_exec_name",
	"get_execname",
	"getexec_name",
	"identifyexploit"
}
local gethui_variations = {
	"gethui",
	"gethiddenui",
	"get_hidden_ui",
	"get_hui",
	"gethiddengui",
	"get_hidden_gui",
	"get_hiddenui",
	"gethidden_ui",
	"get_hiddengui",
	"gethidden_gui"
}
local clipboard_variations = {
	"getclipboard",
	"get_clipboard",
	"setclipboard",
	"set_clipboard",
	"toclipboard",
	"to_clipboard",
	"set_rbx_clipboard",
	"setrbxclipboard"
}
local fps_variations = {
	"getfps",
	"get_fps",
	"setfps",
	"set_fps",
	"getfpscap",
	"get_fps_cap",
	"setfpscap",
	"set_fps_cap",
	"getframerate",
	"get_frame_rate",
	"setframerate",
	"set_frame_rate"
}
local env_variations = {
	"getgenv",
	"getrenv",
	"getsenv",
	"get_senv",
	"get_henv",
	"getmenv",
	"gettenv",
	"get_tenv",
	"getregistry",
	"getreg",
	"get_registry"
}
local fileio_variations = {
	"writefile",
	"write_file",
    "readfile",
	"read_file",
	"appendfile",
	"append_file",
	"dofile",
	"do_file",
	"loadfile",
	"load_file",
	"delfile",
	"del_file"
}
local folder_variations = {
	"makefolder",
	"make_folder",
	"delfolder",
	"del_folder",
	"listfiles",
	"list_files",
	"isfile",
	"is_file",
	"isfolder",
	"is_folder"
}
local hookfunc_variations = {
	"hookfunction",
	"hook_function",
	"unhookfunc",
	"unhook_function",
	"restorefunction",
	"restore_function",
	"restorefunc",
	"isfunctionhooked",
	"is_function_hooked"
}
local hookmetamethod_variations = {
	"hookmetamethod",
	"hook_meta_method",
	"hook_metamethod",
	"hookmeta_method"
}
local window_variations = {
	"set_window_name",
	"setwindowname",
	"set_window_title",
	"setwindowtitle"
}
local identity_variations = {
	"getidentity",
	"get_identity",
	"setidentity",
	"set_identity",
	"set_thread_identity",
	"setthreadidentity",
	"getthreadidentity"
}
local function safe_call(fn, ...)
	if type(fn) ~= "function" then
		return false, nil
	end;
	local ok, a, b, c, d = pcall(fn, ...)
	if not ok then
		return false, nil
	end;
	return true, {
		a,
		b,
		c,
		d
	}
end;
local function simple_pcall(fn, ...)
	if type(fn) ~= "function" then
		return false, nil
	end;
	local ok, res = pcall(fn, ...)
	return ok, res
end;
local function report(name, ok)
	if ok then
		print("working function " .. name)
	else
		print("missing/not working function " .. name)
	end
end;
local function check_request(list)
	for _, name in pairs(list) do
		local fn;
		if name == "http.request" then
			local http_table = rawget((getgenv or getfenv)(), "http")
			if type(http_table) == "table" then
				fn = rawget(http_table, "request")
			end
		else
			fn = (getgenv or getfenv)()[name]
		end;
		if type(fn) ~= "function" then
			print("missing/not working function " .. name)
		else
			local ok, res = simple_pcall(fn, {
				Url = "https://raw.githubusercontent.com/vaxtalastus-web/kUNC/refs/heads/main/UNCCheckEnv.lua",
				Method = "GET"
			})
			if not ok then
				print("not working function " .. name)
			else
				print("working function " .. name)
			end
		end
		task.wait(0.5)
	end
end;
local function check_identify_executor(list)
	for _, name in pairs(list) do
		local fn = (getgenv or getfenv)()[name]
		if type(fn) ~= "function" then
			print("missing/not working function " .. name)
		else
			local ok, res = simple_pcall(fn)
			if not ok or type(res) ~= "string" then
				print("not working function " .. name)
			else
				print("working function " .. name .. " -> " .. tostring(res))
			end
		end
	end
end;
local function check_gethui(list)
	for _, name in pairs(list) do
		local fn = (getgenv or getfenv)()[name]
		if type(fn) ~= "function" then
			print("missing/not working function " .. name)
		else
			local ok, res = simple_pcall(fn)
			if not ok or type(res) ~= "table" then
				print("not working function " .. name)
			else
				local ok2 = pcall(function()
					return res:IsA("BasePlayerGui")
				end)
				if ok2 then
					print("working function " .. name)
				else
					print("not working function " .. name)
				end
			end
		end
	end
end;
local function check_clipboard(list)
	local test_string = "test_clipboard_content"
	for _, name in pairs(list) do
		local fn = (getgenv or getfenv)()[name]
		if type(fn) ~= "function" then
			print("missing function " .. name)
		else
			local is_get = name:match("^get") or name:match("^to")
			if is_get then
				local ok, res = simple_pcall(fn)
				if ok and type(res) == "string" then
					print("working function " .. name)
				else
					print("not working function " .. name)
				end
			else
				local ok = pcall(fn, test_string)
				if ok then
					print("working function " .. name)
				else
					print("not working function " .. name)
				end
			end
		end
	end
end;
local function check_env_getters(list)
	for _, name in pairs(list) do
		local fn = (getgenv or getfenv)()[name]
		if type(fn) ~= "function" then
			print("missing/not working function " .. name)
		else
			local ok, res;
			if name == "get_senv" or name == "getsenv" then
				ok, res = simple_pcall(fn, script)
			else
				ok, res = simple_pcall(fn)
			end;
			if not ok or type(res) ~= "table" then
				print("not working function " .. name)
			else
				print("working function " .. name)
			end
		end
	end
end;
local function check_fps(list)
	for _, name in pairs(list) do
		local fn = (getgenv or getfenv)()[name]
		if type(fn) ~= "function" then
			print("missing function " .. name)
		else
			if name:match("^get") then
				local ok, res = simple_pcall(fn)
				if ok and type(res) == "number" then
					print("working function " .. name)
				else
					print("not working function " .. name)
				end
			else
				local ok = pcall(fn, 60)
				if ok then
					print("working function " .. name)
				else
					print("not working function " .. name)
				end
			end
		end
	end
end;
local function check_fileio(list)
	local test_filename = "testing_script_functionality.txt"
	local test_content = "print(\"Hello, world!\")"
	for _, name in next, list do
		local fn = (getgenv or getfenv)()[name]
		if type(fn) ~= "function" then
			print("missing function " .. name)
		else
			if name:match("write") or name:match("append") then
				local ok = pcall(fn, test_filename, test_content)
				if ok then
					print("working function " .. name)
				else
					print("not working function " .. name)
				end
			elseif name:match("read") or name:match("^do") or name:match("^load") then
				local ok = pcall(fn, test_filename)
				if ok then
					print("working function " .. name)
				else
					print("not working function " .. name)
				end
			elseif name:match("del") then
				local ok = pcall(fn, test_filename)
				if ok then
					print("working function " .. name)
				else
					print("not working function " .. name)
				end
			else
				print("not tested function " .. name)
			end
		end
	end
end;
local function check_folder(list)
	local test_folder_name = "testing_folder_functionality"
	local test_path = "./"
	for _, name in pairs(list) do
		local fn = (getgenv or getfenv)()[name]
		if type(fn) ~= "function" then
			print("missing function " .. name)
		else
			if name:match("make") or name:match("del") then
				local ok = pcall(fn, test_folder_name)
				if ok then
					print("working function " .. name)
				else
					print("not working function " .. name)
				end
			elseif name:match("list") then
				local ok, data = pcall(fn, test_path)
				if not ok then
					ok, data = pcall(fn)
				end
				if ok and type(data) == "table" then
					print("working function " .. name)
				else
					print("not working function " .. name)
				end
			elseif name:match("is") then
				local ok, data = pcall(fn, test_path)
				if ok and type(data) == "boolean" then
					print("working function " .. name)
				else
					print("not working function " .. name)
				end
			else
				print("not tested function " .. name)
			end
		end
	end
end
local function check_hooks(list)
	local dummy = function()
	end;
	for _, name in pairs(list) do
		local fn = (getgenv or getfenv)()[name]
		if type(fn) ~= "function" then
			print("missing function " .. name)
		else
			if name:match("isfunctionhooked") then
				local ok, res = simple_pcall(fn, dummy)
				if ok and type(res) == "boolean" then
					print("working function " .. name)
				else
					print("not working function " .. name)
				end
			else
				print("working function " .. name)
			end
		end
	end
end;
local function check_misc(list)
	for _, name in pairs(list) do
		local fn = (getgenv or getfenv)()[name]
		if fn then
			print("working function " .. name)
		else
			print("missing function " .. name)
		end
	end
end;
local function check_hookmetamethod(list)
	for _, name in pairs(list) do
		local fn = (getgenv or getfenv)()[name]
		if type(fn) ~= "function" then
			print("missing function " .. name)
		else
			local worked = false;
			local t = {}
			local orig_meta = {
				__index = function(_, k)
					if k == "hi" then
						return 67
					end;
					return nil
				end
			}
			setmetatable(t, orig_meta)
			if t.hi ~= 67 then
				print("metatable setup failed for " .. name)
			else
				local ok, old = pcall(fn, t, "__index", function(self, k)
					if k == "hi" then
						return 0
					end
				end)
				if ok then
					if t.hi == 0 then
						worked = true
					end
				end;
				if worked then
					print("working function " .. name .. " -> returned old: " .. tostring(old))
				else
					print("not working function " .. name)
				end;
				local restored = false;
				if ok then
					if type(old) == "function" then
						pcall(fn, t, "__index", old)
						if t.hi == 67 then
							restored = true
						end
					else
						pcall(setmetatable, t, orig_meta)
						if t.hi == 67 then
							restored = true
						end
					end
				else
					pcall(setmetatable, t, orig_meta)
					if t.hi == 67 then
						restored = true
					end
				end;
				if not restored then
					pcall(setmetatable, t, orig_meta)
				end
			end
		end
	end
end;
print("\n--- Request Function Checks ---")
check_request(request_variations)
print("\n--- Executor Identify Checks ---")
check_identify_executor(identifyexecutor_variations)
print("\n--- GetHui Checks ---")
check_gethui(gethui_variations)
print("\n--- Clipboard Function Checks ---")
check_clipboard(clipboard_variations)
print("\n--- Environment Getter Checks ---")
check_env_getters(env_variations)
print("\n--- FPS/Framerate Function Checks ---")
check_fps(fps_variations)
print("\n--- File I/O Function Checks ---")
check_fileio(fileio_variations)
print("\n--- Folder & Status Function Checks ---")
check_folder(folder_variations)
print("\n--- Hook/Closure Function Checks ---")
check_hooks(hookfunc_variations)
print("\n--- Hook Metamethod Variations ---")
check_hookmetamethod(hookmetamethod_variations)
print("\n--- Window & Identity Variations ---")
check_misc(window_variations)
check_misc(identity_variations)

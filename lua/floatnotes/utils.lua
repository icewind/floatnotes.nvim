local Utils = {}

function Utils.path(parts)
	if type(parts) ~= "table" then
		parts = { parts }
	end
	return vim.fs.joinpath(parts)
end

function Utils.file_exists(filepath)
	if vim.fn.filewritable(filepath) == 0 then
		return false
	end
	return true
end

function Utils.ensure_file(path) end

return Utils

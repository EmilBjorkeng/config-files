-- Main function
function line_comment()

    -- Get current line and exit if its empty
	local current_line = vim.api.nvim_get_current_line()
	if current_line == '' then return end
	
    -- Get the filetype from the filename
	local filename = vim.api.nvim_buf_get_name(0)
	local filetype = string.lower(string.sub(
        filename,
        string.len(filename)-string.find(string.reverse(filename),'%.')+2,
        string.len(filename)
    ))
	
    -- Use the comment_chars table to get the comment character based on the filetype
    -- And exit if it can't find any
    local comment_chars = {
		c='//',h='//',cpp='//',hpp='//',java='//',
		js='//',php='//',swift='//',go='//',rs='//',
		kt='//',scala='//',ts='//',py='#',rb='#',
		pl='#',sh='#',lua='--',sql='--',asm=';'
	}
    local comment_char = table_value(comment_chars, filetype)
	if comment_char == '' then
		print("Coun't find the comment character based on filetype")
		return
	end
    -- Add a space to the end of the comment char
    comment_char = comment_char .. ' '
	
    -- Get the first non space character and exit if it can't find any
    local first_non_space = get_first_non_space(current_line)
    if first_non_space == 0 then return end

    -- Check if the line is comment out or not
    if string.sub(
        current_line,
        first_non_space,
        first_non_space+string.len(comment_char)-1
    )== comment_char then

        -- Remove the comment character
		vim.api.nvim_set_current_line(
            string.sub(current_line,1,first_non_space-1) ..
            string.sub(
                current_line,
                first_non_space+string.len(comment_char),
                string.len(current_line)
            )
        )
    else
        -- Add the comment character
		vim.api.nvim_set_current_line(
            string.sub(current_line,1,first_non_space-1) ..
            comment_char ..
            string.sub(current_line,first_non_space,string.len(current_line))
        )
	end
end

-- Return the table value based on the key
function table_value(tbl, key)
	for k,v in pairs(tbl) do
		if k == key then
            		return v
        	end
    	end
	return ''
end

-- Return the index of the first non space character in a string
function get_first_non_space(str)
    for i=1,string.len(str),1 do
        local char = string.sub(str,i,i)
        if char ~= ' ' then
            return i
        end
    end
    return 0
end

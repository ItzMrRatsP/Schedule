local Output = {}

Output.Message = "[Console]"
Output.Type = "Default" -- Default type = Debug

local Messages = require(script.Parent.Components.ErrorToMessage)

function Output:Warn(Error: string, ...)
	local ErrorMessage = Messages[Error]

	if not ErrorMessage then
		warn(
			"Couldn't find this error message, Try looking up the ErrorToMessage."
		)
		return
	end

	return warn(`{self.Message} {string.format(ErrorMessage, ...)}`)
end

return table.freeze(Output)

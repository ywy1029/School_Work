note
	description: "Singleton access to the default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	EHEALTH_ACCESS

feature
	m: EHEALTH
		once
			create Result.make
		end

invariant
	m = m
end





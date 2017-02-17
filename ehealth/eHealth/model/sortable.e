note
	description: "Objects can be compared by id."
	author: "Yuchen Song"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SORTABLE

inherit
	COMPARABLE
	redefine is_less end

feature
	id: INTEGER_64

feature -- compare

	is_less alias "<" (other: like current): BOOLEAN
		do
			if id < other.id then
				Result := true
			else
				Result := false
			end
		end
end
